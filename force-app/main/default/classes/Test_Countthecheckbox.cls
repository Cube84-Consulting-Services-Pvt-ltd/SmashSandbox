@isTest
public class Test_Countthecheckbox {
    static testMethod void SearchAccount() {
        
       // static testMethod void SearchAccount2() {
        list<opportunity>opli=new list<opportunity>();
        account acc=new account();
        acc.name='test';
        insert acc;
        
     opportunity op=new opportunity();
        op.Name='BASF';
        op.AccountId=acc.id;
        op.Top_10__c=true;
        op.CountCheck__c=2;
        op.StageName='Needs Analysis';
        op.CloseDate=date.today();
        op.Supplier__c='BASF';
        insert op;
        opli.add(op);
        opportunity op1=new opportunity();
        op1.Name='BASF';
        op1.AccountId=acc.id;
        op1.Top_10__c=true;
        op1.CountCheck__c=2;
        op1.StageName='Closed Won';
        op1.CloseDate=date.today();
        op1.Supplier__c='BASF';
        insert op1;
        opli.add(op1);
     
		//opli.add(op);
        checkRecursive.run = true;        
        op.CountCheck__c=0;
        op.Top_10__c=false;
        op.StageName='closed won';
        op.CloseDate=date.today();
        update op;
        checkRecursive.run = true;        
        op1.CountCheck__c=0;
        op1.Top_10__c=false;
        op1.StageName='Closed Lost';
        op1.CloseDate=date.today();
        update op1;
        
        checkRecursive.run = false;
        op.CountCheck__c=0;
        op.Top_10__c=false;
        op.StageName='closed won';
        op.CloseDate=date.today();
        delete op;
        

    }

    static testMethod void SearchAccount2() {
        list<opportunity>opli=new list<opportunity>();
        account acc=new account();
        acc.name='test';
        insert acc;
     opportunity op=new opportunity();
        op.Name='BASF';
        op.AccountId=acc.id;
        op.Top_10__c=false;
        op.CountCheck__c=2;
        op.StageName='Needs Analysis';
        op.CloseDate=date.today();
        op.Supplier__c='BASF';
        insert op;
        opli.add(op);
        opportunity op1=new opportunity();
        op1.Name='BASF';
        op1.AccountId=acc.id;
        op1.Top_10__c=false;
        op1.CountCheck__c=2;
        op1.StageName='Closed Won';
        op1.CloseDate=date.today();
        op1.Supplier__c='BASF';
        insert op1;
        opli.add(op1);
     
		//opli.add(op);
        checkRecursive.run = true;        
        op.CountCheck__c=3;
        op.Top_10__c=true;
        op.StageName='Needs Analysis';
        op.CloseDate=date.today();
        update op;
        
        checkRecursive.run = false;
        op.CountCheck__c=3;
        op.Top_10__c=true;
        op.StageName='Needs Analysis';
        op.CloseDate=date.today();
        delete op;
        

    }
}