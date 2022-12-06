({
	
    doInit : function(component, event, helper) {
  	var action = component.get("c.getDownloadIndictor"); 
    var artId = component.get("v.recordId");
	action.setParams({
        "artId":artId
    });
         
        action.setCallback(this, function(response) {
         var state = response.getState();
            if(state === "SUCCESS"){
               if(response.getReturnValue()){
             
                }  
                
        else{
             var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title : '',
            message: 'Download in Progress Please wait ....',
            duration:' 10000',
            key: 'info_alt',
            type: 'success',
            mode: 'pester'
        });
        toastEvent.fire();  
            }   
            }
        });
        $A.enqueueAction(action);     
        }
            
 
})