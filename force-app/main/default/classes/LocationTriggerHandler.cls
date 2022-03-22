/********************************************************************************************
* Name      : LocationTriggerHandler
* Purpose   : Handler to LocationTrigger
* Author    : Bruna Girão
* Date      : 22/03/2022
-------------------------------------------------------------------------------------------
22/03/2022           Bruna Girão         create class 
********************************************************************************************/
public with sharing class LocationTriggerHandler {
    
    List<Location__c> newRecordsList {get; set;}
    List<Location__c> oldRecordsList {get; set;}
    Map<Id, Location__c> newRecordsMap {get; set;}
    Map<Id, Location__c> oldRecordsMap {get; set;}

    public static Boolean runTrigger;

    static {
        runTrigger = true;
    }

    public static Boolean isTriggerEnable() {
        return runTrigger;
    }

    public static Boolean enableTrigger() {
        return runTrigger = true;
    }

    public static Boolean disableTrigger() {
        return runTrigger = false;
    }

    public LocationTriggerHandler(){}

    public LocationTriggerHandler(
        List<Location__c> newRecordsList,
        List<Location__c> oldRecordsList,
        Map<Id, Location__c> newRecordsMap, 
        Map<Id, Location__c> oldRecordsMap
    ) {
        this.newRecordsList = newRecordsList;
        this.oldRecordsList = oldRecordsList;
        this.newRecordsMap  = newRecordsMap;
        this.oldRecordsMap  = oldRecordsMap;
    }

    public void beforeInsert() {
        LocationHelper.validateNewLocationData(this.newRecordsList);
    }

    public void beforeUpdate() {
        LocationHelper.updateStatusUpdateDate(this.newRecordsMap, this.oldRecordsMap);
    }

    public void afterUpdate() {
        LocationHelper.updatePeopleToYellowStatus(this.newRecordsList);
    }
    
}
