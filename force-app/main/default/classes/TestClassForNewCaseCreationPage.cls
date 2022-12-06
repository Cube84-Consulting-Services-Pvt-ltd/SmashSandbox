@istest
public class TestClassForNewCaseCreationPage {
    public  static testmethod void Mytest(){
        case c = new case();
        c.subject='Test';
        c.description='Test';
        c.Category__c='enhancement';
        c.Status='new';
        insert c;
        
        Attachment attach=new Attachment();      
        attach.Name='Unit Test Attachment';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        attach.body=bodyBlob;
        attach.parentId=c.id;
        insert attach;
        NewCaseCreationPage controller=new NewCaseCreationPage(new ApexPages.StandardController(c));        
        Controller.fileBody=bodyBlob;
        Controller.save();
        
    }
}