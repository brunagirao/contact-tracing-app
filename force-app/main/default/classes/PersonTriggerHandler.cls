/********************************************************************************************
* Name      : PersonTriggerHandler
* Purpose   : Handler to PersonTrigger
* Author    : Bruna Girão
* Date      : 18/03/2022
-------------------------------------------------------------------------------------------
18/03/2022           Bruna Girão         create Trigger 
19/03/2022           Bruna Girão         create new methods
********************************************************************************************/
public with sharing class PersonTriggerHandler {
    
    List<Person__c> newRecordsList {get; set;}
    List<Person__c> oldRecordsList {get; set;}
    Map<Id, Person__c> newRecordsMap {get; set;}
    Map<Id, Person__c> oldRecordsMap {get; set;}

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

    public PersonTriggerHandler(){}

    public PersonTriggerHandler(
        List<Person__c> newRecordsList,
        List<Person__c> oldRecordsList,
        Map<Id, Person__c> newRecordsMap,
        Map<Id, Person__c> oldRecordsMap
    ) {
        this.newRecordsList = newRecordsList; 
        this.oldRecordsList = oldRecordsList; 
        this.newRecordsMap  = newRecordsMap;
        this.oldRecordsMap  = oldRecordsMap; 
    }

}