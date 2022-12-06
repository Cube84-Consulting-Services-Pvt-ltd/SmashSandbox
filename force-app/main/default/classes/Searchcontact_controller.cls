public class Searchcontact_controller {
public contact acc{get;set;}

public List<Contact> accountList {get;set;}
// create a list of strings to hold the conditions
List<string> conditions = new List<string>();
private integer totalRecs = 0;
private integer OffsetSize = 0;
private integer LimitSize= 1000;
public integer total_size{get;set;}
public Searchcontact_controller(){
system.debug('==>SearchAccount_controller  is calling==>');
 acc = new Contact();
 //accountList  = new List<Account>();
}
public PageReference redirect(){
    PageReference pg = new PageReference(URL.getSalesforceBaseUrl().toExternalForm() +'/003');
     pg.setRedirect(true);
     return pg;
}
    public PageReference newcontact(){
    PageReference pg = new PageReference(URL.getSalesforceBaseUrl().toExternalForm() +'/003/e');
     pg.setRedirect(true);
     return pg;
}
public void searchcon(){
totalRecs = 0;
OffsetSize = 0;
if(accountList !=null && accountList.size()>0){
 accountList=null;
}
searchAccounts ();
conditions.clear();
}
 public void clear(){
        acc.clear();
    }

public Void searchAccounts(){

System.debug('Total Records is ==>'+totalRecs);
System.debug('OffsetSize is ==>'+OffsetSize);

if(accountList != null && !accountList.isEmpty()){
  accountList.clear();
}
 String strQuery ='SELECT Id,OwnerId,Lastname,MailingState,firstname,Name,Email,Phone,Alternate_Mailing_State__c,Secondary_Mailing_State__c,AccountId From Contact';
 if(acc.Alternate_Mailing_State__c!=null && acc.Alternate_Mailing_State__c!=''){
   conditions.add('Alternate_Mailing_State__c Like\'%'+acc.Alternate_Mailing_State__c +'%\' ');
 }

if(acc.Secondary_Mailing_State__c !=null && acc.Secondary_Mailing_State__c !=' ' ){
  conditions.add('Secondary_Mailing_State__c Like\'%'+acc.Secondary_Mailing_State__c +'%\' ');
 }
if(acc.MailingState !=null && acc.MailingState !=' ' ){
  conditions.add('MailingState Like\'%'+acc.MailingState +'%\' ');
 }
if(acc.OwnerId!=null ){
  conditions.add('OwnerId =\''+acc.OwnerId+ '\'');
 }


 if((acc.Lastname !=null && acc.Lastname !='') ||(acc.firstname!=null && acc.FirstName!='')){
   conditions.add('Name Like \'%' +acc.Lastname +'%\' ');
 }

  if (conditions.size() > 0) {
   strQuery += '  WHERE ' + conditions[0];
   for (Integer i = 1; i < conditions.size(); i++)
            strQuery += ' AND ' + conditions[i] ;
  }
 if(totalRecs !=null && totalRecs ==0){
    List<contact> accTemp = Database.query(strQuery);
    totalRecs = (accTemp !=null &&accTemp.size()>0)?accTemp.size():0;
 }
total_size=totalRecs;
 system.debug('strQuery ==>'+strQuery );
 // add sort and limits at the end  
  strQuery += ' ORDER BY Name  ASC, CreatedDate DESC LIMIT :LimitSize OFFSET :OffsetSize';
  
  accountList  =Database.query(strQuery);
  
   

  //conditions.clear();
  //return accountList.size();
}

public void FirstPage()
{
OffsetSize = 0;
searchAccounts();
}
public void previous()
{
OffsetSize = (OffsetSize-LimitSize);
searchAccounts();
}
public void next()
{
OffsetSize = OffsetSize + LimitSize;
searchAccounts();
}
public void LastPage()
{
    integer n=math.mod(totalRecs,LimitSize);
OffsetSize=totalrecs- n;
searchAccounts();
}
public boolean getprev()
{

if(OffsetSize == 0){

return true;
}
else {

return false;
}
}
public boolean getnxt()
{
if((OffsetSize + LimitSize) > totalRecs){

return true;
}
else {

return false;
}
}


}