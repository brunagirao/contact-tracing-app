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

    /**
    * Update the Health Status of the cohabitants, neighbour, primary and secondary contats
    * when the Health Status change to Red
    * @param newRecordsMap 
    * @param oldRecordsMap 
    * @return Set<Id> 
    **/
    public static Set<Id> updateHealthStatus(Map<Id, Person__c> newRecordsMap, Map<Id, Person__c> oldRecordsMap) {
        Set<Id> peopleStatusChangeSet  = new Set<Id>();
        Set<Id> peopleRedStatusSet     = new Set<Id>();

        for(String key : newRecordsMap.keySet()) {
            //get new and old person
            Person__c newPerson = newRecordsMap.get(key);
            Person__c oldPerson = oldRecordsMap.get(key);
            //add all persons that have your health status change includes to Red
            if(newPerson.Health_Status__c != oldPerson.Health_Status__c) {
                peopleStatusChangeSet.add(newPerson.Id);
            }
            //add all persons that have your health status change only to Red
            if(newPerson.Health_Status__c == 'Red' && oldPerson.Health_Status__c != 'Red') {
                peopleRedStatusSet.add(newPerson.Id);
            }
        }
        
        Set<Id> peopleOrangeStatusSet  = new Set<Id>();
        Set<Id> peopleYellowStatusSet  = new Set<Id>();
        //set to verify people already processed
        Set<Id> peopleAlreadyProcessed = new Set<Id>();
        //add the red people
        peopleAlreadyProcessed.addAll(peopleRedStatusSet);
        
        //add Cohabitants
        peopleOrangeStatusSet.addAll(CTPersonController.getCohabitants(peopleRedStatusSet, peopleAlreadyProcessed));
        //add Cohabitants Primary Contacts
        Set<Id> primaryContactsId = CTPersonController.getPrimaryContacts(peopleRedStatusSet,peopleAlreadyProcessed);
        peopleOrangeStatusSet.addAll(primaryContactsId);
        //add Neighbours Primary Contacts
        peopleYellowStatusSet.addAll(CTPersonController.getNeighbours(peopleRedStatusSet, peopleAlreadyProcessed));
        //add Neighbours Primary Contacts
        peopleYellowStatusSet.addAll(CTPersonController.getSecondaryContacts(primaryContactsId, peopleAlreadyProcessed));

        List<Person__c> personsToUpdate = new List<Person__c>();
        //add the people to orange status
        for(Id personId : peopleOrangeStatusSet) {
            personsToUpdate.add(new Person__c (Id = personId, Health_Status__c = 'Orange'));
        }
        //add the people to yellow status
        for(Id personId : peopleYellowStatusSet) {
            personsToUpdate.add(new Person__c (Id = personId, Health_Status__c = 'Yellow'));
        }

        //update the people status to orange or yellow 
        if(!personsToUpdate.isEmpty()) {
            update personsToUpdate;
        }
        
        return peopleStatusChangeSet;

    }
}
