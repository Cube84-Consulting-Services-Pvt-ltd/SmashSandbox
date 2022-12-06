({
    myAction : function(component, event, helper) {
        
    },
    doInit : function(component, event, helper) {
        var value = helper.getParameterByName(component , event, 'inContextOfRef');
        var context = JSON.parse(window.atob(value));
        var recordId = context.attributes.recordId;
        //alert(context.attributes.recordId)
        
        var action = component.get('c.getContactInfo'); 
        // method name i.e. getEntity should be same as defined in apex class
        // params name i.e. entityType should be same as defined in getEntity method
        
        action.setParams({
            "recordId" : recordId
        });
        action.setCallback(this, function(a){
            
            var state = a.getState(); // get the response state
            if(state == 'SUCCESS') {
                var result = a.getReturnValue();
                var objectname = result['ObjectName'];
                for(var key in result['Ids']) {
                    if(objectname == 'Account') {
                        component.set('v.AccountId',key);
                    }
                }
            }
        });
        $A.enqueueAction(action);
    },
    accountchanges : function(component,event,helper){
        var AccountIdVal = component.get("v.AccountId");
        
      
        if(AccountIdVal != null) {
            var action = component.get('c.accountInfo'); 
            
            action.setParams({
                accountId : component.get("v.AccountId")
            });
            action.setCallback(this, function(response){
                var state = response.getState(); // get the response state
                if(state === 'SUCCESS') {
                    console.log( 'state ' + state);
                    var result = response.getReturnValue();
                    console.log( 'result ' + result);
                   
                }
            });
            $A.enqueueAction(action);
        }
        
    },
    onCancel : function(component, event) {
        
        var homeEvt = $A.get("e.force:navigateToObjectHome");
        homeEvt.setParams({
            "scope": "Ship_To_Affiliation__c"
        });
        homeEvt.fire();
        
    },
    handleSuccess : function(component, event, helper) {
        var payload = event.getParams().response;
        var navService = component.find("navService");
        
        var pageReference = {
            type: 'standard__recordPage',
            attributes: {
                "recordId": payload.id,
                "objectApiName": "Ship_To_Affiliation__c",
                "actionName": "view"
            }
        }
        event.preventDefault();
        navService.navigate(pageReference);  
    },
    
    handleAccountChange : function(component, event, helper) {
        var action = component.get("c.getAccountInfo"); 
        action.setParams({
            "soldcode" : component.get("v.soldcode")
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state === 'SUCCESS') {
                var result = response.getReturnValue();
                component.set('v.AffiliateACCName',result);
                console.log('soldcode: ' + result);
            }
            else if(state == "ERROR"){
                var errors = response.getError();
                //alert(errors[0].message)
            }
        });
        $A.enqueueAction(action);
    }
})