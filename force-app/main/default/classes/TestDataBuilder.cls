@IsTest
public class TestDataBuilder {
    public Case buildMaintenanceRequest(Id vehicleId, Id equipmentId) {
        return new Case(
            Status = 'New',
            Type = 'Routine Maintenance',
            Origin = 'Email',
            Subject = 'Routine Maintenance',
            Vehicle__c = vehicleId,
            Equipment__c = equipmentId
        );
    }

    public Vehicle__c buildVehicle() {
        return new Vehicle__c(
            Name = 'Test Vehicle'
        );
    }

    public Product2 buildEquipment() {
        return new Product2(
            Name = 'Test Equipment',
            Lifespan_Months__c = 12,
            Maintenance_Cycle__c = 2,
            Replacement_Part__c = true
        );
    }

    public Equipment_Maintenance_Item__c buildEquipmentMaintenanceItem(Id equipmentId, Id requestId) {
        return new Equipment_Maintenance_Item__c(
            Equipment__c = equipmentId,
            Maintenance_Request__c = requestId
        );
    }
}