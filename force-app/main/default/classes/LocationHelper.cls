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
    public static void updateStatudUpdateDate(Map<Id,Location__c> newRecordsMap, Map<Id,Location__c> oldRecordsMap) {

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

}
