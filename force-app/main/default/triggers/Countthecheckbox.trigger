/*
This trigger wich helps find the cout of the records wich they check top20 check box.
*/

trigger Countthecheckbox on Opportunity (before insert,before update,before delete,after insert,after update,after delete) {//,after update,after insert
    if(trigger.isinsert){
         CountcheckTriggerHandler.CountCheck(trigger.new);
    }   
    if(trigger.isupdate){
        //List<Opportunity> newList = trigger.isdelete?trigger.old:trigger.new;
        CountcheckTriggerHandler.CountCheckup(trigger.new,trigger.oldmap);
}
    if(trigger.isdelete){
        CountcheckTriggerHandler.CountCheckdel(trigger.old);
    }
    if(trigger.isAfter){
        List<Opportunity> newList = trigger.isdelete?trigger.old:trigger.new;
       CountcheckTriggerHandler.CountCheckAfter(newList,trigger.oldmap);
    }
}