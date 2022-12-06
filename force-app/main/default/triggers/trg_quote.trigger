trigger trg_quote on Quote (before insert) {

    Set<id> oppIds;
    if(trigger.isInsert && trigger.Isbefore){
        for(Quote q : Trigger.New){
            if(q.DivisionId__c != ''){
                q.Division__c = q.DivisionId__c;
            }
        }        
    }
}