@isTest
public class downloadMessageController_Test {

    static testMethod void downloadMessage() 
    {
        
        Account testAccount = new Account();
        testAccount.Name='Test Account' ;
        insert testAccount;
        
        opportunity o=new opportunity();
        o.AccountId=testAccount.id;
        o.Name='Test';
        o.StageName='Closed Won';
        o.CloseDate=system.today();
        o.Supplier__c='DDW';
        // o.Pricebook2Id = standardPB;
        insert o;
                
        Quote q=new quote();
        q.Name='Test quote';
        q.OpportunityId=o.id;
        insert q;
        downloadMessageController.getDownloadIndictor(q.id);
    }
        
}