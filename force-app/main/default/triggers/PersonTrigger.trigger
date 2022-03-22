/************************************************************************************************
* Name      : PersonTrigger
* Purpose   : Trigger to Person__c Object
* Author    : Bruna Girão
* Date      : 18/03/2022
-------------------------------------------------------------------------------------------
18/03/2022           Bruna Girão         create Trigger 
19/03/2022           Bruna Girão         create Trigger contexts variables
                                         create Trigger operations BEFORE_INSERT and BEFORE_UPDATE
***************************************************************************************************/
trigger PersonTrigger on Person__c (
    before insert, after insert, 
    before update, after update, 
    before delete, after delete, 
    after undelete) {

    PersonTriggerHandler handler = new PersonTriggerHandler(
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