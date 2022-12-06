@RestResource(urlMapping='/Quote/PDFGenerator/*')
global with sharing class QuotePDFGeneratorResource {
  
  @HttpPost
    global static String doPost(ID Id) {
         try {
        QuotePDFGenerator.AttachPDFToQuote(Id);
       
         }
        catch(exception ex) {
            System.debug('Error: ' + ex);
        }
            return 'SUCCESS';
    }
    
}