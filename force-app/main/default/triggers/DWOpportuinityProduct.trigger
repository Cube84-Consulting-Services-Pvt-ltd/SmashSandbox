trigger DWOpportuinityProduct on DW_Opportuinity_Product__c (after delete, after insert, after update) {
    Set<Id> dwOppId = new  Set<Id>();
    Set<Id> dwOppProId = new  Set<Id>();
    Set<Id> qtId = new  Set<Id>();
    Set<Id> proIds = new  Set<Id>();
    Set<Decimal> qntcount = new  Set<Decimal>();
    map<id,Opportunity> lstopp=new map<id,Opportunity>();
    List<Opportunity>opplist=new list<Opportunity>();
    List<DW_Quote_Line_Item__c> dwLineDelLst = new  List<DW_Quote_Line_Item__c>();
    List<DW_Quote_Line_Item__c> dwLineInsLst = new  List<DW_Quote_Line_Item__c>();
    List<DW_Opportuinity_Product__c> dwProLst = new  List<DW_Opportuinity_Product__c>();
    List<DW_Quote_Line_Item__c> dwDataLst = new  List<DW_Quote_Line_Item__c>();
    Map<ID,ID> oppQtmap = new Map<ID,ID> ();
    Map<String,String> oliQtmap = new Map<String,String> ();
    Map<String,Boolean> oliQtUptmap = new Map<String,Boolean> ();
    Map<String,String> oliQtUpmap = new Map<String,String> ();
    Map<String,DW_Opportuinity_Product__c> oppDatamap = new Map<String,DW_Opportuinity_Product__c> ();
    if(checkRecursive.run) // Added New Code for soql issue
    {
    if (Trigger.isAfter ) {
        if (Trigger.isDelete) {
            for (DW_Opportuinity_Product__c dwOpp : Trigger.old){
                dwOppProId.add(dwOpp.Id);
                dwOppId.add(dwopp.Opportunity__c);
                String qtLinItmKey = Trigger.oldmap.get(dwOpp.id).DWProduct__c+'-'+Trigger.oldmap.get(dwOpp.id).Quantity__c;
                oliQtmap.put(dwopp.Opportunity__c, qtLinItmKey);
                system.debug('oppkey map first '+oliQtmap);
                oppDatamap.put(dwopp.Opportunity__c,dwopp);
                proIds.add(dwOpp.DWProduct__c);
                qntcount.add(dwOpp.Quantity__c);
                
            }
            for (Quote qt : [SELECT id,opportunityid FROM quote where opportunityid IN:dwOppId AND IsSyncing =true]){
                qtId.add(qt.id);
                oppQtmap.put(qt.opportunityid,qt.id);
                system.debug('oppQtmap'+oppQtmap);
            }
            for(DW_Quote_Line_Item__c dwLinUpt : [SELECT id,Quote__c,Quote__r.opportunityId,AmountC__c,Manufactured__c,Grade__c,Delta__c ,Description__c ,Discount__c,Downsell__c,DW_PriceBook_Entry__c,DWProduct__c,Initial_Quantity__c,Interested_Product_Type__c,Quantity__c,Renewal__c,Renewed_Qty__c,Resale__c,Sub_Total__c,TotalPrice__c,UnitPrice__c,Name  FROM DW_Quote_Line_Item__c WHERE quote__c IN : qtId AND DWProduct__c IN:proIds AND Quantity__c IN:qntcount]){
               dwDataLst.add(dwLinUpt);
            }
            Delete dwDataLst;
            
            //Opportunity amount update
            /*       for(AggregateResult objAgg : [ select sum(TotalPrice__c) from DW_Opportuinity_Product__c where id IN:Trigger.old])
                     {
             for(Opportunity opp1:[select id,name,amount,closedate from opportunity where id IN:dwOppId])
                        {
                              system.debug('entered2 null');
                            opp1.amount=(Decimal)objAgg.get('expr0');
                             // opp1.amount=opp1.amount+dwp.TotalPrice__c; 
                              lstopp.put(opp1.id,opp1);
                 }
               }
            update lstopp.values(); */
            }
            
        
        if (Trigger.isInsert) {
            system.debug('isInsert'+Trigger.isInsert);
            for (DW_Opportuinity_Product__c dwOpp : Trigger.new){
                dwOppProId.add(dwOpp.Id);
                dwOppId.add(dwopp.Opportunity__c);
            }
            for (Quote qt : [SELECT id,opportunityid FROM quote where opportunityid IN:dwOppId AND IsSyncing =true]){
                qtId.add(qt.id);
                oppQtmap.put(qt.opportunityid,qt.id);
                system.debug('oppQtmap'+oppQtmap);
            }
            for (DW_Opportuinity_Product__c istOppPro : Trigger.New){
                DW_Quote_Line_Item__c dwLineItm = new DW_Quote_Line_Item__c();
                if(oppQtmap.containskey(istOppPro.Opportunity__c)){
                    system.debug('@@@@@@@@@@@@@'+oppQtmap.get(istOppPro.Opportunity__c));
                    dwLineItm.Quote__c = oppQtmap.get(istOppPro.Opportunity__c);
                    dwLineItm.AmountC__c = istOppPro.AmountC__c;
                    dwLineItm.Manufactured__c = istOppPro.Manufactured__c;
                    dwLineItm.Grade__c = istOppPro.Grade__c;
                    dwLineItm.Delta__c = istOppPro.Delta__c;
                    dwLineItm.Description__c = istOppPro.Description__c;
                    dwLineItm.Discount__c = istOppPro.Discount__c;
                    dwLineItm.Downsell__c = istOppPro.Downsell__c;
                    dwLineItm.DW_PriceBook_Entry__c = istOppPro.DW_PriceBook_Entry__c;
                    dwLineItm.DWProduct__c = istOppPro.DWProduct__c;
                    dwLineItm.Initial_Quantity__c = istOppPro.Initial_Quantity__c;
                    dwLineItm.Interested_Product_Type__c = istOppPro.Interested_Product_Type__c;
                    dwLineItm.Quantity__c = istOppPro.Quantity__c;
                    dwLineItm.Renewal__c = istOppPro.Renewal__c;
                    dwLineItm.Renewed_Qty__c = istOppPro.Renewed_Qty__c;
                    dwLineItm.Resale__c = istOppPro.Resale__c;
                    dwLineItm.Sub_Total__c = istOppPro.Sub_Total__c;
                    dwLineItm.TotalPrice__c = istOppPro.TotalPrice__c;
                    dwLineItm.UnitPrice__c = istOppPro.UnitPrice__c;
                    dwLineItm.Name = istOppPro.Name;
                    dwLineInsLst.add(dwLineItm);
                }
                
            }
            if(!dwLineInsLst.isEmpty() && dwLineInsLst!=null){
              insert dwLineInsLst;
            system.debug('dwLineInsLst'+dwLineInsLst);  
            }
             // opportunity amount standard update
             
        /*    for(AggregateResult objAgg : [ select sum(TotalPrice__c) from DW_Opportuinity_Product__c where id IN:Trigger.new])
                     {
                         system.debug('enterd');
             for(Opportunity opp1:[select id,name,amount,closedate from opportunity where id IN:dwOppId])
                        {
                            system.debug('enterd2');
                              system.debug('entered2 null');
                            opp1.amount=(Decimal)objAgg.get('expr0');
                            system.debug('enterd3'+opp1.amount);
                             // opp1.amount=opp1.amount+dwp.TotalPrice__c; 
                              lstopp.put(opp1.id,opp1);
                 }
               }   
            update lstopp.values(); */
   
        }
        if (Trigger.isUpdate) {
            for (DW_Opportuinity_Product__c dwOpp : Trigger.new){
                dwOppProId.add(dwOpp.Id);
                dwOppId.add(dwopp.Opportunity__c);
                String qtLinItmKey = Trigger.oldmap.get(dwOpp.id).DWProduct__c+'-'+Trigger.oldmap.get(dwOpp.id).Quantity__c;
                oliQtUptmap.put(qtLinItmKey,true);
                system.debug('oppkey map first '+oliQtUptmap);
                oppDatamap.put(qtLinItmKey,dwopp);
                proIds.add(Trigger.oldmap.get(dwOpp.id).DWProduct__c);
                qntcount.add(Trigger.oldmap.get(dwOpp.id).Quantity__c);
                
            }
            for (Quote qt : [SELECT id,opportunityid FROM quote where opportunityid IN:dwOppId AND IsSyncing =true]){
                qtId.add(qt.id);
                oppQtmap.put(qt.opportunityid,qt.id);
                system.debug('oppQtmap'+oppQtmap);
            }
            for(DW_Quote_Line_Item__c dwLinUpt : [SELECT id,Quote__c,Quote__r.opportunityId,AmountC__c,Manufactured__c,Grade__c,Delta__c ,Description__c ,Discount__c,Downsell__c,DW_PriceBook_Entry__c,DWProduct__c,Initial_Quantity__c,Interested_Product_Type__c,Quantity__c,Renewal__c,Renewed_Qty__c,Resale__c,Sub_Total__c,TotalPrice__c,UnitPrice__c,Name  FROM DW_Quote_Line_Item__c WHERE quote__c IN : qtId AND DWProduct__c IN:proIds AND Quantity__c IN:qntcount]){
                String qtLinItmKey1 = dwLinUpt.DWProduct__c+'-'+dwLinUpt.Quantity__c;
                oliQtUpmap.put(dwLinUpt.id, qtLinItmKey1);
                system.debug('oppkey map second '+oliQtUpmap);
                dwDataLst.add(dwLinUpt);
            }
            for (DW_Quote_Line_Item__c dwLineItm : dwDataLst){
                 if(oliQtUptmap.containsKey(oliQtUpmap.get(dwLineItm.id))){
                system.debug('update list '+dwDataLst);
                dwLineItm.AmountC__c = oppDatamap.get(oliQtUpmap.get(dwLineItm.id)).AmountC__c;
                dwLineItm.Manufactured__c = oppDatamap.get(oliQtUpmap.get(dwLineItm.id)).Manufactured__c;
                dwLineItm.Grade__c = oppDatamap.get(oliQtUpmap.get(dwLineItm.id)).Grade__c;
                dwLineItm.Delta__c = oppDatamap.get(oliQtUpmap.get(dwLineItm.id)).Delta__c;
                dwLineItm.Description__c = oppDatamap.get(oliQtUpmap.get(dwLineItm.id)).Description__c;
                dwLineItm.Discount__c = oppDatamap.get(oliQtUpmap.get(dwLineItm.id)).Discount__c;
                dwLineItm.Downsell__c = oppDatamap.get(oliQtUpmap.get(dwLineItm.id)).Downsell__c;
                dwLineItm.DW_PriceBook_Entry__c = oppDatamap.get(oliQtUpmap.get(dwLineItm.id)).DW_PriceBook_Entry__c;
                dwLineItm.Initial_Quantity__c = oppDatamap.get(oliQtUpmap.get(dwLineItm.id)).Initial_Quantity__c;
                dwLineItm.Interested_Product_Type__c = oppDatamap.get(oliQtUpmap.get(dwLineItm.id)).Interested_Product_Type__c;
                dwLineItm.Quantity__c = oppDatamap.get(oliQtUpmap.get(dwLineItm.id)).Quantity__c;
                dwLineItm.Renewal__c = oppDatamap.get(oliQtUpmap.get(dwLineItm.id)).Renewal__c;
                dwLineItm.Renewed_Qty__c = oppDatamap.get(oliQtUpmap.get(dwLineItm.id)).Renewed_Qty__c;
                dwLineItm.Resale__c = oppDatamap.get(oliQtUpmap.get(dwLineItm.id)).Resale__c;
                dwLineItm.Sub_Total__c = oppDatamap.get(oliQtUpmap.get(dwLineItm.id)).Sub_Total__c;
                dwLineItm.TotalPrice__c = oppDatamap.get(oliQtUpmap.get(dwLineItm.id)).TotalPrice__c;
                dwLineInsLst.add(dwLineItm);
                 }
            }
            update dwLineInsLst;
            system.debug('dwLineInsLst'+dwLineInsLst);
            
            //opportunity amount update
            
                   for(AggregateResult objAgg : [ select sum(TotalPrice__c) from DW_Opportuinity_Product__c where id IN:Trigger.new])
                     {
             for(Opportunity opp1:[select id,name,amount,closedate from opportunity where id IN:dwOppId])
                        {
                              system.debug('entered2 null');
                            opp1.amount=(Decimal)objAgg.get('expr0');
                             // opp1.amount=opp1.amount+dwp.TotalPrice__c; 
                              lstopp.put(opp1.id,opp1);
                 }
               }
            update lstopp.values(); 
        }
    }
    
    if(Trigger.isAfter && Trigger.isInsert)
    {
        
    }
    }
}