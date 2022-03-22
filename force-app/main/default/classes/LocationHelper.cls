/********************************************************************************************
* Name      : LocationHelper
* Purpose   : Helper to LocationTriggerHandler
* Author    : Bruna Girão
* Date      : 22/03/2022
-------------------------------------------------------------------------------------------
22/03/2022           Bruna Girão         create class 
********************************************************************************************/
public with sharing class LocationHelper {
    
    /**
    * Validate some data of new Location__c record 
    * @param newRecordsList 
    **/
    public static void validateNewLocationData(List<Location__c> newRecordsList) {
        
        //make sure the Status is always Green 
        for(Location__c location : newRecordsList) {
            if(location.Status__c != 'Green') {
                location.Status__c = 'Green';
            }
        }
    }

    /**
    * Update the Status_Update_Date__c when the Status__c change
    * @param newRecordsMap 
    * @param oldRecordsMap 
    **/
    public static void updateStatusUpdateDate(Map<Id,Location__c> newRecordsMap, Map<Id,Location__c> oldRecordsMap) {

        for(Id key : newRecordsMap.keySet()){
            //get the old and new location
            Location__c newLocation = newRecordsMap.get(key);
            Location__c oldLocation = oldRecordsMap.get(key);

            //check if has a modification in the Status__c
            if(newLocation.Status__c != oldLocation.Status__c) {
                //if has, update Status_Update_Date__c field
                newLocation.Status_Update_Date__c = Date.today();
            }
        }
    }

    /**
    * Get all the location traces with red status and that have visited by people in the last 10 days
    * and update the health status people to yellow
    * @param newRecordsList 
    **/
    public static void updatePeopleToYellowStatus(List<Location__c> newRecordsList) {

        Set<Id> locationsId = new Set<Id>();
        
        for(Location__c location : newRecordsList) {
            //add the location with red status
            if(location.Status__c == 'Red') {
                locationsId.add(location.Id);
            }
        }

        //get all the location traces with have visited by people in the last 10 days
        List<Location_Tracing__c> locationTraces = CTLocationTracingController.getLocationsByLocationIds(locationsId);
        
        if(locationTraces != null && !locationTraces.isEmpty()) {

            Set<Id> personIds = new Set<Id>();
            //add all persons id that visited the locations
            for(Location_Tracing__c lt : locationTraces) {
                personIds.add(lt.Person__c);
            }

            if(!personIds.isEmpty()) {

                List<Person__c> peopleToUpdate = new List<Person__c>();
                //change all the people with the yellow status
                for(Id personId : personIds) {
                    peopleToUpdate.add( 
                        new Person__c(
                            Id = personId,
                            Health_Status__c = 'Yellow'
                        )
                    );
                }
                //update the people to yellow status
                if(!peopleToUpdate.isEmpty()) {
                    update peopleToUpdate;
                }
            }
        }

    }

}
