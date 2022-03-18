/********************************************************************************************
* Name      : PersonTrigger
* Purpose   : Trigger to Person__c Object
* Author    : Bruna Girão
* Date      : 18/03/2022
-------------------------------------------------------------------------------------------
18/03/2022           Bruna Girão         create Trigger 
********************************************************************************************/
trigger PersonTrigger on Person__c (
    before insert, after insert, 
    before update, after update, 
    before delete, after delete, 
    after undelete) {

}