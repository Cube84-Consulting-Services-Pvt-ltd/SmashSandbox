global class QuotePDFGenerator {
  
  @future(callout=true)
   public Static Void AttachPDFToQuote(ID Id) {
       ID createdId; 
       PageReference ref = new PageReference('');
       try {
           CreateQuoteDocumentFromPDF(Id);
       } catch(exception ex) {
           System.debug('Error: ' + ex);
       }
    }
    
    public static String CreateQuoteDocumentFromPDF(ID Id) {
        System.debug('in PDF Creator'+Id);
        //String quoteURL = '/quote/quoteTemplateDataViewer.apexp?headerHeight=156&footerHeight=94&summlid=0EH63000000gB7s&id=' + Id;
        
      String quoteURL = '/quote/quoteTemplateDataViewer.apexp?headerHeight=156&footerHeight=94&summlid=0EH6g000004UGDt&id='+ Id;
      Blob renderedPDF;                                                                                
        if (Test.isRunningTest()) {
            renderedPDF = Blob.valueOf('Unit.Test');
            System.debug('Error: ' );
        } else {
            renderedPDF = new PageReference(quoteURL).getContentAsPDF();
            System.debug('Error: ' );
        }
        QuoteDocument doc = new QuoteDocument(QuoteId = Id, Document = renderedPDF);
        INSERT doc;
        String Name = [select Name from QuoteDocument where QuoteId =: Id].Name;
        //String Name = [select Id, Name from QuoteDocument where QuoteId =: Id].Id;
        RETURN Name;
    } 
    
}