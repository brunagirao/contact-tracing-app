/************************************************************************************************
* Name      : PeopleTracingTrigger
* Purpose   : Trigger to People_Tracing__c Object
* Author    : Bruna Girão
* Date      : 22/03/2022  
-------------------------------------------------------------------------------------------
22/03/2022           Bruna Girão         create Trigger 
***************************************************************************************************/
trigger PeopleTracingTrigger on People_Tracing__c (before insert, after insert) {
    
    PeopleTracingTriggerHandler handler = new PeopleTracingTriggerHandler (
        Trigger.new, Trigger.old,
        Trigger.newMap, Trigger.oldMap
    );

    switch on Trigger.operationType {
        when BEFORE_INSERT {
            handler.beforeInsert();
        }
        when else {
            
        }
    }
}