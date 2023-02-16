public with sharing class MaintenanceRequestHelper {
    public static void createMaintenanceRequest(List<Case> cases, Map<Id, Case> oldCases) {
        Set<Id> caseIds = new Set<Id>();

        for (Case caseItem : cases) {
            if(oldCases.get(caseItem.Id).Status != 'Closed' && caseItem.Status == 'Closed') {
                if(caseItem.Type == 'Repair' || caseItem.Type == 'Routine Maintenance') {
                    caseIds.add(caseItem.Id);
                }
            }
        }

        List<Case> newCases = new List<Case>();
        Map<Id, Case> closedCases = new Map<Id, Case>(MaintenanceRequestSelector.getCasesById(caseIds));
        Map<Id, Decimal> maintenanceCycleMap = getMaintenanceCycle(caseIds);

        for (Case caseItem : closedCases.values()) {
            newCases.add(buildCase(
                caseItem.Equipment__c,
                caseItem.Id,
                caseItem.Vehicle__c,
                maintenanceCycleMap
            ));
        }

        if(!newCases.isEmpty()) {
            insert newCases;            
        }

        List<Equipment_Maintenance_Item__c> itemsToinsert = new List<Equipment_Maintenance_Item__c>();
            for (Case newCase : newCases) {
                for (Equipment_Maintenance_Item__c item : closedCases.get(newCase.ParentId).Equipment_Maintenance_Items__r) {
                    itemsToinsert.add(buildEquipmentMaintenanceItem(
                        item, newCase
                    ));
                }
            }

        if(!itemsToinsert.isEmpty()) {
            insert itemsToinsert;
        }
    }

    private static Map<Id, Decimal> getMaintenanceCycle(Set<Id> caseIds) {
        List<AggregateResult> maintenanceCycles = MaintenanceRequestSelector.getMaintenanceCycles(caseIds);
        Map<Id, Decimal> maintenanceCycleMap = new Map<Id, Decimal>();

        for (AggregateResult result : maintenanceCycles) {
            maintenanceCycleMap.put((Id)result.get('Maintenance_Request__c'), (Decimal)result.get('cycle'));
        }

        return maintenanceCycleMap;
    }

    private static Case buildCase(
        Id equipmentId, 
        Id existingCaseId, 
        Id vehicleId, 
        Map<Id, Decimal> maintenanceCycleMap
    ) {
        return new Case(
            ParentId = existingCaseId,
            Status = 'New',
            Type = 'Routine Maintenance',
            Origin = 'Email',
            Subject = 'Routine Maintenance',
            Date_Reported__c = Date.today(),
            Vehicle__c = vehicleId,
            Equipment__c = equipmentId,
            Date_Due__c = Date.today().addDays((Integer)maintenanceCycleMap.get(existingCaseId))
        );
    }

    private static Equipment_Maintenance_Item__c buildEquipmentMaintenanceItem(
        Equipment_Maintenance_Item__c existingItem, 
        Case newCase
    ) {
        return new Equipment_Maintenance_Item__c(
            Equipment__c = existingItem.Equipment__c,
            Quantity__c = existingItem.Quantity__c,
            Maintenance_Request__c = newCase.Id
        );
    }
}