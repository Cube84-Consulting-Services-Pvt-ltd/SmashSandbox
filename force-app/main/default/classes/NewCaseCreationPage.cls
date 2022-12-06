public class NewCaseCreationPage
{
    public case objcase{get;set;}
    public Attachment myAttachment{get;set;}
    public string fileName{get;set;} 
    public Blob fileBody{get;set;}
    
    public NewCaseCreationPage(Apexpages.standardcontroller controller)
    {
        objcase = new case();
        myAttachment =new Attachment();
        Database.DMLOptions dmo = new Database.DMLOptions();
        dmo.assignmentRuleHeader.useDefaultRule = true;
    }
    public pagereference save()
    {
        
        insert objcase;
        System.debug('@@@@@fileBody'+fileBody);     
        myAttachment  = new Attachment();
        if(fileBody!=Null)
        {
            Integer i=0;
            myAttachment .clear();
            myAttachment.Body = fileBody; 
            myAttachment.Name = 'Logo_'+objcase.id+'.jpeg' ; 
            myAttachment.ParentId = objcase.id;             
            insert myAttachment; 
        }
        pagereference pr = new pagereference('/'+objcase.id);                           
        return pr;
        
    }
}