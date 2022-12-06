trigger OppAmountUpdate on DW_Opportuinity_Product__c (after insert,After update) {
  Set<Id> dwOppId = new  Set<Id>();
    decimal am=0;
     List<Opportunity>opplist=new list<Opportunity>();
     for (DW_Opportuinity_Product__c dwOpp : Trigger.new){
                dwOppId.add(dwopp.Opportunity__c);
            }
      System.debug('dwOppId'+dwOppId);
    /* for(AggregateResult aRes : [SELECT Opportunity__c, SUM(TotalPrice__c) Total FROM DW_Opportuinity_Product__c WHERE Opportunity__c IN :dwOppId GROUP BY Opportunity__c]) {
          system.debug('entered'+(Decimal)aRes.get('Total'));
        opplist.add(new Opportunity(Id = (Id)aRes.get('Opportunity__c'), Amount = (Decimal)aRes.get('Total')));
        system.debug('entered'+(Decimal)aRes.get('Total'));
    }
        update opplist; */
    
        list<DW_Opportuinity_Product__c> lstdwp=[select id,name,opportunity__c,Totalprice__c from DW_Opportuinity_Product__c where opportunity__c IN :dwOppId];
    System.debug('lstdwp'+lstdwp);
        for(opportunity opp2:[select id,name,amount from opportunity where id IN :dwOppId])
        {
            for(DW_Opportuinity_Product__c dwp:lstdwp)
            {
                if(dwp.TotalPrice__c != null) //added by Shubham K
                {
                	am+=dwp.TotalPrice__c;
                    system.debug(am);
                }
            }
            opp2.Amount=am;
            system.debug(am);
            opplist.add(opp2);
        }
    System.debug('opplist'+opplist);
     upsert opplist;
     system.debug(opplist);
}