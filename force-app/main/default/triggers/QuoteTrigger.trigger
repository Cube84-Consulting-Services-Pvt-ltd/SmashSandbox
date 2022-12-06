trigger QuoteTrigger on Quote (after insert) {
    
    id qtID;
    id qtID1;
  map<id,id> opqtID=new map<id,id>();
   
    for(Quote qt:Trigger.new)
    {
        opqtID.put(qt.OpportunityId,qt.Id);
        qtID1=qt.Id;
    }
    
    map<id,list<QuoteLineItem>> qtlst1=new map<id,list<QuoteLineItem>>();
    for(Quote q1:[select id,OpportunityId,(select id,Product2Id,QuoteID from QuoteLineItems) from Quote WHERE OpportunityId=:opqtID.keySet()])
    {
        qtlst1.put(q1.OpportunityId,q1.QuoteLineItems);
       
    }
     
    list<QuoteLineItem> qtList=new list<QuoteLineItem>();
    List<DW_Quote_Line_Item__c> dwQuoteList = new List<DW_Quote_Line_Item__c>();
    
    List<DW_Opportuinity_Product__c> dwOpptyProds = [SELECT ID, Quantity__C, Name,DW_PriceBook_Entry__c,Initial_Quantity__c,Opportunity__c,
                                                     AmountC__c,Grade__c,Delta__c,Description__c,Discount__c,Downsell__c,
                                                     Interested_Product_Type__c,Manufactured__c,Renewal__c,Renewed_Qty__c,Resale__c,
                                                     Sub_Total__c,Supplier__c,TotalPrice__c,Unit_of_Measure__c,UnitPrice__c,Units_Per_Pallet__c,
                                                     Upsell__c,DWProduct__c
                                                     FROM DW_Opportuinity_Product__c
                                                     WHERE Opportunity__c = :opqtID.keySet()];
 
    
    if(dwOpptyProds.size()>0){
        for(DW_Opportuinity_Product__c dop: dwOpptyProds){
            dwQuoteList.add(new DW_Quote_Line_Item__c(
                AmountC__c = dop.AmountC__c,
                UnitPrice__c=dop.UnitPrice__c,
                Manufactured__c = dop.Manufactured__c,
                Grade__c = dop.Grade__c,
                Delta__c = dop.Delta__c,
                Description__c = dop.Description__c,
                Discount__c = dop.Discount__c,
                Downsell__c = dop.Downsell__c,
                DW_PriceBook_Entry__c = dop.DW_PriceBook_Entry__c,
                DWProduct__c = dop.DWProduct__c,
                Initial_Quantity__c = dop.Initial_Quantity__c,
                Interested_Product_Type__c = dop.Interested_Product_Type__c,
                //Package_Size__c = dop,
                Quantity__c = dop.Quantity__c,
                Renewal__c = dop.Renewal__c,
                Renewed_Qty__c = dop.Renewed_Qty__c,
                Resale__c = dop.Resale__c,
                Sub_Total__c = dop.Sub_Total__c,
                TotalPrice__c = dop.TotalPrice__c,
                Name = dop.Name,
                Quote__c = opqtID.get(dop.Opportunity__c)
            ));
        }
    }
    system.debug(''+qtList);
     system.debug(''+qtList.size());
   if(qtList.size()>0)
    insert qtList;
    if(dwQuoteList.size()>0){
       database.insert(dwQuoteList);
    }

      QuotePDFGeneratorResource.doPost(qtID1); 
    
    
  /*  List<QuoteDocument> sr = new List<QuoteDocument>();
    for (Quote q: Trigger.new)
        if (q.Status == 'Draft'){
            sr.add (new QuoteDocument(
                QuoteId = q.Id,
                document = Blob.toPDF('Your Contents Here')));  
        }
    insert sr; */
    Set<Id> dwLineId = new  Set<Id>();
    Set<Id> qtOppId = new  Set<Id>();
    Set<Id> qtIds = new  Set<Id>();
    Set<Id> qtDWLineId = new  Set<Id>();
    List<DW_Quote_Line_Item__c> dwLineLst = new  List<DW_Quote_Line_Item__c>();
    List<DW_Opportuinity_Product__c> dwOppProdInt = new  List<DW_Opportuinity_Product__c>();
    List<DW_Opportuinity_Product__c> dwOppProdDel = new  List<DW_Opportuinity_Product__c>();
    Map<ID,ID> oppQtmap = new Map<ID,ID> ();
    Map<ID,ID> oppDltmap = new Map<ID,ID> ();
    Map<ID,Boolean> qtSynMap = new Map<ID,Boolean> ();
     /* if (Trigger.isAfter ) {
            if (Trigger.isupdate) {
                for (Quote qt: Trigger.New ){
                    if(qt.IsSyncing  && Trigger.oldmap.get(qt.id).IsSyncing!=Trigger.newmap.get(qt.id).IsSyncing){
                      system.debug('@@@@@@@@@@@@'+qt.IsSyncing);
                          system.debug('###############@@@@'+Trigger.oldmap.get(qt.id).IsSyncing);
                        qtSynMap.put(qt.id,true);
                    qtOppId.add(qt.opportunityid);
                    oppDltmap.put(qt.opportunityid,qt.id);  
                   qtIds.add(qt.id); 
                   oppQtmap.put(qt.id,qt.OpportunityId);
                        
                    }
                   }
          
            for(DW_Quote_Line_Item__c dqLine : [SELECT Id,DWProduct__c,Quantity__c,UnitPrice__c ,Quote__r.OpportunityId FROM DW_Quote_Line_Item__c WHERE Quote__c IN : qtIds ]){
                dwLineLst.add(dqLine);
                oppQtmap.put(dqLine.Quote__c,dqLine.Quote__r.OpportunityId);
            }
            for(DW_Opportuinity_Product__c dwOppold : [SELECT id,Opportunity__c FROM DW_Opportuinity_Product__c WHERE Opportunity__c IN :qtOppId]){
                if(oppDltmap.containsKey(dwOppold.Opportunity__c)){
                    dwOppProdDel.add(dwOppold);
                    system.debug('dwOppProdDel'+dwOppProdDel.size());
                }
            }
            // Inserting new DW oppoertunity Product when sync is true 
            if(!dwOppProdDel.isEmpty()&& dwOppProdDel !=null){
                delete dwOppProdDel;
            }
            for (DW_Quote_Line_Item__c istOppPro : dwLineLst){
                DW_Opportuinity_Product__c dwOpp = new DW_Opportuinity_Product__c();
                dwOpp.Opportunity__c= oppQtmap.get(istOppPro.Quote__c);
                dwOpp.DWProduct__c=istOppPro.DWProduct__c;
                dwOpp.Quantity__c=istOppPro.Quantity__c;
                dwOpp.UnitPrice__c = istOppPro.UnitPrice__c;
                dwOpp.DW_Quote_Line_Item_SFID__c=istOppPro.Id;
                dwopp.IsSync__c = true;
                dwOppProdInt.add(dwOpp);
            }
            insert dwOppProdInt;
            system.debug('dwOppProdInt'+dwOppProdInt);
            // }
            
             } 
      }*/
  
}