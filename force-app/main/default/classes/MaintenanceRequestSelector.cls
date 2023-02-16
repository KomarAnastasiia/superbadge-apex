public with sharing class MaintenanceRequestSelector {
    public static List<Case> getCasesById(Set<Id> caseIds) {
        return [
            SELECT Id, Vehicle__c, Equipment__c, Equipment__r.Maintenance_Cycle__c,
                (
                    SELECT Id, Equipment__c, Quantity__c 
                    FROM Equipment_Maintenance_Items__r
                ) 
            FROM Case 
            WHERE Id IN : caseIds
        ];
    }

    public static List<AggregateResult> getMaintenanceCycles(Set<Id> caseIds) {
        return [
            SELECT Maintenance_Request__c, 
            MIN(Equipment__r.Maintenance_Cycle__c)cycle
            FROM Equipment_Maintenance_Item__c 
            WHERE Maintenance_Request__c IN : caseIds 
            GROUP BY Maintenance_Request__c
        ];
    }
}