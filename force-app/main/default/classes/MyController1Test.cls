@isTest
public class MyController1Test {
    
    static testmethod void TestgetContactInfo(){
        Test.startTest();
        Account acc= new Account();
        acc.name='Test';
        insert acc;
        
        Ship_To_Affiliation__c sf =new Ship_To_Affiliation__c();
        sf.Account__c=acc.id;
        sf.Ship_To_Code__c='5789456-791040';
        insert sf;
        
        string soldcode='5789456-100570';
        MyController1.getContactInfo(acc.id);
        MyController1.accountInfo(acc.id);
        MyController1.getAccountInfo(sf.Ship_To_Code__c);
        Test.stopTest();
    }
}