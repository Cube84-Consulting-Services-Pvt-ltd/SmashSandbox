trigger DWCustomerShiptoAff on DWCustomer__c (after insert,after update,before insert,before update) {
    
     if(Trigger.isBefore)
    {
        DWCustomerShiptoAffHandler.BeforeHandler(Trigger.new);
    }
    if(Trigger.isAfter)
    {
         DWCustomerShiptoAffHandler.AfterHandler(Trigger.new);
    }
}