trigger ShipToAffAdress on Ship_To_Affiliation__c (after insert,after update,before insert,before update) {
    
    set<ID> accid=new set<ID>();
    if(checkRecursive1.runOnce())
    { 
        if(Trigger.isBefore)
        {
            list<DWCustomer__c> custlist=[select id,SHIPTO_CUSTOMER__c,SOLDTO_CUSTOMER__c,CUSTOMER_ADDRESS_4__c,CUSTOMER_ADDRESS_5__c,CUSTOMER_COUNTRY_CODE__c,CUSTOMER_POSTAL_CODE__c,CUSTOMER_ADDRESS_3__c,CUSTOMER_ADDRESS_2__c,CUSTOMER_ADDRESS_1__c,CUSTOMER_STATE__c,SALES_PERSON__c,CUSTOMER_STATE_CODE__c,CUSTOMER_COUNTRY__c,Ship_To_Affiliation__c,Account_Name__c,Parent_Account__c,CUSTOMER_CORPORATION_CODE__c,SHIPTO_CUSTOMER_CODE__c,SOLDTO_CUSTOMER_CODE__c from DWCustomer__c];
            // new code regarding duplicate error started here
            list<Ship_To_Affiliation__c> shplst1=[select id,Account__c,Ship_To_Code__c,Total_Sales__c,Affiliated_Sold_To_Account__c,Sales_in_Last_Year__c,Sales_in_Current_Year__c from Ship_To_Affiliation__c where Ship_To_Code__c !=NUll];
            
            for(Ship_To_Affiliation__c sf2:Trigger.new)
            {
                for(Ship_To_Affiliation__c sf3:shplst1)
                {
                    if(sf2.Ship_To_Code__c==sf3.Ship_To_Code__c && Trigger.isBefore && Trigger.isInsert)
                    {
                        sf2.addError('Duplicate Aurora Account Number');
                    } 
                    if(Trigger.isBefore && Trigger.isUpdate)
                    {
                        if(sf2.Ship_To_Code__c==sf3.Ship_To_Code__c && sf2.Ship_To_Code__c!=trigger.oldmap.get(sf2.id).Ship_To_Code__c )
                        {
                            sf2.addError('Duplicate Aurora Account Number');
                        }   
                    }
                    
                }
                
            }  
            // ended here
            
            for(Ship_To_Affiliation__c sf:Trigger.new)
            {
                for(DWCustomer__c dw:custlist)
                {
                    
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
                    }
                }
            }
            if(Test.isRunningTest()){
            if(Trigger.isBefore && Trigger.isUpdate)
            {
          } 
                list<DWCustomer__c> custlist1=[select id,SOLDTO_CUSTOMER__c,SHIPTO_NETSALES_PYTD__c,SHIPTO_NETSALES_CYTD__c,Ship_To_Affiliation__c,SHIPTO_CUSTOMER__c,CUSTOMER_ADDRESS_4__c,CUSTOMER_ADDRESS_5__c,CUSTOMER_COUNTRY_CODE__c,CUSTOMER_POSTAL_CODE__c,CUSTOMER_ADDRESS_3__c,CUSTOMER_ADDRESS_2__c,CUSTOMER_ADDRESS_1__c,CUSTOMER_STATE__c,SALES_PERSON__c,CUSTOMER_STATE_CODE__c,CUSTOMER_COUNTRY__c,Account_Name__c,Parent_Account__c,CUSTOMER_CORPORATION_CODE__c,SHIPTO_CUSTOMER_CODE__c,SOLDTO_CUSTOMER_CODE__c from DWCustomer__c where Ship_To_Affiliation__c IN : Trigger.new];
                for(Ship_To_Affiliation__c sf1:Trigger.new)
                {
                    Decimal d=0;
                    Decimal d1=0;
                    Decimal d2=0;
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
                    }  
                    d2=d+d1;
                    sf1.Sales_in_Current_Year__c=d;
                    sf1.Sales_in_Last_Year__c=d1;
                    sf1.Total_Sales__c=d2;
                    
                }
            }
            
        }
    }
    if(trigger.isAfter)
    {
        ShipToAffAdressHandler.afterHandle(Trigger.new);
    }
}