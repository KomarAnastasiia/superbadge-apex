@IsTest
private class WarehouseSyncScheduleTest {
    @IsTest
    static void testSchedule() {
        Test.setMock(HttpCalloutMock.class, new WarehouseCalloutServiceMock());

        String jobId = System.schedule(
            'WarehouseSyncScheduleJob',
            WarehouseSyncSchedule.CRON_EXP, 
            new WarehouseSyncSchedule()
        );
        CronTrigger cronTrigger = [
            SELECT Id, CronExpression, NextFireTime 
            FROM CronTrigger 
            WHERE Id =: jobId
        ]; 
        
        Assert.areEqual(WarehouseSyncSchedule.CRON_EXP, cronTrigger.CronExpression);
        Assert.areEqual('2023-02-18 01:00:00', String.valueOf(cronTrigger.NextFireTime));
    }
}