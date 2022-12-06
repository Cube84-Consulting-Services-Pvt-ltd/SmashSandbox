@isTest
public class ShipToAffAdressHandlerTest {
    
    @isTest
    public static void testmethod1()
    {
        Account acc= new Account();
        acc.Name='Test';
        insert acc;
        
        DWCustomer__c dw= new DWCustomer__c();
        dw.Name='';
        dw.CUSTOMER_KEY__c=45664.56;
        dw.CUSTOMER_TYPE_CODE__c='BW';
        dw.CUSTOMER_TYPE__c='Brewing Market';
        dw.CUSTOMER_SALES_GROUP__c='Small Account';
        dw.CUSTOMER_SEGMENT_CODE__c='XX';
        dw.CUSTOMER_SEGMENT__c='XX-Classification not used';
        dw.CUSTOMER_INDUSTRY_CODE__c='BXC';
        dw.CUSTOMER_INDUSTRY__c='Brewing-Craft';
        dw.SALES_PERSON__c='Chris Webster';
        dw.CUSTOMER_REGION_CODE__c='CN';
        dw.CUSTOMER_REGION__c='Canada';
        dw.CUSTOMER_COUNTRY_CODE__c='BR';
        dw.CUSTOMER_COUNTRY__c='Canada';
        dw.CUSTOMER_TERRITORY_CODE__c='02';
        dw.CUSTOMER_TERRITORY__c='Fresno-based Customer';
        dw.CUSTOMER_STATE_CODE__c='BC';
        dw.CUSTOMER_STATE__c='Canada, British Columbia';
        dw.CUSTOMER_STATUS__c='Open Account';
        dw.CUSTOMER_PAYMENT_METHOD__c='@ERR';
        dw.CUSTOMER_TERMS_DAYS__c='0';
        dw.CUSTOMER_CORPORATION_CODE__c='999';
        dw.CUSTOMER_CORPORATION__c='Test';
        dw.SOLDTO_CUSTOMER_CODE__c='590193-000';
        dw.SOLDTO_CUSTOMER__c='Red Truck Beer Company';
        dw.SHIPTO_CUSTOMER_CODE__c='5789456-791040';
        dw.SHIPTO_CUSTOMER__c='Red Truck Beer Company';
        dw.SYS_CREATED__c=system.today();
        dw.SYS_UPDATED__c=system.today();
        dw.SALES_PERSON_CODE__c='CB';
        insert dw;
        
        
        Ship_To_Affiliation__c sf =new Ship_To_Affiliation__c();
        sf.Account__c=acc.id;
        sf.Ship_To_Code__c='5789456-791040';
        insert sf;
        sf.Ship_To_Code__c='5789456-791040';
        update sf;
      
    } 
     @isTest
    public static void testmethod2()
    {
         Account acc= new Account();
        acc.Name='Test';
        insert acc;
        
         Ship_To_Affiliation__c sf =new Ship_To_Affiliation__c();
        sf.Account__c=acc.id;
        sf.Ship_To_Code__c='5789456-791041';
        insert sf;
        
         DWCustomer__c dw= new DWCustomer__c();
        dw.Name='';
        dw.CUSTOMER_KEY__c=45664.56;
        dw.CUSTOMER_TYPE_CODE__c='BW';
        dw.CUSTOMER_TYPE__c='Brewing Market';
        dw.CUSTOMER_SALES_GROUP__c='Small Account';
        dw.CUSTOMER_SEGMENT_CODE__c='XX';
        dw.CUSTOMER_SEGMENT__c='XX-Classification not used';
        dw.CUSTOMER_INDUSTRY_CODE__c='BXC';
        dw.CUSTOMER_INDUSTRY__c='Brewing-Craft';
        dw.SALES_PERSON__c='Chris Webster';
        dw.CUSTOMER_REGION_CODE__c='CN';
        dw.CUSTOMER_REGION__c='Canada';
        dw.CUSTOMER_COUNTRY_CODE__c='BR';
        dw.CUSTOMER_COUNTRY__c='Canada';
        dw.CUSTOMER_TERRITORY_CODE__c='02';
        dw.CUSTOMER_TERRITORY__c='Fresno-based Customer';
        dw.CUSTOMER_STATE_CODE__c='BC';
        dw.CUSTOMER_STATE__c='Canada, British Columbia';
        dw.CUSTOMER_STATUS__c='Open Account';
        dw.CUSTOMER_PAYMENT_METHOD__c='@ERR';
        dw.CUSTOMER_TERMS_DAYS__c='0';
        dw.CUSTOMER_CORPORATION_CODE__c='999';
        dw.CUSTOMER_CORPORATION__c='Test';
        dw.SOLDTO_CUSTOMER_CODE__c='590193-000';
        dw.SOLDTO_CUSTOMER__c='Red Truck Beer Company';
        dw.SHIPTO_CUSTOMER_CODE__c='5789456-791040';
        dw.SHIPTO_CUSTOMER__c='Red Truck Beer Company';
        dw.SYS_CREATED__c=system.today();
        dw.SYS_UPDATED__c=system.today();
        dw.SALES_PERSON_CODE__c='CB';
        dw.Ship_To_Affiliation__c=sf.id;
        insert dw;
    }
   
}