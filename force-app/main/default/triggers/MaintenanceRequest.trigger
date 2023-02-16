trigger MaintenanceRequest on Case (after update) {
    if(Trigger.isAfter) {
        MaintenanceRequestHelper.createMaintenanceRequest(Trigger.new, Trigger.oldMap);        
    }
}