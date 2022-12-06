public class QuoteLineItemTriggerHandler{

    public static void updateLineItem(set<string> quoteIds,List<QuoteLineItem> triggerNew){
        try{
            Set<string> quoteId = new Set<string>();
            List<Quote> quoteList = new List<Quote>();
            List<QuoteLineItem> updateQLIList = new List<QuoteLineItem>();
            List<QuoteLineItem> QLIList = new List<QuoteLineItem>();
            QuoteLineItem oliObj = new QuoteLineItem();
            Set<String> oppIds = new Set<string>();
            quoteList  = [Select id , OpportunityId from Quote where Id IN: quoteIds];
            for(Quote q : quoteList){
                oppIds.add(q.OpportunityId);
            }
            if(oppIds.size()>0){
                List<OpportunityLineItem> listOLI = new List<OpportunityLineItem>();
                listOLI = [Select id,Product2Id,Unit_of_Measure__c,Units_Per_Pallet__c From OpportunityLineItem where OpportunityId IN: oppIds];
                system.debug('Opp Line Item List-----------'+listOLI);
                
                for(QuoteLineItem qli : triggerNew){
                    quoteId.add(qli.id);
                }
                QLIList  = [Select id, Product2Id , Unit_Of_Measure__c , Units_Per_Pallet__c From QuoteLineItem where id IN: quoteId];
                for(QuoteLineItem qli : QLIList){
                    for(OpportunityLineItem oli : listOlI){
                        if(qli.Product2Id == oli.Product2Id){
                            qli.Unit_Of_Measure__c = oli.Unit_of_Measure__c;
                            qli.Units_Per_Pallet__c = oli.Units_Per_Pallet__c;
                            updateQLIList.add(qli);
                        }
                    }
                }
                if(updateQLIList.size()>0){
                    update updateQLIList;
                } 
            }
        }
        catch(Exception e){
            system.debug(e.getMessage()+'-------------'+e.getLineNumber());
        }
    }    
    
 }