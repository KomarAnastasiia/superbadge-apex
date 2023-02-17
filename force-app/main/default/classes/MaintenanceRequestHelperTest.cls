@IsTest
private class MaintenanceRequestHelperTest {
    @TestSetup
    static void setup() {
        TestDataBuilder dataBuilder = new TestDataBuilder();

        Vehicle__c vehicle = dataBuilder.buildVehicle();
        insert vehicle;

        Product2 equipment = dataBuilder.buildEquipment();
        insert equipment;

        Case maintenanceRequest = dataBuilder.buildMaintenanceRequest(vehicle.Id, equipment.Id);
        insert maintenanceRequest;

        Equipment_Maintenance_Item__c item = dataBuilder.buildEquipmentMaintenanceItem(
            equipment.Id, 
            maintenanceRequest.Id
        );
        insert item;
    }

    @isTest
    private static void maintenanceRequestPositive() {
        Case maintenanceRequest = [SELECT Id, Status FROM Case LIMIT 1];

        Test.startTest();
            maintenanceRequest.Status = 'Closed';
            update maintenanceRequest;
        Test.stopTest();

        Case newCase = [
            SELECT Id, Subject, Type, Date_Reported__c
            FROM Case
            WHERE Status = 'New' 
        ];

        Equipment_Maintenance_Item__c newItem = [
            SELECT Id
            FROM Equipment_Maintenance_Item__c
            WHERE Maintenance_Request__c =: newCase.Id
        ];

        Assert.isTrue(newItem != null);
        Assert.areEqual(newCase.Subject, 'Routine Maintenance');
        Assert.areEqual(newCase.Type, 'Routine Maintenance');
        Assert.areEqual(newCase.Date_Reported__c, Date.today());
    }

    @isTest
    private static void maintenanceRequestNegative() {
        Case maintenanceRequest = [SELECT Id, Status FROM Case LIMIT 1];

        Test.startTest();
            maintenanceRequest.Status = 'Working';
            update maintenanceRequest;
        Test.stopTest();

        List<Case> allCases = [SELECT Id FROM Case];

        Assert.areEqual(allCases.size(), 1);
    }
}