trigger DivisionUpdate on Quote(before insert, before update) {
    
    Map<String, id> divmap = new Map<String, id>();      
    list<string> divlst = new list<string>();     
    map<id,id> accmap=new map<id,id>();   
    map<id,id> conmap=new map<id,id>();
    
    list<ID> qqlst = new list<ID>();
    
    for(Quote qq : Trigger.new)
    {
        qqlst.add(qq.OpportunityId);
          divlst.add(qq.Division_NA__c);
    }
     for (Opportunity opp :[select id,name,contact_name__c,AccountId from Opportunity where id IN :qqlst])
    {
       
        accmap.put(opp.Id, opp.AccountId);
        conmap.put(opp.Id, opp.Contact_Name__c);
        system.debug(opp);
    }
     
      
    for(Division__c d :[SELECT id,name from Division__c where name=:divlst])
    {
        divmap.put(d.name,d.Id);
        system.debug(divmap);
        
    }
       
    for (Quote q : Trigger.new) 
    { 
      if(divmap.size()>0)
        q.Division__c = divmap.get(q.Division_NA__c);
      if(accmap.size()>0)
        q.Customer_Name__c = accmap.get(q.OpportunityId);
      if(conmap.size()>0)  
        q.ContactId = conmap.get(q.OpportunityId);
       
        
        
    }
    
}