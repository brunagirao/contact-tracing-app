/********************************************************************************************
* Name      : PersonHelper
* Purpose   : Helper to PersonTriggerHandler
* Author    : Bruna Girão
* Date      : 18/03/2022
-------------------------------------------------------------------------------------------
18/03/2022           Bruna Girão         create Trigger
19/03/2022           Bruna Girão         create checkHealthStatus method 
                                         create updateStatusUpdateDate method 
********************************************************************************************/
public with sharing class PersonHelper {

    /**
    * Validate some data of new Person__c record 
    * @param newRecordsList 
    **/
    public static void validateNewPersonData(List<Person__c> newRecordsList) {

        for(Person__c person : newRecordsList) {

            //make sure the Health Status is always Green 
            if(person.Health_Status__c != 'Green') {
                person.Health_Status__c = 'Green';
            }

            //generate the token 
            if(person.Mobile__c != null) {
                person.Token__c = CTPersonController.getToken(person.Mobile__c);
            }
            
        }
    }

    
    /**
    * Update the Status_Update_Date__c when the Health_Status__c change
    * @param newRecordsMap 
    * @param oldRecordsMap 
    **/
    public static void updateStatusUpdateDate(Map<Id, Person__c> newRecordsMap, Map<Id, Person__c> oldRecordsMap) {

        for(String key :  newRecordsMap.keySet()) {
            //get the new and old Person record in the map
            Person__c newPerson = newRecordsMap.get(key);
            Person__c oldPerson = oldRecordsMap.get(key);

            //check if has a modification in the Health_Status__c
            if(newPerson.Health_Status__c != oldPerson.Health_Status__c) {
                // if has, update the Status_Update_Date__c field
                newPerson.Status_Update_Date__c = Date.today();
            }
        }
    }
}
