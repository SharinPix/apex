({
    getAllTags : function(component, callback) {
        var action = component.get("c.getAllTags");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
                callback(response.getReturnValue());
            } else if (component.isValid() && state === "ERROR") {
                var errors = response.getError();
                this.showToast('Error', 'See console for details');
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
    },
    showToast : function(title, message) {
        var toastEvent = $A.get("e.force:showToast");
        if (toastEvent) {
            toastEvent.setParams({
                "title": title,
                "message": message
            });
            toastEvent.fire();
        } else {
            // fallback if within VF mode
            alert(title + ': ' + message);
        }
    }
})