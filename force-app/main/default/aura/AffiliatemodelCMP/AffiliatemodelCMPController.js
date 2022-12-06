({
    doInit: function(component) {
        var strAccId = component.get("v.recordId");
        console.log('Opportunity Id ====>'+strAccId);
        $A.createComponent("c:ShipToAffiliation", 
                           {strRecordId : strAccId},
                           function(result, status) {
                               if (status === "SUCCESS") {
                                   component.find('overlayLibDemo').showCustomModal({
                                       header: "New Affiliation",
                                       body: result, 
                                       showCloseButton: true,
                                       cssClass: "mymodal", 
                                   })
                               }                               
                           });
      
    },
    
})