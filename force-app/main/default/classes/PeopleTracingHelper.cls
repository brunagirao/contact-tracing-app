/********************************************************************************************
* Name      : PeopleTracingHelper
* Purpose   : Helper to PeopleTracingTriggerHandler
* Author    : Bruna Girão
* Date      : 22/03/2022
-------------------------------------------------------------------------------------------
22/03/2022           Bruna Girão         create class 
********************************************************************************************/
public with sharing class PeopleTracingHelper {
    
    /**
    * Check if has duplicate records
    * @param newRecordsList 
    **/
    public static void checkDuplicates(List<People_Tracing__c> newRecordsList) {
        //get the duplicate records list
        List<People_Tracing__c> duplicateRecords = CTPeopleTracingController.checkDuplicates(newRecordsList);

        //show an error from the user
        for(People_Tracing__c pt : duplicateRecords) {
            pt.addError(System.Label.CT_PEOPLE_TRACING_DUPLICATE_RECORD);
        }

    }   
}
