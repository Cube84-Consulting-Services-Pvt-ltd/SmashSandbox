@isTest
public class OpportunityDWProductEntryExtension_Test {
    static testMethod void OpportunityDWProductEntry() 
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
        
        
        DWProduct__c p=new DWProduct__c();
        p.Name='test';
        p.ITEM__c='1007070001';
        p.ITEM_DESCRIPTION__c='Test';
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
        d.Initial_Quantity__c=5;
        insert d;
        List<DW_Opportuinity_Product__c> pdList = new List <DW_Opportuinity_Product__c> ();
        pdList.add(d);
        
        DWProductPrices__c pr = new DWProductPrices__c();
        pr.PRODUCT_REF__c=p.id;
        pr.isActive__c=true;
        pr.LIMIT_1__c=1;
        pr.LIMIT_2__c=5;
        pr.PRICE_1__c=100;
        pr.PRODUCT_KEY__c='123';
        
        insert pr;
        
        
        DW_PriceBook_Entry__c prE = new DW_PriceBook_Entry__c();
        prE.DWProduct__c=p.id;
        prE.DWProductPrices__c=pr.id;
        prE.IsActive__c=true;
        prE.Name='test';
        prE.UnitPrice__c=121;
        prE.PRICEBOOK_ENTRY_KEY__c='test';
        
        Insert PrE;
        
        Pricebook2 pb = new Pricebook2(Name = 'Standard Price Book 2009', Description = 'Price Book 2009 Products', IsActive = true );
        insert pb;
        Product2 prod = new Product2(Name = 'SLA: Bronze', IsActive = true);
        insert prod;
        PricebookEntry pbe=new PricebookEntry(unitprice=0.01,Product2Id=prod.Id, Pricebook2Id=Test.getStandardPricebookId(), IsActive= true); 
        insert pbe;
        
          Test.StartTest(); 
        PageReference pageRef = Page.OpportunityDWProductEntery_DEV;
        //Test.setCurrentPage(pageRef);
        
        Test.setCurrentPageReference(new PageReference('Page.OpportunityDWProductEntery_DEV')); 
       System.currentPageReference().getParameters().put('index', '1');
        
        pageRef.getParameters().put('Id', String.valueOf(o.Id));
        ApexPages.StandardController sc = new ApexPages.StandardController(o);
        opportunityDWProductEntryExtension_DEV oppDWcon = new opportunityDWProductEntryExtension_DEV(sc);
        
        oppDWcon.qty='1';
        oppDWcon.searchFamily = 'Test';
        oppDWcon.searchString = 'Test';
        oppDWcon.productId = p.id;
        oppDWcon.toSelect = prE.id;
        oppDWcon.selectedRow=1;
        oppDWcon.rowId = '1';
        
       
        oppDWcon.clearfilter();   
        oppDWcon.onCancel();
        oppDWcon.onSave();
        oppDWcon.onSaveAddQuotes();
         oppDWcon.searchString='test';
        oppDWcon.updateAvailableList();
        oppDWcon.quantityChange();
        oppDWcon.quantityChangeOnOpptyProd();
        
      //  oppDWcon.multipleCurrencies =true;
        oppDwcon.qty='4';
        opportunityDWProductEntryExtension_DEV.lineItems  objes= new opportunityDWProductEntryExtension_DEV.lineItems(p.id,d,true,null,false,1);         
         
        
        oppDWcon.addToShoppingCart();
        oppDWcon.savelogic();
        oppDWcon.cloneProduct();
        opportunityDWProductEntryExtension_DEV.lineItems  objes1= new opportunityDWProductEntryExtension_DEV.lineItems(p.id,d,true,null,true,1);         
        oppDWcon.savelogic();
        oppDWcon.removeFromShoppingCart();
       
        oppDWcon.savelogic();
        
        Test.stoptest();
        
        
        
        
        
        
    }
}