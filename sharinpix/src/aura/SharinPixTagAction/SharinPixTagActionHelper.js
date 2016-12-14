({
	execCommand: function(recordId, payload, component,event) {
		console.log('recordId: ', recordId);
		console.log('payload: ', payload);
		var action = component.get("c.executeCommandLightning");
        action.setParams({"recordId": recordId,
                          "jsonfile": payload});
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state === "SUCCESS"){
                // $A.get("e.force:refreshView").fire();
            }    
        });
        $A.enqueueAction(action);
	}
})