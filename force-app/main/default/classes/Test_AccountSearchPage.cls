@isTest
public class Test_AccountSearchPage {
    static testMethod void SearchAccount() 
	 {
         list<account>cc=new list<account>();
         Account at=new Account();
         at.name='test';
         insert at;
         cc.add(at);
         Contact ct=new Contact();
         ct.LastName='test';
         ct.AccountId=at.id;
         ct.MailingState='AO';
         ct.Email='Demo@gmail.com';
         ct.Alternate_Mailing_State__c='CO';
         ct.Phone='9087654323';
         ct.Secondary_Mailing_State__c='CO';
         ct.FirstName='Demo';
         Insert ct;
        // cc.add(ct);
         Test.StartTest();
         PageReference pref = Page.searchcontactVf;       
		pref.getParameters().put('id',ct.id);
		Test.setCurrentPage(pref);
         
         SearchAccount_controller sc=new SearchAccount_controller();
         PageReference objPageRef = sc.newaccount();
         PageReference objPageRef1 = sc.redirect();
         sc.searchAccounts();
         sc.FirstPage();
         sc.next();
         sc.LastPage();
         sc.getprev();
         sc.getnxt();
         sc.searchAcc();
         sc.clear();
         //sc.previous();
        Test.StopTest(); 
         
     }
}