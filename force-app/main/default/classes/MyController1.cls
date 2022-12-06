public class MyController1 {
    
    
    @AuraEnabled   
    public static map<string,object> getContactInfo(Id recordId)
    {
        system.debug(''+recordId);
        map<string,object> mapObjects =new map<string,object>();
        map<string,string> mapIds =new map<string,string>();
        // system.debug(String.valueOf(recordId.getSobjectType()));
        String objectName = String.valueOf(recordId.getSobjectType());
        system.debug(''+objectName);
        
        if(objectName=='Account')
        {
           Account acc=[select id,name,SOLDTO_CUSTOMER_CODE__c from Account where id =: recordId];
            mapIds.put(acc.id,acc.id);
            
            system.debug(mapIds);
        }
        
        mapObjects.put('ObjectName',objectName);
        mapObjects.put('Ids',mapIds);
      //  mapObjects.put('soldtocode',acc.SOLDTO_CUSTOMER_CODE__c);
        return mapObjects;
    }
    
    @AuraEnabled
    public static Id accountInfo(Id recordId){
        system.debug('recordId>>> ' + recordId);
        return recordId;
    }
    
    @AuraEnabled
    public static String getAccountInfo(String soldcode){
        system.debug('accountId>>> ' + soldcode);
      //  account acc1=[select id,name,SOLDTO_CUSTOMER_CODE__c,AURORA_ACCOUNT_NUMBER__c from Account where SOLDTO_CUSTOMER_CODE__c =: soldcode]; 
       Ship_To_Affiliation__c aff= [select id,Affiliated_Account_Name__c,Ship_To_Code__c from Ship_To_Affiliation__c where Ship_To_Code__c =: soldcode LIMIT 1]; 
        string soldtocode =aff.Affiliated_Account_Name__c;
        return soldtocode;
    }
}