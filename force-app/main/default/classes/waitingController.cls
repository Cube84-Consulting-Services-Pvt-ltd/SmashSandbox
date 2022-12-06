public class waitingController {
    public Id quoteId{get; set;}
    public Boolean jobCompleted {get; set;}
    
    public waitingController(ApexPages.StandardController controller){
        quoteId = ApexPages.currentPage().getParameters().get('id');
        
        System.debug('the quoteID '+quoteId);
    }
    final Long start = Datetime.now().getTime();
    public Boolean getIsEnabled() { return Datetime.now().getTime() - start < 60 * 1000; }

    Integer count = 0;
    public Integer getCount() { return count; }
    
    public PageReference incrementCounter() {
        //check if the quotes PDF if generated,
        //AsyncApexJob jobInfo = [SELECT Status,NumberOfErrors FROM AsyncApexJob WHERE Id=:jobID];
        Id  cdlink;
        for(ContentDocumentLink cdl : [select id,contentdocumentId from contentDocumentlink where linkedEntityId =: quoteId ])
        {
            cdlink= cdl.contentdocumentId;
            }
            Quote qute = [SELECT ID, isPDFdownloaded__c FROM Quote WHERE ID =:quoteId];
        //if(jobInfo.status == 'Completed'){
        system.debug('qute.isPDFdownloaded__c'+qute.isPDFdownloaded__c);
           system.debug('cdlink'+cdlink);
        if(cdlink!=null && qute.isPDFdownloaded__c == false){
            qute.isPDFdownloaded__c = true;
            Database.update(qute);
            PageReference ref = new PageReference('https://gusmerenterprises.lightning.force.com/sfc/servlet.shepherd/document/download/'+cdlink+'?operationContext=S1');
            jobCompleted = true;
            return ref;
        }else{
            return null;
        }
    }
}