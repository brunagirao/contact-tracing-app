/********************************************************************************************
* Name      : PeopleTracingTriggerHandler
* Purpose   : Handler to PeopleTracingTrigger
* Author    : Bruna Girão
* Date      : 22/03/2022
-------------------------------------------------------------------------------------------
22/03/2022           Bruna Girão         create class 
********************************************************************************************/
public with sharing class PeopleTracingTriggerHandler {
    
    List<People_Tracing__c> newRecordsList {get; set;}
    List<People_Tracing__c> oldRecordsList {get; set;}
    Map<Id, People_Tracing__c> newRecordsMap {get; set;}
    Map<Id, People_Tracing__c> oldRecordsMap {get; set;}
    
    public static Boolean runTrigger;

    static {
        runTrigger = true;
    }

    public static Boolean isTriggerEnabled() {
        return runTrigger;
    }

    public static Boolean enableTrigger() {
        return runTrigger = true;
    }

    public static Boolean disableTrigger() {
        return runTrigger = false;
    }

    public PeopleTracingTriggerHandler(){}

    public PeopleTracingTriggerHandler(
        List<People_Tracing__c> newRecordsList,
        List<People_Tracing__c> oldRecordsList,
        Map<Id, People_Tracing__c> newRecordsMap,
        Map<Id, People_Tracing__c> oldRecordsMap

    ){
        this.newRecordsList = newRecordsList;
        this.oldRecordsList = oldRecordsList;
        this.newRecordsMap  = newRecordsMap;
        this.oldRecordsMap  = oldRecordsMap;
    }
}
