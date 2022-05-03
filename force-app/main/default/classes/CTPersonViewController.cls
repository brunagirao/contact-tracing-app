public with sharing class CTPersonViewController {
    
    @AuraEnabled
    public static void updateHealthStatus(String personId){
        try {

           Person__c person = new Person__c(Id = personId);
           person.Health_Status__c = 'Red';
           update person;
           
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}
