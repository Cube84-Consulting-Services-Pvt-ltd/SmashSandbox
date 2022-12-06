@isTest
public class AddDWQuoteController_Dev_Test 
{
	static testMethod void testMethod1() 
	{
		list<quote> lstqt=new list<quote>();
        
        
		Account testAccount = new Account();
	    testAccount.Name='Test Account' ;
		insert testAccount;
        

		Contact cont = new Contact();
			cont.FirstName ='Test';
			cont.LastName ='Test';
			cont.Accountid = testAccount.id;
		insert cont;
		
		opportunity o=new opportunity();
        o.AccountId=testAccount.id;
        o.Name='Test';
        o.StageName='Closed Won';
        o.CloseDate=system.today();
        o.Supplier__c='DDW';
        insert o;
		
        Quote q=new quote();
        q.Name='Test quote';
        q.OpportunityId=o.id;
      
        
         Quote q1=new quote();
        q1.Name='Test quote';
        q1.OpportunityId=o.id;
        
		Test.StartTest(); 
       Test.setCurrentPageReference(new PageReference('Page.AddDWQuoteVFPage')); 
       System.currentPageReference().getParameters().put('att', o.id);
			ApexPages.StandardController sc = new ApexPages.StandardController(q);
           AddDWQuoteController_Dev obj=new AddDWQuoteController_Dev(sc);
        obj.save1();
        ApexPages.StandardController sc1 = new ApexPages.StandardController(q1);
           AddDWQuoteController_Dev obj1=new AddDWQuoteController_Dev(sc1);
        obj1.save();
        obj.afterSave();
         Test.stoptest();
        
        
			  
	}
}