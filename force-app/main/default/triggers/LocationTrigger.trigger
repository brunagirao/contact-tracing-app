/************************************************************************************************
* Name      : LocationTrigger
* Purpose   : Trigger to Location__c Object
* Author    : Bruna Girão
* Date      : 22/03/2022  
-------------------------------------------------------------------------------------------
22/03/2022           Bruna Girão         create Trigger 
***************************************************************************************************/
trigger LocationTrigger on Location__c (
    before insert, before update, 
    after insert, after update) {

    
    LocationTriggerHandler handler = new LocationTriggerHandler(
        Trigger.new, Trigger.old,
        Trigger.newMap, Trigger.oldMap
    );

    switch on Trigger.operationType {
        when BEFORE_INSERT {
            handler.beforeInsert();
        }

        when BEFORE_UPDATE {
            handler.beforeUpdate();
        }

        when AFTER_UPDATE {
            handler.afterUpdate();
        }
    }
}