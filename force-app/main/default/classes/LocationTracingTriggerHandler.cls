/********************************************************************************************
* Name      : LocationTracingTriggerHandler
* Purpose   : Handler to LocationTracingTrigger
* Author    : Bruna Girão
* Date      : 22/03/2022
-------------------------------------------------------------------------------------------
22/03/2022           Bruna Girão         create class 
********************************************************************************************/
public with sharing class LocationTracingTriggerHandler {
    
    List<Location_Tracing__c> newRecordsList {get; set;}
    List<Location_Tracing__c> oldRecordsList {get; set;}
    Map<Id, Location_Tracing__c> newRecordsMap {get; set;}
    Map<Id, Location_Tracing__c> oldRecordsMap {get; set;}
    
    public static Boolean runTrigger;

    static {
        runTrigger = true;
    }

    public static Boolean isTriggerEnabed() {
        return runTrigger;
    }

    public static Boolean enableTrigger() {
        return runTrigger = true;
    }

    public static Boolean disableTrigger() {
        return runTrigger = false;
    }

    public LocationTracingTriggerHandler() {}

    public LocationTracingTriggerHandler(
        List<Location_Tracing__c> newRecordsList,
        List<Location_Tracing__c> oldRecordsList,
        Map<Id, Location_Tracing__c> newRecordsMap,
        Map<Id, Location_Tracing__c> oldRecordsMap

    ) {
        this.newRecordsList = newRecordsList;
        this.oldRecordsList = oldRecordsList;
        this.newRecordsMap  = newRecordsMap;
        this.oldRecordsMap  = oldRecordsMap;
    }
}
