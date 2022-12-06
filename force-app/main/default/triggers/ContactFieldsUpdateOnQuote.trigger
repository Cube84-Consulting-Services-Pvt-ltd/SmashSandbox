trigger ContactFieldsUpdateOnQuote on Quote (before insert) {
    list<ID> qqlst = new list<ID>();
        map<id,id> conmap=new map<id,id>();
    
    for(Quote qq : Trigger.new)
    {
        qqlst.add(qq.OpportunityId);
    }
         for (Opportunity opp :[select id,name,contact_name__c,AccountId from Opportunity where id IN :qqlst])
    {
       
        conmap.put(opp.Id, opp.Contact_Name__c);
        system.debug(opp);
    }
    
        for (Quote q : Trigger.new) 
    { 
        
      if(conmap.size()>0)  
        q.ContactId = conmap.get(q.OpportunityId);
       
        
        
    }
}