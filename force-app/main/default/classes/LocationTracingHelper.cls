/********************************************************************************************
* Name      : LocationTracingHelper
* Purpose   : Helper to LocationTracingTriggerHandler
* Author    : Bruna Girão
* Date      : 22/03/2022
-------------------------------------------------------------------------------------------
22/03/2022           Bruna Girão         create class 
********************************************************************************************/
public with sharing class LocationTracingHelper {
   
    /**
    * Check if has duplicate records
    * @param newRecordsList 
    **/
    public static void checkDuplicates(List<Location_Tracing__c> newRecordsList) {
        //get the duplicate records list
        List<Location_Tracing__c> duplicateRecords = CTLocationTracingController.checkDuplicates(newRecordsList);
        //show an error from the user
        for(Location_Tracing__c lt : duplicateRecords) {
            lt.addError(System.Label.CT_LOCATION_TRACING_DUPLICATE_RECORD);
        }
    }
}
