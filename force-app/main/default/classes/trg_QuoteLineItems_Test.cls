@isTest
public class trg_QuoteLineItems_Test {

    @isTest
    public static void Test1(){
        Account a = new Account();
        a.Name = 'Test Account';   
        insert a;
        Product2 productObj = new Product2();
        productObj.Name = 'Test product';
        productObj.Family = 'FamilyColorings';
        insert productObj;
        PriceBookEntry PBEobj = new PriceBookEntry();
        PBEobj.UnitPrice = 25.25;
        PBEobj.Pricebook2Id = test.getStandardPricebookId();
        PBEobj.Product2Id = productObj.id;
        PBEobj.IsActive = true;
        Insert PBEobj;
        Opportunity oppObj = new Opportunity();
        oppObj.AccountId = a.Id;
        oppObj.Name = 'Test Opp';
        oppObj.Amount = 22;
        oppObj.StageName = 'Realization';
        oppObj.CloseDate = date.today();
        oppObj.Supplier__c='BASF';// Added by Shubham K
        Insert oppObj;
        OpportunityLineItem oliobj = new OpportunityLineItem ();
        oliObj.OpportunityId = oppObj.Id;
        oliObj.Quantity = 5;
        oliObj.PricebookEntryId = PBEobj.Id;
        oliObj.TotalPrice = 5 * PBEobj.UnitPrice;
        oliobj.Unit_of_Measure__c = 'Case';
        oliObj.Units_Per_Pallet__c = 'Test OLI';
        insert oliOBj;
        PriceBookEntry pbeId = [Select id From PriceBookEntry where id =: PBEobj.id limit 1];
        Quote qObj = new Quote();
        qObj.Name = 'Test Quote';
        qObj.OpportunityId = oppObj.id;
        qObj.Pricebook2Id = test.getStandardPricebookId();
        qObj.Status = 'Draft';
        Insert qObj;
        QuoteLineItem qliObj = new QuoteLineItem();
        qliObj.QuoteId = qObj.Id;
        qliObj.Quantity = 5;
        qliObj.UnitPrice = 25.25;
        qliObj.PricebookEntryId = PBEobj.Id;
        qliObj.Product2Id = productObj.id;
        insert qliobj;
    }
}