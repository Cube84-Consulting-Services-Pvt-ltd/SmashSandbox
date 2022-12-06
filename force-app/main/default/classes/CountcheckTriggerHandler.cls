public class CountcheckTriggerHandler{
    
    public static void CountCheck(List<Opportunity> oppLis){
        if(checkRecursive.runOnce()){
            list<Opportunity>opplist=new list<Opportunity>();
            boolean emailcheck=false;
            list<id>aid=new list<id>();
            set<id>opid=new set<id>();
            list<Opportunity>oplist=new list<Opportunity>([select id,StageName,name,OwnerId,Top_10__c,Top20__c from Opportunity where StageName!='Closed Won' OR StageName!='Closed Lost']);
            string sid='';
            //EmailTemplate et=[SELECT Id, body,DeveloperName , IsActive FROM EmailTemplate WHERE DeveloperName = 'Top20'];
            for(Opportunity op:oppLis){
                //id uid=UserInfo.getUserId();
                aid.add(op.OwnerId);
                sid=op.OwnerId;
                opid.add(op.id);
                system.debug('aid'+aid);
                // opplist.add(op);
            }
            //id ccid=sid;
            id uid=UserInfo.getUserId();
            list<user>ulist=new list<user>([select id,username,profile.name from user where Profile.Name!='system Administrator']);
            if(sid!=null){
                for(user uc:ulist){
                    if(uc.id==sid){
                        emailcheck=true; 
                    }
                }
            }
            integer i=0;
            
            for(Opportunity op:oplist){
                if(op.Top_10__c==true && op.OwnerId==sid && emailcheck==true){
                    i=i+1;
                    system.debug('added harsha');
                }
            }
            for(Opportunity opp1:oppLis){
                    if(opp1.stagename=='Closed Won'){
                      opp1.Top_10_Count_Check__c=null;
                     opp1.Top_10__c=false;  
                    }
                    if(opp1.stagename=='Closed Lost'){
                      opp1.Top_10_Count_Check__c=null;
                     opp1.Top_10__c=false;  
                    }
            }
            system.debug('the count is'+i);
            system.debug('the size of the opplist is'+oplist.size());
            // integer s1=i;
            if(oplist.size()>0){
                for(Opportunity op:oppLis){
                    if(op.Top_10__c==true && emailcheck==true){
                        op.Top_10_Count_Check__c=i+1;
                         system.debug('added harsha');
                    }
                    if(op.Top_10_Count_Check__c>10){
                        op.Top_10__c.addError('LIMIT EXCEED');
                    }
                }
                //update opplist;
            }
        }
    } 
    public static void CountCheckup(List<Opportunity> oppLis,Map<Id,Opportunity> oldMap){ 
        
        if(checkRecursive.runOnce()){
            
            boolean emailcheck=false;
            id uid=UserInfo.getUserId();
            list<Opportunity>opp=new list<Opportunity>();
            list<Opportunity>op1=new list<Opportunity>([select id,StageName,name,OwnerId,Top20__c,Top_10__c from Opportunity]);
            set<id>opid=new set<id>();
            list<id>ownerid=new list<id>();
            decimal i=0;
            //EmailTemplate et=[SELECT Id, body,DeveloperName , IsActive FROM EmailTemplate WHERE DeveloperName = 'Top20'];
            string sid='';
            for(Opportunity op:oppLis){
                opid.add(op.id);
                sid=op.OwnerId;
                if(uid!=op.OwnerId && op.Top_10__c==true && oldMap.get(op.id).Top_10__c==false)
                    op.Top_10__c.addError('You do not have access');
                if(uid!=op.OwnerId && op.Top_10__c==false && oldMap.get(op.id).Top_10__c==true)
                    op.Top_10__c.addError('You do not have access');
                
                //i=op.CountCheck__c;
                ownerid.add(op.OwnerId);
                opp.add(op);
                
            }
            id ccid=sid;
            list<user> ulist=new list<user>([select id,username,profile.name from user where Profile.Name!='system Administrator']);
            for(user uc:ulist){
                if(uc.id==ccid){
                    system.debug('the email check is'+uc.id);
                    system.debug('the email check is'+sid);
                    emailcheck=true; 
                    system.debug('the email check is'+emailcheck);
                }
            }
            if(emailcheck==true){
                system.debug('the email check is'+emailcheck);
                integer i1=[select count() from Opportunity where OwnerId=:ownerid and Top_10__c=true];
                i=i1;
                 system.debug('harsha added'+i);
            }
            system.debug('the update..........'+i);
            for(opportunity opp1:oppLis){//iterating the opp for getting the count of check boxcess
                if(oldMap.get(opp1.id).Top_10__c==true && opp1.Top_10__c==false && emailcheck==true ){
                    i=i-1;
                   system.debug('harsha added'+i);  
                }
                if(oldMap.get(opp1.id).Top_10__c==false && opp1.Top_10__c==true && emailcheck==true){
                    i=i+1;
                     system.debug('harsha added'+i);
                }
                if(opp1.StageName=='Closed Won' ) {
                    opp1.Top_10_Count_Check__c=null;
                    opp1.Top_10__c=false;
                   } 
                if(opp1.StageName=='Closed Lost') {
                    opp1.Top_10_Count_Check__c=null;
                    opp1.Top_10__c=false;
                }
                system.debug('the count is'+i);
                
                system.debug('the count of the'+i);
            }
            //checking the no.of check boxcess 
            for(opportunity opp7:opp){
                if(opp7.Top_10__c==true){
                    opp7.Top_10_Count_Check__c=i;//assaigning the count to the field
                    system.debug('harsha added'+opp7.Top_10_Count_Check__c);
                }
                if(opp7.Top_10__c==false && emailcheck==true){
                    opp7.Top_10_Count_Check__c=null;  
                     system.debug('harsha added'+opp7.Top_10_Count_Check__c);
                }
                
                if(opp7.Top_10_Count_Check__c>10 && opp7.Top_10__c==true && emailcheck==true){  //checking the count and the check box
                    opp7.Top_10__c.addError('LIMIT EXCEEDS'); //error message     
                    system.debug('harsha added');
                }
            }
        }
    }
    public static void CountCheckdel(List<Opportunity> oldlist){
        id uid=UserInfo.getUserId();
        String test = Label.NateId;
        for(Opportunity opp:oldlist){
            if(opp.OwnerId!=uid && uid!=test){
                opp.Top_10__c.addError('You do not have access');

            }
        }
    }
     public static void CountCheckAfter(List<Opportunity> oppLis,Map<Id,Opportunity> oldMap){
         Decimal i=0;
        system.debug('is After');
        list<id>ac=new list<id>();
       list<id>ac1=new list<id>();
        decimal count=0;
        boolean emailcheck=false;
        string sid='';
        for(Opportunity op:oppLis){
            ac.add(op.id);
            sid=op.OwnerId;
            ac1.add(op.OwnerId);
            count=op.Top_10_Count_Check__c;
        }
        id ccid=sid;
        list<user>ulist=new list<user>([select id,username,profile.name from user where Profile.Name!='system Administrator']);
        for(user uc:ulist){
            if(uc.id==ccid){
                system.debug('the email check is'+uc.id);
                system.debug('the email check is'+sid);
                emailcheck=true; 
                system.debug('the email check is'+emailcheck);
            }
        }
         if(emailcheck==true){
            system.debug('the email check is'+emailcheck);
            integer i1=[select count() from Opportunity where OwnerId=:sid and Top_10__c=true];
            i=i1;
        }
        system.debug('the count is'+count);
       list<Opportunity>oplist=new list<Opportunity>([select id,name,StageName,LastModifiedDate from Opportunity order by LastModifiedDate DESC limit 1]);
        system.debug('the list of opp are'+oplist);
        system.debug('the list of the opp2'+ac);
        list<Opportunity>oplist1=new list<Opportunity>([select id,StageName,name,Top_10__c,Top20__c,OwnerId,CountCheck__c,Top_10_Count_Check__c from Opportunity where Top_10__c=true and OwnerId=:ac1]);
        list<Opportunity>oplist2=new list<Opportunity>();
        system.debug('the oplist1 '+oplist1.size());
         system.debug('the oplist1 '+emailcheck);
        if(!oplist1.isEmpty()){
        for(Opportunity opp:oplist1){
            if(opp.Top_10_Count_Check__c!=i && emailcheck==true){
                opp.Top_10_Count_Check__c=i;
                
                oplist2.add(opp);}
            system.debug('the countcheck is'+opp.Top_10_Count_Check__c);
        }
        if(!oplist2.isEmpty())
        update oplist2;
}
    }
}