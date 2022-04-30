public with sharing class CTRecentChangesController {
    
    @AuraEnabled
    public static List<Person__c> getRecentPersonHealthChanges(){
        try {
            return CTPersonController.getRecentHealthChanges();
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static List<Location__c> getRecentLocationHealthChanges(){
        try {
            return CTLocationController.getRecentStatusChanges();
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static List<Person__c> searchPeople(String searchTerm){
        try {
            return CTPersonController.searchPeople(searchTerm);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static List<Location__c> searchLocations(String searchTerm){
        try {
            return CTLocationController.searchLocations(searchTerm);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}
