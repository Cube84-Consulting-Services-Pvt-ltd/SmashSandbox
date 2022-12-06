@isTest
public class waitingController_Test {
    static testMethod void WaitCon() 
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
        insert o;
        
        Quote q=new quote();
        q.Name='Test quote';
        q.OpportunityId=o.id;
        insert q;
        
         Quote q1=new quote();
        q1.Name='Test quote';
        q1.OpportunityId=o.id;
        q1.IsDownlaoded__c=true;
        insert q1;
        
        ContentVersion contentVersion = new ContentVersion(
            Title = 'quotePdf',
            PathOnClient = 'quote.jpg',
            VersionData = Blob.valueOf('Test Content'),
            IsMajorVersion = true
        );
        insert contentVersion;    
        List<ContentDocument> documents = [
            SELECT Id, Title, LatestPublishedVersionId 
            FROM ContentDocument
        ];
        
        //create ContentDocumentLink  record 
        ContentDocumentLink cdl = New ContentDocumentLink();
        cdl.LinkedEntityId = q.id;
        cdl.ContentDocumentId = documents[0].Id;
        cdl.Visibility = 'AllUsers';
        cdl.shareType = 'V';
        insert cdl;
        
        Test.StartTest(); 
        ApexPages.StandardController sc = new ApexPages.StandardController(q);
        waitingController obj=new waitingController(sc);
        obj.quoteId=q.id;
        obj.getCount();
        obj.getIsEnabled();
        obj.incrementCounter();
        
        ApexPages.StandardController sc1 = new ApexPages.StandardController(q1);
        waitingController obj1=new waitingController(sc1);
        obj1.quoteId=q.id;
        obj1.getCount();
        obj1.getIsEnabled();
        obj1.incrementCounter();
        Test.stoptest();
    }
}