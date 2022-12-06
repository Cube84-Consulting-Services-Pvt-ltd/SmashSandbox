@isTest
public class OppAmountUpdate_Test {

     static testMethod void test() 
	{
         Id standardPB = Test.getStandardPricebookId();
        
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
        o.Pricebook2Id = standardPB;
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

       Pricebook2 pb = new Pricebook2(Name = 'Standard Price Book 2009', Description = 'Price Book 2009 Products', IsActive = true );
    insert pb;
Product2 prod = new Product2(Name = 'SLA: Bronze', IsActive = true);
    insert prod;
PricebookEntry pbe=new PricebookEntry(unitprice=0.01,Product2Id=prod.Id, Pricebook2Id=Test.getStandardPricebookId(), IsActive= true); 
     insert pbe;      
        
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

    }
}