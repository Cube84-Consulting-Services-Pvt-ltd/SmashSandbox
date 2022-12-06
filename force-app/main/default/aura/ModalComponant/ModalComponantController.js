({
    doInit: function(component) {
        var strAccId = component.get("v.recordId");
        console.log('Opportunity Id ====>'+strAccId);
        $A.createComponent("c:OpportunityWithProduct", 
                           {strRecordId : strAccId},
                           function(result, status) {
                               if (status === "SUCCESS") {
                                   component.find('overlayLibDemo').showCustomModal({
                                       header: "New Opportunity: New Business Opportunity",
                                       body: result, 
                                       showCloseButton: true,
                                       cssClass: "mymodal", 
                                   })
                               }                               
                           });
      
    }
})