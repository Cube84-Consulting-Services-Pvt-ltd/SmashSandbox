@isTest
public class DWOpportuinityProduct_Test {
    static testMethod void DWOpportuinityProduct() 
    {
        
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
        // o.Pricebook2Id = standardPB;
        insert o;
        
        DWProduct__c p=new DWProduct__c();
        p.Name='test';
        p.ITEM__c='1007070001';
        p.ITEM_DESCRIPTION__c='Spectroquant PHARO 300 1 Unit';
        p.PRODUCT_TYPE_CODE__c='R';
        p.PRODUCT_TYPE__c='Resale Items';
        p.PRODUCT_GROUP_CODE__c='MIL';
        p.PRODUCT_GROUP__c='Millipore';
        p.PRODUCT_SUBGROUP_CODE__c='LAB';
        p.PRODUCT_SUBGROUP__c='Lab Essentials';
        p.PRODUCT_CLASS_CODE__c='VM';
        p.PRODUCT_CLASS__c='Resale - Millipore';
        p.COMMODITY_GROUP_CODE__c='LAB';
        p.COMMODITY_GROUP__c='Lab Essentials';
        p.SYS_CREATED__c=system.today();
        p.SYS_UPDATED__c=system.today();
        p.PRODUCT_STATUS__c='Active';
        insert p;
        
        
        DW_Opportuinity_Product__c d=new DW_Opportuinity_Product__c();
        d.Name='test';
        d.Quantity__c=1;
        d.UnitPrice__c=2;
        d.TotalPrice__c=1000;
        d.Primary__c=true;
        d.DWProduct__c=p.id;
        d.Grade__c='No comments';
        d.Opportunity__c=o.id;
        insert d;
        
        Quote q=new quote();
        q.Name='Test quote';
        q.OpportunityId=o.id;
        insert q;
        
        DW_Quote_Line_Item__c dwLineItm = new DW_Quote_Line_Item__c();
        
        dwLineItm.Quote__c=q.id;
        dwLineItm.Name='test';
        dwLineItm.Quantity__c=d.Quantity__c;
        dwLineItm.UnitPrice__c=d.UnitPrice__c;
        dwLineItm.TotalPrice__c=d.TotalPrice__c;
        dwLineItm.DWProduct__c=d.DWProduct__c;
        dwLineItm.Grade__c=d.Grade__c;
        insert dwLineItm;      
        
        o.SyncedQuoteId=q.id;
        update o;
        delete d;
        
        DW_Opportuinity_Product__c d1=new DW_Opportuinity_Product__c();
        d1.Name='test';
        d1.Quantity__c=1;
        d1.UnitPrice__c=2;
        d1.TotalPrice__c=1000;
        d1.Primary__c=true;
        d1.DWProduct__c=p.id;
        d1.Grade__c='No comments';
        d1.Opportunity__c=o.id;
        checkRecursive.Run=true;
        insert d1;
        
        checkRecursive.Run=true;
        d1.Quantity__c=2;
        update d1;
        checkRecursive.Run=true;
        delete d1;
    }
}