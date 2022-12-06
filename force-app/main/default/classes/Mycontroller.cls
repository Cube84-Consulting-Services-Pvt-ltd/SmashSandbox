public class Mycontroller {
   /* @AuraEnabled   
    public static string saveopprtunity(Opportunity opp)
    {
        insert opp;
        system.debug('Opp>>> '+opp);
        return opp.Id;
    } */
    
    
    @AuraEnabled   
    public static map<string,object> getContactInfo(Id recordId)
    {
        map<string,object> mapObjects =new map<string,object>();
        map<string,string> mapIds =new map<string,string>();
        String objectName = String.valueOf(recordId.getSobjectType());
        system.debug(''+objectName);
        if(objectName=='Contact')
        {
            Contact con=[select id,AccountId from Contact where id =: recordId]; 
            mapIds.put(con.id,con.AccountId);
            system.debug(mapIds);
        }
        else
        {
            account acc=[select id,name from Account where id =: recordId];
            mapIds.put(acc.id,acc.id);
            system.debug(mapIds);
        }
        
        mapObjects.put('ObjectName',objectName);
        mapObjects.put('Ids',mapIds);
        system.debug('Test');
        return mapObjects;
       
    }
}