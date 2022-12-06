public class ShipToAffAdressHandler {
    
    public static void afterHandle(List<Ship_To_Affiliation__c> afterList)
    {
        set<ID> accid=new set<ID>();
        for(Ship_To_Affiliation__c sf1:afterList)
        {
            accid.add(sf1.Account__c);
        }
        list<DWCustomer__c> dwcustomerlist= new list<DWCustomer__c>();
        
        list<account> lstacc=[select id,Total_Previous_Year_Sales__c,YTD_Sale_Difference__c,name,Sales_in_Current_YearC__c,Sales_from_Last_YearC__c,Total_All_Time_SalesC__c from account where ID IN:accid];
        list<Ship_To_Affiliation__c> shplst=[select id,Total_Previous_Year_Sales__c,YTD_Sale_Difference__c,Account__c,Ship_To_Code__c,Total_Sales__c,Sales_in_Last_Year__c,Sales_in_Current_Year__c from Ship_To_Affiliation__c where Account__c IN :accid];
        
        if(checkRecursive.runOnce())
        { 
            list<DWCustomer__c> custlist2=[select id,SHIPTO_NETSALES_PYTD__c,SHIPTO_NETSALES_CYTD__c,Ship_To_Affiliation__c,SHIPTO_CUSTOMER__c,CUSTOMER_ADDRESS_4__c,CUSTOMER_ADDRESS_5__c,CUSTOMER_COUNTRY_CODE__c,CUSTOMER_POSTAL_CODE__c,CUSTOMER_ADDRESS_3__c,CUSTOMER_ADDRESS_2__c,CUSTOMER_ADDRESS_1__c,CUSTOMER_STATE__c,SALES_PERSON__c,CUSTOMER_STATE_CODE__c,CUSTOMER_COUNTRY__c,Account_Name__c,Parent_Account__c,CUSTOMER_CORPORATION_CODE__c,SHIPTO_CUSTOMER_CODE__c,SOLDTO_CUSTOMER_CODE__c from DWCustomer__c where Ship_To_Affiliation__c=null];
            system.debug('added here top');
            for(Ship_To_Affiliation__c saff:afterList)
            {
                for(DWCustomer__c dwc:custlist2)
                {
                    if(dwc.SHIPTO_CUSTOMER_CODE__c==saff.Ship_To_Code__c)
                    {
                        dwc.Ship_To_Affiliation__c=saff.id;
                        dwc.Account_Name__c=saff.Account__c;
                        dwc.Parent_Account__c=saff.Account__r.ParentId;
                        dwcustomerlist.add(dwc); 
                    }
                }
                
            }
            update dwcustomerlist;
        }
        
        for(Account acn:lstacc)
        {
            Decimal d=0;
            Decimal d1=0;
            Decimal d2=0;
            Decimal d3=0;
            Decimal d4=0;
            for(Ship_To_Affiliation__c shp:shplst)
            {
                if(shp.Sales_in_Current_Year__c!=null)
                {
                    d=d+shp.Sales_in_Current_Year__c;                  
                }
                if(shp.Sales_in_Last_Year__c!=null)
                {
                    d1=d1+shp.Sales_in_Last_Year__c;                   
                }
                if(shp.Total_Sales__c!=null)
                {
                    d2=d2+shp.Total_Sales__c;               
                }
                if(shp.YTD_Sale_Difference__c!=null)
                {
                    d3=d3+shp.YTD_Sale_Difference__c;              
                }
                if(shp.Total_Previous_Year_Sales__c!=null)
                {
                    d4=d4+shp.Total_Previous_Year_Sales__c;         
                }
                
            }
            acn.Sales_in_Current_YearC__c=d;
            acn.Sales_from_Last_YearC__c=d1;
            acn.Total_All_Time_SalesC__c=d2;
            acn.YTD_Sale_Difference__c=d3;
            acn.Total_Previous_Year_Sales__c=d4;
            
        }
        update lstacc;
    } 
    
    
}