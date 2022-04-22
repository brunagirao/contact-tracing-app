/************************************************************************************************
* Name      : LocationTracingTrigger
* Purpose   : Trigger to Location_Tracing__c Object
* Author    : Bruna Girão
* Date      : 22/03/2022  
-------------------------------------------------------------------------------------------
22/03/2022           Bruna Girão         create Trigger 
***************************************************************************************************/
trigger LocationTracingTrigger on Location_Tracing__c (before insert, after insert) {

    LocationTracingTriggerHandler handler = new LocationTracingTriggerHandler (
        Trigger.new, Trigger.old,
        Trigger.newMap, Trigger.oldMap
    );

    switch on Trigger.operationType {
        when BEFORE_INSERT {
            handler.beforeInsert();
        }
    }
}