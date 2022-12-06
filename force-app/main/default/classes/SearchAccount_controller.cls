public with sharing class SearchAccount_controller {
public Account acc{get;set;}
public List<Account> accountList {get;set;}
// create a list of strings to hold the conditions
List<string> conditions = new List<string>();
private integer totalRecs = 0;
private integer OffsetSize = 0;
private integer LimitSize= 1000;
public integer total_size{get;set;}
public SearchAccount_controller(){
system.debug('==>SearchAccount_controller  is calling==>');
 acc = new Account();
 //accountList  = new List<Account>();
}

public void searchAcc(){
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

public PageReference redirect(){
    PageReference pg = new PageReference(URL.getSalesforceBaseUrl().toExternalForm() +'/001');
     pg.setRedirect(true);
     return pg;
}
    public PageReference newaccount(){
        PageReference pg = new PageReference(URL.getSalesforceBaseUrl().toExternalForm() +'/001/e');
     pg.setRedirect(true);
     return pg; 
    }
    
public Void searchAccounts(){

System.debug('Total Records is ==>'+totalRecs);
System.debug('OffsetSize is ==>'+OffsetSize);

if(accountList != null && !accountList.isEmpty()){
  accountList.clear();
}
 String strQuery ='SELECT Id,Name,OwnerId,AccountNumber,CreatedDate,Market__c,BillingState,ShippingState,Phone,Website,Industry,AnnualRevenue From Account';
 if(acc.Market__c!=null){
 String Market = acc.Market__c;
   conditions.add('Market__c =\''+acc.Market__c+ '\'');
 }

if(acc.BillingState !=null && acc.BillingState !=' ' ){
  conditions.add('BillingState Like\'%'+acc.BillingState +'%\' ');
 }

 if(acc.Name !=null && acc.Name !=''){
   conditions.add('Name Like \'%' +acc.Name +'%\' ');
 }
  if(acc.ShippingState !=null && acc.ShippingState !=''){
   conditions.add('ShippingState Like\'%' +acc.ShippingState +'%\' ');
 }
if(acc.OwnerId !=null){
   conditions.add('OwnerId =\''+acc.OwnerId+ '\'');
 }
  if (conditions.size() > 0) {
   strQuery += '  WHERE ' + conditions[0];
   for (Integer i = 1; i < conditions.size(); i++)
            strQuery += ' AND ' + conditions[i] ;
  }
 if(totalRecs !=null && totalRecs ==0){
    List<Account> accTemp = Database.query(strQuery);
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