global class WarehouseSyncSchedule implements Schedulable {
    public static String CRON_EXP = '0 0 1 1/1 * ? *';

    global void execute(System.SchedulableContext context) {
        WarehouseCalloutService.syncWarehouseEquipments();
    }
}

//System.schedule('Warehouse Sync', WarehouseSyncSchedule.expression, new WarehouseSyncSchedule());