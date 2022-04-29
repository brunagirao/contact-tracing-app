public with sharing class CTHealthHeaderController {
    
    @AuraEnabled
    public static Map<String, Integer> getPersonHealthStatusCount(){
        try {
            return CTPersonController.getHealthStatusCount();
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static Map<String, Integer> getLocationHealthStatusCount(){
        try {
            return CTLocationController.getHealthStatusCount();
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}
