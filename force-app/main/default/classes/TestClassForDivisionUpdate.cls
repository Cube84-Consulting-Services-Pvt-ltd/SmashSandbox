@istest
public class TestClassForDivisionUpdate {
    static testMethod void DivisionUpdate(){
        Account a=new account();
        a.name ='test';
        insert a;
        contact c=new contact();
        c.Lastname='Test';
        c.FirstName='@C84';
        c.AccountId=a.id;
        insert c; 
        opportunity o =new opportunity();
        o.name='test';
        o.StageName='closed won';
        o.CloseDate=system.today();
        o.AccountId=a.id;
        o.Est_Closed_Date__c=system.today();
        insert o;
        Quote q= new Quote();
        q.name='Test';
        q.Customer_Name__c=a.id;
        q.Division_NA__c='midwest';
        q.OpportunityId=o.id;
        insert q;
        Division__c d=new Division__c();
        d.name='midwest';
        insert d;
        
    }
}