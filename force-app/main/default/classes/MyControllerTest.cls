@isTest(SeeAllData=true)
public class MyControllerTest {

    @isTest
    public static void contactInformation(){
        Account acc=new account();
        acc.Name='Test';
        insert acc;
        
    //   String result=MyController.getContactInfo(acc.id,Account);
    
     
        
       Map<string,object> m=MyController.getContactInfo(acc.id);
        
        Contact c=new Contact();
        c.FirstName='new';
        c.LastName='test';
        c.AccountId=acc.id;
        insert c;
        
          Map<string,object> m1=MyController.getContactInfo(c.id);
        
     //   String result1=MyController.getContactInfo(c.id);
        
   /*    list<opportunity>op=new list<opportunity>();
        Opportunity opp=new opportunity();
        opp.Name='Test';
        opp.AccountId=acc.id;
        opp.ContactId=c.id;
        opp.StageName='Closed Lost';
        opp.Closed_Lost_Reason__c='Price';
        opp.CloseDate=system.today();
         op.add(opp);
        String result2=MyController.saveopprtunity(opp);
        update opp; */
         
}
}