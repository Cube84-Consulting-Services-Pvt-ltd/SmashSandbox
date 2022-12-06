public class DWCustomerShiptoAffHandler {
    
    public static void BeforeHandler(list<DWCustomer__c> BeforeList)
    {
        set<ID> accnid= new set<id>();
        Integer count;
        list<Ship_To_Affiliation__c> afflist= new list<Ship_To_Affiliation__c>();
        
        list<Ship_To_Affiliation__c> shiptoaff=[SELECT Id,Affiliated_Account_Name__c,Affiliated_Sold_To_Account__c,Sales_Person__c,Zip_Postal_Code__c,Address_1__c,Address_2__c,Address_3__c,Total_Sales__c,Sales_in_Last_Year__c,Sales_in_Current_Year__c,City__c, Name,State_Province__c,Country__c, Account__c,Account__r.ParentId ,Ship_To_Code__c, Sold_To_Code__c, Aurora_Location__c FROM Ship_To_Affiliation__c where Ship_To_Code__c!=null ];
        
        for(DWCustomer__c dw:BeforeList)
        {
            for(Ship_To_Affiliation__c sf:shiptoaff)
            {
                if(dw.SHIPTO_CUSTOMER_CODE__c==sf.Ship_To_Code__c)
                {
                    dw.Ship_To_Affiliation__c=sf.id;
                    dw.Account_Name__c=sf.Account__c;
                    dw.Parent_Account__c=sf.Account__r.ParentId;
                }
                if(dw.SHIPTO_CUSTOMER_CODE__c==sf.Ship_To_Code__c)
                {
                    sf.Address_1__c=dw.CUSTOMER_ADDRESS_1__c;
                    sf.Address_2__c=dw.CUSTOMER_ADDRESS_2__c;
                    sf.Address_3__c=dw.CUSTOMER_ADDRESS_3__c;
                    sf.City__c=dw.CUSTOMER_ADDRESS_4__c;
                    sf.State_Province__c=dw.CUSTOMER_ADDRESS_5__c;
                    sf.Zip_Postal_Code__c=dw.CUSTOMER_POSTAL_CODE__c;
                    sf.Country__c=dw.CUSTOMER_COUNTRY_CODE__c;
                    sf.Sales_Person__c=dw.SALES_PERSON__c;
                    sf.Affiliated_Account_Name__c=dw.SHIPTO_CUSTOMER__c;
                    sf.Affiliated_Sold_To_Account__c=dw.SOLDTO_CUSTOMER__c;
                    afflist.add(sf);
                }
                
            }
            
        }
        
        update afflist;
    }
    public static void AfterHandler(list<DWCustomer__c> AfterList)
    {
        set<ID> accnid= new set<id>();
        Integer count;
        if(checkRecursive3.runOnce()){
            
        list<Ship_To_Affiliation__c> afflist= new list<Ship_To_Affiliation__c>();
        for(DWCustomer__c dw:AfterList)
        {
            accnid.add(dw.Ship_To_Affiliation__c);
        }
        list<Ship_To_Affiliation__c> shiptoaff1=[SELECT Id,Total_Sales__c,Total_Previous_Year_Sales__c,YTD_Sale_Difference__c,DWCustomer_Record__c,Sales_in_Last_Year__c,Sales_in_Current_Year__c,City__c FROM Ship_To_Affiliation__c where ID IN:accnid];
        list<DWCustomer__c> custlist1=[select id,SHIPTO_NETSALES_PY__c,SHIPTO_NETSALES_PYTD__c,SHIPTO_NETSALES_DIFF_YTD__c,SHIPTO_NETSALES_CYTD__c,Ship_To_Affiliation__c from DWCustomer__c where Ship_To_Affiliation__c IN : accnid];
        
        for(Ship_To_Affiliation__c sh:shiptoaff1)
        {
            for(DWCustomer__c dc:custlist1)
            {
                // to update record id in aff account 
                sh.DWCustomer_Record__c=dc.id;
                // end....
                
                Decimal d=0;
                Decimal d1=0;
                Decimal d2=0;
                Decimal d3=0;
                Decimal d4=0;
                for(DWCustomer__c dw1:custlist1)
                {
                    if(dw1.SHIPTO_NETSALES_CYTD__c!=null)
                    {
                        d=d+dw1.SHIPTO_NETSALES_CYTD__c;  
                    }
                    if(dw1.SHIPTO_NETSALES_PYTD__c!=null)
                    {
                        d1=d1+dw1.SHIPTO_NETSALES_PYTD__c;
                    }
                    if(dw1.SHIPTO_NETSALES_DIFF_YTD__c!=null)
                    {
                        d3=d3+dw1.SHIPTO_NETSALES_DIFF_YTD__c;
                    }
                    if(dw1.SHIPTO_NETSALES_PY__c!=null)
                    {
                        d4=d4+dw1.SHIPTO_NETSALES_PY__c;
                    }
                    
                    d2=d+d1;
                }
                sh.Sales_in_Current_Year__c=d;
                sh.Sales_in_Last_Year__c=d1;
                sh.Total_Sales__c=d2;
                sh.YTD_Sale_Difference__c=d3;
                sh.Total_Previous_Year_Sales__c=d4;
            }
        }
        
        update shiptoaff1; 
        
    }
}
}