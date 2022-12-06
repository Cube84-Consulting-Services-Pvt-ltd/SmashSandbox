Public class downloadMessageController {

    @AuraEnabled
    Public static Boolean getDownloadIndictor(Id artId) {
        Boolean IsDownlaoded;
        try{
            IsDownlaoded = [SELECT IsDownlaoded__c from Quote where id =:artId].IsDownlaoded__c;
            Quote upquote = [SELECT id,IsDownlaoded__c from Quote where id =:artId];
        upquote.IsDownlaoded__c=true;
            update upquote;
        }
        catch(Exception e){
            System.debug(e);
        }
         
        return IsDownlaoded;
       
    }
}