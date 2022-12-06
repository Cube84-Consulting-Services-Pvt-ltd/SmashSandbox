public class OpportunityDWProductEntryExtension_DEV {
    
    public String currentURL {get;set;}
    public Opportunity theOpp {get;set;}
    public String searchString {get;set;}
    public String searchFamily {get;set;}
    public lineItems[] shoppingCartwithDW {get; set;}
    public priceBookEntry[] availableProductsPBE {get;set;}
    public products[] availableProductsWithDW {get;set;}
    public Pricebook2 theBook {get;set;}
    public Product2 search {Set;Get;}
    public DWProduct__c search1 {Set;Get;}
    
    public String toSelect {get; set;}
    public String toUnselect {get; set;}
    public Decimal Total {get;set;}
    
    public Boolean overLimit {get;set;}
    public Boolean multipleCurrencies {get; set;}
    public Decimal OppTotals {Set;Get;}
    
    public String qty {get; set;}
    public String productId {get; set;}
    public String rowId {get; set;}
    public integer selectedRow {get;set;}
    
    private Boolean forcePricebookSelection = false;
    Set<opportunityLineItem> forDeletion = new Set<opportunityLineItem>{};
        List<DW_Opportuinity_Product__c> dwProdRemoveList = new List<DW_Opportuinity_Product__c>();
    List<OpportunityLineItem> opptyProdRemoveList = new List<OpportunityLineItem>();
    
    
    public opportunityDWProductEntryExtension_DEV(ApexPages.StandardController controller) {
        shoppingCartwithDW = new List<lineItems>();
        search = new Product2(Product_Type__c='');
        search1 = new DWProduct__c(Custom_Family__c='');
        // Need to know if org has multiple currencies enabled
        multipleCurrencies = UserInfo.isMultiCurrencyOrganization();
        
        // Get information about the Opportunity being worked on
        if(multipleCurrencies)
            theOpp = database.query('select Id,name, Pricebook2Id, Pricebook2.Name, CurrencyIsoCode from Opportunity where Id = \'' + controller.getRecord().Id + '\' limit 1');
        else
            theOpp = [select Id, Pricebook2Id,name, PriceBook2.Name from Opportunity where Id = :controller.getRecord().Id limit 1];
        
        // If products were previously selected need to put them in the "selected products" section to start with
        /*  new logic for(opportunityLineItem oli : [select Id, Quantity,Discount,AmountC__c,TotalPrice__c,Subtotal,TotalPrice,Grade__c, UnitPrice, Description, 
PriceBookEntryId, PriceBookEntry.Name, PriceBookEntry.IsActive, PriceBookEntry.Product2Id, 
PriceBookEntry.Product2.Name,PriceBookEntry.Product2.ProductCode, PriceBookEntry.PriceBook2Id,
OpportunityId,Initial_Quantity__c,Delta__c,Upsell__c,Downsell__c,Renewal__c,Product2Id,OppProductName__c
from opportunityLineItem where OpportunityId=:theOpp.Id]){
//Integer i = 0;
shoppingCartwithDW.add(new lineItems(oli.Product2Id, null,false,oli,true,(shoppingCartwithDW.size()+1)));//(Product/DWproduct Id,DW_Opportuinity_Product__c,Boolean,opportunityLineItem,Boolean)
//i++;
}*/
        for(DW_Opportuinity_Product__c dwop: [SELECT ID, Quantity__C, Name,DW_Opportuinity_Product__c.UnitPrice__c,DW_PriceBook_Entry__r.Name,
                                              Initial_Quantity__c,DW_PriceBook_Entry__r.DWProduct__c,DWProduct__c,DWProduct__r.ITEM_DESCRIPTION__c,
                                              DWProduct__r.ITEM__c, Grade__c,Unit_of_Measure__c,Package_Size__c,Units_Per_Pallet__c,Description__c,DWProduct__r.Name,Primary__c, DWProduct__r.PRODUCT_TYPE__c 
                                              FROM DW_Opportuinity_Product__c WHERE Opportunity__c =:theOpp.Id]){
                                                  shoppingCartwithDW.add(new lineItems(dwop.DWProduct__c, dwop,true,null,false,(shoppingCartwithDW.size()+1)));//(Product/DWproduct Id,DW_Opportuinity_Product__c,Boolean,opportunityLineItem,Boolean)
                                              }
        system.debug('dwop'+shoppingCartwithDW);
        system.debug('shopping cart with DW size '+shoppingCartwithDW.size());
        //refreshTotals(); //should be revived at the earliest
        
        // Check if Opp has a pricebook associated yet
        if(theOpp.Pricebook2Id == null){
            Pricebook2[] activepbs = [select Id, Name from Pricebook2 where isActive = true limit 2];
            if(activepbs.size() == 2){
                forcePricebookSelection = true;
                theBook = new Pricebook2();
            }
            else{
                theBook = activepbs[0];
            }
        }
        else{
            theBook = theOpp.Pricebook2;
        }
        if(Test.isRunningTest()) theBook= new PriceBook2(Id=Test.getStandardPricebookId());
        //if(!forcePricebookSelection)
        updateAvailableList();
    }
    public void clearfilter(){
        searchString=null;
        search = new Product2(family=null);
        Search1=new DWProduct__c(Custom_Family__c=null,Custom_Supplier__c=null);
        updateAvailableList();
    } 
    // this is the 'action' method on the page
    /* logic change  public PageReference priceBookCheck(){

// if the user needs to select a pricebook before we proceed we send them to standard pricebook selection screen
if(forcePricebookSelection){        
return changePricebook();
}
else{

//if there is only one active pricebook we go with it and save the opp
if(theOpp.pricebook2Id != theBook.Id){
try{theOpp.Pricebook2Id = theBook.Id;update(theOpp);}catch(Exception e){ApexPages.addMessages(e);}
}

return null;
}
}*/
    
    public String getChosenCurrency(){
        
        if(multipleCurrencies)
            return (String)theOpp.get('CurrencyIsoCode');
        else
            return '';
    }
    
    public void updateAvailableList() {
        
        // We dynamically build a query string and exclude items already in the shopping cart
        String qString = 'select Id, Pricebook2Id, IsActive,Product2.Supplier__c, Product2.Curriculum__c,Product2.Resale__c,Product2.Interested_Product_Type__c,Product2.Manufactured__c,Product2.Name, Product2.Family,Product2.Product_Type__c, Product2.IsActive, Product2.Description, Product2.ProductCode, UnitPrice from PricebookEntry where IsActive=true and Pricebook2Id = \'' + theBook.Id + '\'';
        
        String dwQueryString = 'SELECT Id,Name,DWProduct__r.Product_Supplier__c,DWProductPrices__c,DWProduct__c,DWProduct__r.Name,UnitPrice__c,DWProduct__r.ITEM_DESCRIPTION__c,DWProduct__r.ITEM__c,DWProduct__r.PRODUCT_GROUP__c, DWProduct__r.PRODUCT_TYPE__c  FROM DW_PriceBook_Entry__c WHERE IsActive__c=true';
        
        if(multipleCurrencies)
             qstring += ' and CurrencyIsoCode = \'' + theOpp.get('currencyIsoCode') + '\'';
            System.debug('searchString'+searchString);
            // note that we are looking for the search string entered by the user in the name OR description
            // modify this to search other fields if desired
            if(String.isNotBlank(searchString)){
                List<String> lstSearch = searchString.split(' ');
                system.debug('lstSearch'+lstSearch);
                for(Integer i = 0; i < lstSearch.size(); i++){
                    String newStr = lstSearch[i].replaceAll( '\\s+', '');
                    //  new logic qString+= ' AND (Product2.Name like \'%' + searchString + '%\' or Product2.Description like \'%' + searchString + '%\')';
                    //dwQueryString+= ' AND (DWProduct__r.ITEM__c like \'%'+ searchString +'%\' or DWProduct__r.ITEM_DESCRIPTION__c like \'%'+ searchString +'%\')';
                    dwQueryString+= ' AND (DWProduct__r.ITEM__c like \'%'+ newStr +'%\' or DWProduct__r.ITEM_DESCRIPTION__c like \'%'+ newStr +'%\')';
                    
                }
            }system.debug(search.Product_Type__c);
        /* new logic if(search !=null && String.isNotBlank(search.Curriculum__c))
{ 
qString+= ' AND Product2.Curriculum__c = \''+ String.escapeSingleQuotes(search.Curriculum__c.trim()) +'\'';
}
if(search !=null && String.isNotBlank(search.Product_Type__c))
{ 
qString+= ' AND  Product2.Product_Type__c = \''+String.escapeSingleQuotes(search.Product_Type__c.trim()) +'\'';
}
if(search !=null && String.isNotBlank(search.Supplier__c))
{ 
qString+= ' AND  Product2.Supplier__c = \''+String.escapeSingleQuotes(search.Supplier__c.trim()) +'\'';
//dwQueryString += ' AND  DWProduct__r.Supplier__c = \''+String.escapeSingleQuotes(search.Supplier__c.trim()) +'\'';
}*/
        /*  if(String.isNotBlank(search1.Custom_Family__c)){
//  new logicqString+= ' AND  Product2.Family like \'%'+ searchFamily +'%\'';
dwQueryString+= ' AND DWProduct__r.PRODUCT_GROUP__c like \'%'+ searchFamily +'%\'';
} */
        if(search1 !=null && String.isNotBlank(search1.Custom_Family__c))
        { 
            // new logic qString+= ' AND  Product2.Family = \''+String.escapeSingleQuotes(search.Family.trim()) +'\'';
            dwQueryString+= ' AND DWProduct__r.PRODUCT_GROUP__c = \''+String.escapeSingleQuotes(search1.Custom_Family__c.trim())+'\'';
        }
        if(search1 !=null && String.isNotBlank(search1.Custom_Supplier__c))
        { 
            // new logic qString+= ' AND  Product2.Family = \''+String.escapeSingleQuotes(search.Family.trim()) +'\'';
            dwQueryString+= ' AND DWProduct__r.Product_Supplier__c = \''+String.escapeSingleQuotes(search1.Custom_Supplier__c.trim())+'\'';
        }
        if(search !=null && search.IsActive )
        { 
            //new logic qString+= ' AND  Product2.IsActive ='+search.IsActive ;
        }  
        
        Set<Id> selectedEntriesWithDW = new Set<Id>();
        for(lineItems l : shoppingCartwithDW){
            if(l.isOpptyLine){
                selectedEntriesWithDW.add(l.oli.PricebookEntryId);
            }
            if(l.isDWline){
                selectedEntriesWithDW.add(l.dwOpptyProd.DW_PriceBook_Entry__c);
            }
        }
        system.debug('the selected Entries '+selectedEntriesWithDW);
        if(selectedEntriesWithDW.size()>1){
            String tempFilter = ' and Id not in (';
            for(Id i : selectedEntriesWithDW){
                if(i!=null)
                    tempFilter+= '\'' + (String)i + '\',';
            }
            String extraFilter = tempFilter.substring(0,tempFilter.length()-1);
            extraFilter+= ')';
            // new logic qString+= extraFilter;
            dwQueryString+= extraFilter;
        }
        // new logic  qString+= ' limit 101';
        dwQueryString+= ' limit 101';
        System.debug('the dwQUeryString '+dwQueryString);
        // new logic availableProductsPBE = database.query(qString);
        availableProductsWithDW = new List<products>();
        for(DW_PriceBook_Entry__c dwpbe : database.query(dwQueryString)){
            availableProductsWithDW.add(new products(dwpbe.id,null,false,dwpbe,true));//id,PriceBookEntry,isPriceBookEntry,dwPriceBook,isDWpricebook
        }
        System.debug('the availableProductsWithDW '+availableProductsWithDW);
        /*availableProductsPBEfor(PriceBookEntry pbe : availableProductsPBE){
availableProductsWithDW.add(new products(pbe.id,pbe,true,null,false));//id,PriceBookEntry,isPriceBookEntry,dwPriceBook,isDWpricebook
}*/
        
        system.debug('the size of PBE'+availableProductsWithDW.size());
        //availableProductsWithDW.add(database.query(query));
        // We only display up to 100 results... if there are more than we let the user know (see vf page)
        if(availableProductsWithDW.size()==101){
            availableProductsWithDW.remove(100);
            overLimit = true;
        }
        else{
            overLimit=false;
        }
    }
    
    public void addToShoppingCart(){
        // This function runs when a user hits "select" button next to a product
        Decimal unitPrice=0;
        for(products p : availableProductsWithDW){
            /* logic change  if(p.isPBE){
if(p.pbe.Id == toSelect){
//add the products to shoppingCart this again should be a wrapper class logic pending
opportunityLineItem oli = new OpportunityLineItem(OpportunityId=theOpp.Id, PriceBookEntry=p.pbe, PriceBookEntryId=p.pbe.Id,Quantity=1, UnitPrice=p.pbe.UnitPrice, Initial_Quantity__c=1);
shoppingCartwithDW.add(new lineItems(oli.Product2Id, null,false,oli,true,(shoppingCartwithDW.size()+1)));
break;
}
}*/
            if(p.isDWpbe){
                if(p.dwPBE.Id == toSelect){
                    DWProductPrices__c[] dwProductPrices = [SELECT Id,PRODUCT_REF__c,LIMIT_1__c,LIMIT_2__c,LIMIT_3__c,LIMIT_4__c,LIMIT_5__c,PRICE_1__c,
                                                            PRICE_2__c,PRICE_3__c,PRICE_4__c,PRICE_5__c,START_DATE_NEW__c,END_DATE_NEW__c 
                                                            FROM DWProductPrices__c 
                                                            WHERE PRODUCT_REF__c =: p.dwPBE.DWProduct__c AND isActive__c = true ORDER BY Createddate DESC LIMIT 1];//AND 
                    
                    DWProductPrices__c dwProductPrice = new DWProductPrices__c();
                    for(DWProductPrices__c dwpp : dwProductPrices){
                        dwProductPrice = dwpp;
                    }
                    if(dwProductPrices != null){
                        
                        if(1 <= dwProductPrice.LIMIT_1__c){
                            unitPrice = dwProductPrice.PRICE_1__c;
                        }else if(1 <= dwProductPrice.LIMIT_2__c){
                            unitPrice = dwProductPrice.PRICE_2__c;
                        }
                        else if(1 <= dwProductPrice.LIMIT_3__c){
                            unitPrice = dwProductPrice.PRICE_3__c;
                        }
                        else if(1 <= dwProductPrice.LIMIT_4__c){
                            unitPrice = dwProductPrice.PRICE_4__c;
                        }
                        else if(1 <= dwProductPrice.LIMIT_5__c){
                            unitPrice = dwProductPrice.PRICE_5__c;
                        }
                    }
                    DW_Opportuinity_Product__c dwLine = new DW_Opportuinity_Product__c(Opportunity__c=theOpp.Id,Quantity__c=1,
                                                                                       Initial_Quantity__c= 1,DWProduct__c=p.dwPBE.DWProduct__c,
                                                                                       DW_PriceBook_Entry__c=p.dwPBE.Id,Name=p.dwPBE.DWProduct__r.ITEM_DESCRIPTION__c ,
                                                                                       UnitPrice__c=unitPrice);
                    //((p.dwPBE.UnitPrice__c==null)?0:p.dwPBE.UnitPrice__c)
                    //DW_PriceBook_Entry__r.DWProduct__c=p.dwPBE.DWProduct__c);
                    //dwOP.UnitPrice__c*dwOP.Quantity__c);
                    system.debug('dwLine'+dwLine);
                    shoppingCartwithDW.add(new lineItems(dwLine.DWProduct__c, dwLine,true,null,false,(shoppingCartwithDW.size()+1)));
                    qty = String.valueOf(dwLine.Quantity__c);
                    productId = dwLine.DWProduct__c;
                    break;
                }
            }
        }
        //specify qty and product then call quantityChange();
        quantityChange();
        quantityChangeOnOpptyProd();
        updateAvailableList();
    }
    
    public void cloneProduct(){
        system.debug('the index '+apexPages.currentPage().getParameters().get('index'));
        
        lineItems l = shoppingCartwithDW[integer.valueOf(apexPages.currentPage().getParameters().get('index'))-1];
        DW_Opportuinity_Product__c tempOP = new DW_Opportuinity_Product__c();
        tempOP.DW_PriceBook_Entry__c = l.dwOpptyProd.DW_PriceBook_Entry__c;
        tempOP.Name=l.dwOpptyProd.Name;
        tempOP.Quantity__c = l.dwOpptyProd.Quantity__c;
        tempOP.UnitPrice__c = l.dwOpptyProd.UnitPrice__c;
        //tempOP.DW_PriceBook_Entry__c = l.dwOpptyProd.DW_PriceBook_Entry__c;
        tempOP.Opportunity__c = theOpp.id;
        tempOP.Initial_Quantity__c = l.dwOpptyProd.Initial_Quantity__c;
        tempOP.DWProduct__c = l.dwOpptyProd.DWProduct__c;
        tempOp.Grade__c = l.dwOpptyProd.Grade__c;
        
        
        OpportunityLineItem tempOLI = new OpportunityLineItem();
        /*tempOLI.PriceBookEntryId = l.oli.PriceBookEntryId;
tempOLI.Quantity = l.oli.Quantity;
tempOLI.UnitPrice = l.oli.unitPrice; 
tempOLI.Product2Id = l.oli.Product2Id;
//tempOLI.PriceBookEntryId = l.oli.PriceBookEntryId; 
tempOLI.OppProductName__c = l.oli.PriceBookEntry.Product2.Name;
tempOLI.Initial_Quantity__c =l.oli.Initial_Quantity__c;
tempOLI.OpportunityId = theOpp.Id;
tempOLI.Grade__c = l.oli.Grade__c;*/
        
        lineItems li = new lineItems(null,tempOP,l.isDWline,tempOLI,l.isOpptyLine,l.rowId);//Id prodId, DW_Opportuinity_Product__c dwOP,Boolean dwLine,opportunityLineItem opptyLine,Boolean olitem,Integer rowId){
        shoppingCartwithDw.add(li);
        shoppingCartwithDw[shoppingCartwithDw.size()-1].rowId = shoppingCartwithDw.size();
        system.debug(shoppingCartwithDw.size());
        /*for(lineItems l : shoppingCartwithDW){
if(String.valueOf(l.rowId) == apexPages.currentPage().getParameters().get('index')){
lineItems li = new lineItems(null,l.dwOpptyProd,l.isDWline,l.oli,l.isOpptyLine,l.rowId);//Id prodId, DW_Opportuinity_Product__c dwOP,Boolean dwLine,opportunityLineItem opptyLine,Boolean olitem,Integer rowId){
shoppingCartwithDw.add(li);
shoppingCartwithDw[shoppingCartwithDw.size()-1].rowId = shoppingCartwithDw.size();
system.debug('@@shoppingCartwithDw'+shoppingCartwithDw[shoppingCartwithDw.size()-1]); 
break;
}
}*/
        //refreshTotals(); //to revive
    }
    public PageReference removeFromShoppingCart(){
        // This function runs when a user hits "remove" on an item in the "Selected Products" section
        Integer remove;
        for(lineItems l : shoppingCartwithDW){
            system.debug('@@@@@@@@@@@'+String.valueOf(l.rowId));
            system.debug('@@@@@@@@@@@11'+apexPages.currentPage().getParameters().get('index'));
            
            if(String.valueOf(l.rowId) == apexPages.currentPage().getParameters().get('index')){
                remove = shoppingCartwithDW.indexOf(l);//get Index of l to remove it
                if(l.isDWline){
                    if(l.dwOpptyProd.Id != null){
                        dwProdRemoveList.add(l.dwOpptyProd);
                    }
                }else if(l.isOpptyLine){
                    if(l.oli.Id != null){
                        opptyProdRemoveList.add(l.oli);
                    }
                }
                //add the line item to delete list // check Id of the record to confirm existence in DB
            }
        }
        shoppingCartwithDW.remove(remove);//remove the indexed item form the iteration above
        for(Integer i = remove; i < shoppingCartwithDW.size();i++){
            shoppingCartwithDW[i].rowId -=  1;
        }
        updateAvailableList();
        //refreshTotals();
        return null;
    }
    /*Public void refreshTotals()
{
Integer count =0;
OppTotals = 0;
System.debug(apexPages.currentPage().getParameters().get('index'));
for(OpportunityLineItem opl:  shoppingCart)
{
Map<String,Object> so =(Map<String, Object>) JSON.deserializeUntyped(JSON.serialize(opl)); 
System.debug(so.get('Discount'));
if(opl.TotalPrice__c== null || opl.TotalPrice__c==0)
opl.TotalPrice__c  =opl.TotalPrice;
if(so.get('UnitPrice') !=null && so.get('Quantity')!=null && so.get('Discount')!=null && opl.UnitPrice>=0 && opl.Quantity>=0 && so.get('Discount')!=null && opl.Discount>=0 && String.valueof(count)==apexPages.currentPage().getParameters().get('index'))
{
opl.TotalPrice__c = ((opl.UnitPrice-(opl.UnitPrice* ((opl.Discount)/100) ))*opl.Quantity).setScale(0);
opl.Discount=null;
//   opl.TotalPrice__c=opl.TotalPrice__c-opl.Discount;
}   
else if(so.get('UnitPrice')!=null && so.get('Quantity')!=null && opl.UnitPrice>=0 && opl.Quantity>=0 && so.get('Discount')==null&& String.valueof(count)==apexPages.currentPage().getParameters().get('index'))

{
opl.TotalPrice__c = (opl.UnitPrice*opl.Quantity).setScale(0);
}

if(so.get('UnitPrice')!=null && opl.UnitPrice>=0 && opl.TotalPrice__c!=null )    
OppTotals = OppTotals+opl.TotalPrice__c;    

count++;
}
OppTotals.setScale(2);
System.debug(OppTotals);
} 
public void TotalPriceChange()
{
List<opportunityLineItem> sc = shoppingCart;
Integer count = 0;
for(opportunityLineItem d : shoppingCart){
if(String.valueof(count)==apexPages.currentPage().getParameters().get('index')){
d.Quantity =d.Quantity==null?1:d.Quantity;

System.debug(d.UnitPrice +''+d.TotalPrice+''+d.Quantity);
d.Discount= (math.abs((d.UnitPrice- (d.TotalPrice__c/d.Quantity))/(d.UnitPrice))*100).setScale(2);
// d.Discount= d.UnitPrice*d.Quantity;
}
count++;
}
refreshTotals();
}*/
    Public Void savelogic(){
        system.debug('the save logic');
        try{
            // If previously selected products are now removed, we need to delete them
            if(dwProdRemoveList.size()>0){
                database.delete(dwProdRemoveList);
            }
            if(opptyProdRemoveList.size()>0){
                database.delete(opptyProdRemoveList);
            }
            system.debug('the delet lists '+dwProdRemoveList);
            system.debug('the delet lists '+opptyProdRemoveList);
            // Previously selected products may have new quantities and amounts, and we may have new products listed, so we use upsert here
            if(shoppingCartwithDW.size()>0){
                List<DW_Opportuinity_Product__c> dwOpptyList = new List<DW_Opportuinity_Product__c>();
                List<OpportunityLineItem> opptyProductList = new List<OpportunityLineItem>();
                for(lineItems li : shoppingCartwithDW){//Opportunity Product, DW product
                    if(li.isDWline){
                        System.debug('the dwOppty before '+li.dwOpptyProd);
                        if(li.dwOpptyProd.Initial_Quantity__c != null){
                            System.debug('the dwOppty after '+li.dwOpptyProd);
                            li.dwOpptyProd.TotalPrice__c = li.dwOpptyProd.UnitPrice__c * li.dwOpptyProd.Quantity__c;
                            li.dwOpptyProd.Sub_Total__c = li.dwOpptyProd.UnitPrice__c * li.dwOpptyProd.Quantity__c;
                            dwOpptyList.add(li.dwOpptyProd);
                        }
                    }
                    /*else if(li.isOpptyLine){
OpportunityLineItem oli = li.oli;
if(li.oli.Initial_Quantity__c != null){
if(li.oli.Initial_Quantity__c == li.oli.Quantity){
li.oli.Renewed_Qty__c =li.oli.Quantity;
li.oli.Delta__c =0;
// oli.Quantity = renQty;
li.oli.Upsell__c =  null;
li.oli.Downsell__c = null;
li.oli.Renewal__c = li.oli.Initial_Quantity__c;
}else if(li.oli.Initial_Quantity__c < li.oli.Quantity){
li.oli.Renewed_Qty__c = li.oli.Quantity;
li.oli.Delta__c = li.oli.Quantity - li.oli.Initial_Quantity__c;
// oli.Quantity = renQty;
li.oli.Upsell__c =  li.oli.Delta__c;
li.oli.Downsell__c = null;
li.oli.Renewal__c = li.oli.Initial_Quantity__c;
}else{
li.oli.Renewed_Qty__c = li.oli.Quantity;
li.oli.Delta__c =  li.oli.Initial_Quantity__c - li.oli.Renewed_Qty__c;
//oli.Quantity = renQty;
li.oli.Downsell__c = li.oli.Delta__c;
li.oli.Upsell__c = null;
li.oli.Renewal__c = li.oli.Quantity;
}
opptyProductList.add(li.oli); 
}
}*/
                }
                system.debug('the Oppty lIst '+opptyProductList);
                system.debug('the DW Oppty lIst '+dwOpptyList);
                if(dwOpptyList.size()>0){
                    Database.upsert(dwOpptyList);
                }
                if(opptyProductList.size()>0){
                    Database.upsert(opptyProductList);
                }
            }
        }
        catch(Exception e){
            ApexPages.addMessages(e);
        }
    }
    public PageReference onSave(){
        savelogic();
        // After save return the user to the Opportunity
        return new PageReference('/' + ApexPages.currentPage().getParameters().get('Id'));
    }
    
    public PageReference onCancel(){
        // If user hits cancel we commit no changes and return them to the Opportunity
        return new PageReference('/' + ApexPages.currentPage().getParameters().get('Id'));
    }
    
    /* logic change  public PageReference changePricebook(){

// This simply returns a PageReference to the standard Pricebook selection screen
// Note that is uses retURL parameter to make sure the user is sent back after they choose

//PageReference ref = new PageReference('/oppitm/choosepricebook.jsp');
PageReference ref = new PageReference('/apex/ChangePriceBookVF');
ref.getParameters().put('id',theOpp.Id);
ref.getParameters().put('retURL','/apex/opportunityProductEntry?id=' + theOpp.Id);
return ref;
}*/
    public PageReference onSaveAddQuotes(){
        savelogic();
        system.debug(theOpp.id);
        PageReference ref = new PageReference('/apex/AddDWQuoteVFPage?att='+theOpp.id);
        ref.setRedirect(true);
        return ref;
    }
    public void quantityChangeOnOpptyProd(){
        /*
system.debug(shoppingCartwithDW[selectedRow-1]);
lineItems li =shoppingCartwithDW[selectedRow-1];
system.debug(selectedRow-1);        
if(li.isOpptyLine){
li.subTotal = li.oli.UnitPrice*li.oli.Quantity;
}
*/
        for(lineItems li : shoppingCartwithDW){           
            system.debug('@@rowId '+li.rowId);
            system.debug('@@UnitPrice '+li.oli.UnitPrice+'@@quant'+li.oli.Quantity);
            
            if(li.isOpptyLine){
                li.subTotal = li.oli.UnitPrice*li.oli.Quantity;
            }
        }
    }
    public void unitChangeOnOpptyProd(){
    for(lineItems li : shoppingCartwithDW){           
            system.debug('@@rowId '+li.rowId);
            system.debug('@@UnitPrice '+li.oli.UnitPrice+'@@quant'+li.oli.Quantity);
            
            if(li.isOpptyLine){
                li.subTotal = li.oli.UnitPrice*li.oli.Quantity;
            }
        }
    }
    public void quantityChange(){
        
        DWProductPrices__c dwProductPrice = new DWProductPrices__c();
        Decimal unitPrice=0;
        DWProductPrices__c[] dwProductPrices = [SELECT Id,PRODUCT_REF__c,LIMIT_1__c,LIMIT_2__c,LIMIT_3__c,LIMIT_4__c,LIMIT_5__c,PRICE_1__c,
                                                PRICE_2__c,PRICE_3__c,PRICE_4__c,PRICE_5__c,START_DATE_NEW__c,END_DATE_NEW__c 
                                                FROM DWProductPrices__c 
                                                WHERE PRODUCT_REF__c =: productId AND isActive__c = true ORDER BY Createddate DESC  LIMIT 1];//AND 
        //(Start__c <= :date.today() AND END__c >= :date.today())];
        System.debug('dwProductPrices'+dwProductPrices);
        try{                                               
            for(DWProductPrices__c dwpp : dwProductPrices){
                System.debug('Start Date '+Date.valueOf(dwpp.START_DATE_NEW__c));
                System.debug('End Date '+Date.valueOf(dwpp.END_DATE_NEW__c));
                //if((Date.valueOf(dwpp.START_DATE_NEW__c)<= Date.today()) && (Date.today() <= Date.valueOf(dwpp.END_DATE_NEW__c))){
                dwProductPrice = dwpp;
                //}
            }
            if(dwProductPrice != null){
                //dwProductPrice=dwProductPrices[0];
                Decimal quantity = 1;
                if(ApexPages.currentPage().getParameters().get('index') != null){
                    quantity = shoppingCartwithDW[Integer.valueOf(ApexPages.currentPage().getParameters().get('index'))-1].dwOpptyProd.Quantity__c;
                    quantity = quantity.round(System.RoundingMode.DOWN);
                }
                if(quantity <= dwProductPrice.LIMIT_1__c){
                    unitPrice = dwProductPrice.PRICE_1__c;
                }else if(quantity <= dwProductPrice.LIMIT_2__c){
                    unitPrice = dwProductPrice.PRICE_2__c;
                }
                else if(quantity <= dwProductPrice.LIMIT_3__c){
                    unitPrice = dwProductPrice.PRICE_3__c;
                }
                else if(quantity <= dwProductPrice.LIMIT_4__c){
                    unitPrice = dwProductPrice.PRICE_4__c;
                }
                else if(quantity <= dwProductPrice.LIMIT_5__c){
                    unitPrice = dwProductPrice.PRICE_5__c;
                }
            }
            Integer changedRow = 0;
            if(ApexPages.currentPage().getParameters().get('index') != null){
                changedRow = Integer.valueOf(ApexPages.currentPage().getParameters().get('index'));
            }
            for(lineItems li : shoppingCartwithDW){
                if(li.isDWline){
                    if(li.dwOpptyProd.DWProduct__c == productId && li.rowId == changedRow){
                        system.debug('item product id '+li.dwOpptyProd.DWProduct__c+' row ID '+li.rowId);
                        li.dwOpptyProd.UnitPrice__c = unitPrice;
                        li.subTotal = li.dwOpptyProd.UnitPrice__c*li.dwOpptyProd.Quantity__c;
                    }
                }
            }
            system.debug('the price calculated '+unitPrice);
        }
        catch(Exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,+e.getMessage()));
            //return null;
        }
    }
    public class products implements Comparable{
        public String id {get; set;}
        public PriceBookEntry pbe {get; set;}
        public DW_PriceBook_Entry__c dwPBE {get; set;}
        public Boolean isPBE {get; set;}
        public Boolean isDWpbe {get; set;}
        public String productObjectType {get; set;}
        public products(String idParam, PriceBookEntry pbe,Boolean isPBE,DW_PriceBook_Entry__c dwPBE,Boolean isDWpbe){
            this.id = idParam;
            this.pbe = pbe;
            this.dwPBE = dwPBE;
            this.isPBE = isPBE;
            this.isDWpbe = isDWpbe;
            this.productObjectType = isPBE?'Product':'DW Product';
        }
        public Integer compareTo(Object compareToObj){
            return Id.CompareTo(((products)compareToObj).Id);
        }
    }
    public class lineItems{
        //public ID productId {get; set;}//either Product or DW Product should be populated here
        public Integer rowId {get; set;}
        public opportunityLineItem oli {get; set;}
        public DW_Opportuinity_Product__c dwOpptyProd {get; set;}
        public Decimal subTotal {get; set;}
        public Boolean isOpptyLine {get; set;}
        public Boolean isDWline {get; set;}
        //public String oppProductName{get; set;}
        
        public lineItems(Id prodId, DW_Opportuinity_Product__c dwOP,Boolean dwLine,opportunityLineItem opptyLine,Boolean olitem,Integer rowId){
            this.rowId = rowId;
            //this.productId = prodId;
            this.oli = opptyLine;
            //this.oppProductName = opptyLine.PricebookEntry.Product2.Name;
            this.dwOpptyProd = dwOP;
            this.isOpptyLine = olitem;
            this.isDWline = dwLine;
            // this.subTotal = isOpptyLine?(opptyLine.UnitPrice*opptyLine.Quantity):(dwOP.UnitPrice__c*dwOP.Quantity__c);
            this.subTotal = dwOP.UnitPrice__c*dwOP.Quantity__c;
            
        }
        
      /*  Public void selectcon()
{
String selcontactid = System.currentPagereference().getParameters().get('conid');

}*/
    }
}