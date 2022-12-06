trigger trg_updateQuoteLine1 on QuoteLineItem (after insert) {
   
    set<string> quoteIds ;
    if(trigger.isafter && trigger.isinsert){
        quoteIds = new set<string>();
        for(QuoteLineItem oli : trigger.new){
            quoteIds.add(oli.QuoteId);
        }
        if(quoteIds.size()>0){
            QuoteLineItemTriggerHandler.updateLineItem(quoteIds , trigger.new);
        }
    }
   

}