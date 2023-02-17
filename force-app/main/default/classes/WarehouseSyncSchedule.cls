global class WarehouseSyncSchedule implements Schedulable {
    public static String CRON_EXP = '0 0 1 1/1 * ? *';

    global void execute(System.SchedulableContext context) {
        System.enqueueJob(new WarehouseCalloutService());
    }
}

//System.schedule('WarehouseSyncScheduleJob', WarehouseSyncSchedule.expression, new WarehouseSyncSchedule());