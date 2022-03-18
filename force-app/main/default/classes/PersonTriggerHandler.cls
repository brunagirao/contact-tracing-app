/********************************************************************************************
* Name      : PersonTrigger
* Purpose   : Trigger to Person__c Object
* Author    : Bruna Girão
* Date      : 18/03/2022
-------------------------------------------------------------------------------------------
18/03/2022           Bruna Girão         create Trigger 
********************************************************************************************/
public with sharing class PersonTriggerHandler {
    
    List<Person__c> newRecords {get; set;}
    List<Person__c> oldRecords {get; set;}
    Map<Id, Person__c> newRecordsMap {get; set;}
    Map<Id, Person__c> oldRecordsMap {get; set;}

    public PersonTriggerHandler(
        List<Person__c> newRecords,
        List<Person__c> oldRecords,
        Map<Id, Person__c> newRecordsMap,
        Map<Id, Person__c> oldRecordsMap
    ) {
        this.newRecords = newRecords; 
        this.oldRecords = oldRecords; 
        this.newRecordsMap = newRecordsMap;
        this.oldRecordsMap = oldRecordsMap; 
    }

}
