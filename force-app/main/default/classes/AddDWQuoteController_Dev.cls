public class AddDWQuoteController_Dev {
    public Quote quote;
    public Id quoteId;
    public Id jobId;
    public boolean test=false;
    public Opportunity theoppid{get;set;}
    public Account theaccid{get;set;}
    //public Quote newid{get;set;}
    //public quoteDocument quotePDF {get; set;}
    // public Boolean jobCompleted {get; set;}
    //Id cdlId {get; set;}
    //Public Boolean isTimerOn {get; set;}
    
    public ApexPages.StandardController stdCtrl;  
    //     public AddQuoteController(ApexPages.StandardController controller){
    //      Qlst=[Select id,OpportunityID from Quote WHERE Id = :ApexPages.currentPage().getParameters().get('id')];
    //  }
    public AddDWQuoteController_Dev(ApexPages.StandardController controller){
        stdCtrl=controller;
        theoppid =[Select id,name,AccountID from Opportunity WHERE Id = :apexpages.currentpage().getparameters().get('att')];
        system.debug(theoppid);
        theaccid=[select name,BillingStreet,BillingCity,BillingState,BillingPostalCode,BillingCountry,ShippingStreet,ShippingCity,ShippingState,ShippingPostalCode,ShippingCountry from account where id = :theoppid.AccountId];
        
        quote= (Quote)controller.getRecord();
        system.debug('id value'+quote);
        quote.OpportunityId=theoppid.id;
        quote.ExpirationDate= Date.newInstance(2021,12,31);
        quote.ShippingName=theaccid.Name;
        quote.BillingName=theaccid.Name;
        quote.BillingStreet=theaccid.BillingStreet;
        quote.BillingCity=theaccid.BillingCity;
        quote.BillingState=theaccid.BillingState;
        quote.BillingPostalCode=theaccid.BillingPostalCode;
        quote.BillingCountry=theaccid.BillingCountry;
        quote.ShippingStreet=theaccid.ShippingStreet;
        quote.ShippingCity=theaccid.ShippingCity;
        quote.ShippingState=theaccid.ShippingState;
        quote.ShippingPostalCode=theaccid.ShippingPostalCode;
        quote.ShippingCountry=theaccid.Shippingcountry;
        quote.isPDFdownloaded__c = false;
        
        //   inputText2 = apexpages.currentpage().getparameters().get('att');
        
    }
    
    public Void save1(){
        Database.SaveResult sr = Database.insert(quote);
        if(sr.isSuccess()){
            quoteId = sr.getId();
            //jobId = System.enqueueJob(new QuotePDF_QueueableApex(quoteId));
            //isTimerOn = true;
        }else{
            System.debug(sr.getErrors());
        }
    }
    public Void save(){
        quote.isPDFdownloaded__c = true; 
        quote.IsDownlaoded__c =true;
        Database.SaveResult sr = Database.insert(quote);
        if(sr.isSuccess()){
            quoteId = sr.getId();
            
            //jobId = System.enqueueJob(new QuotePDF_QueueableApex(quoteId));
            //isTimerOn = true;
        }else{
            System.debug(sr.getErrors());
        }
    }
    public PageReference afterSave(){
        System.debug('the after Save logic'+quoteId);
        return new PageReference('/'+quoteId);
    }
    /*public PageReference incrementCounter() {
//check if the quotes PDF if generated,
AsyncApexJob jobInfo = [SELECT Status,NumberOfErrors FROM AsyncApexJob WHERE Id=:jobID];
if(jobInfo.status == 'Completed'){
ContentDocumentLink cdl = [select id,contentdocumentId from contentDocumentlink where linkedEntityId =:quoteId];
cdlId = cdl.contentdocumentId;
//PageReference ref = new PageReference('https://gusmerenterprises--partial.lightning.force.com/sfc/servlet.shepherd/document/download/'+cdl.contentdocumentId+'?operationContext=S1');
jobCompleted = true;
PageReference ref = Page.WaitingVFPage;
ref.getParameters().put('id',quoteId);
ref.getParameters().put('jobId',jobId);
ref.setRedirect(true); 
return ref;
}else{
return null;
}
}*/
}