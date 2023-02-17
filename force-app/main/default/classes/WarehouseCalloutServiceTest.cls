@IsTest
private class WarehouseCalloutServiceTest {
    @IsTest
    static void testCallout() {
        Test.startTest();
            Test.setMock(HTTPCalloutMock.class, new WarehouseCalloutServiceMock());
            Id jobId = System.enqueueJob(new WarehouseCalloutService());
        Test.stopTest();

        AsyncApexJob apexJob = [SELECT Id, Status FROM AsyncApexJob WHERE Id =: jobId];

        Assert.areEqual(apexJob.Status, 'Completed');
    }
}