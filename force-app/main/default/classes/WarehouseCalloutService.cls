public with sharing class WarehouseCalloutService implements Queueable {
    private static final String ENDPOINT_URL = 'https://th-superbadge-apex.herokuapp.com/equipment';
    private static final String GET_METHOD = 'GET';

    @future(callout=true)
    public static void syncWarehouseEquipments() {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(ENDPOINT_URL);
        request.setHeader('Content-Type','application/json'); 
        request.setMethod(GET_METHOD);

        HttpResponse response = http.send(request);
        
        List<Product2> equipments = new List<Product2>();
        
        if (response.getStatusCode() == 200) {
            List<Object> jsonResponse = (List<Object>)JSON.deserializeUntyped(response.getBody());
      
            for (Object equipment : jsonResponse) {
                Map<String, Object> jsonMap = (Map<String, Object>)equipment;
                
                equipments.add(new Product2(
                    ProductCode = (String) jsonMap.get('_id'),
                    Replacement_Part__c = (Boolean) jsonMap.get('replacement'),
                    Current_Inventory__c = (Double) jsonMap.get('quantity'),
                    Name = (String) jsonMap.get('name'),
                    Maintenance_Cycle__c = (Integer) jsonMap.get('maintenanceperiod'),
                    Lifespan_Months__c = (Integer) jsonMap.get('lifespan'),
                    Cost__c = (Integer) jsonMap.get('cost'),
                    Warehouse_SKU__c = (String) jsonMap.get('sku')
                ));
            }
            
            if (!equipments.isEmpty()) {
                upsert equipments;
            }
        }
    }
    
    public static void execute(QueueableContext context) {
        syncWarehouseEquipments();
    }
}