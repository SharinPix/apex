({
    add : function(component, event, helper) {
        $A.createComponent(
            "ui:inputText",
            {
                "aura:id": "txtInput",
                "class": "slds-input",
                "value": "",
                "blur": component.getReference("c.updateValues")
            },
            function(newText, status, errorMessage) {
                var placeholder = component.get('v.placeholder');
                var appendToPlaceholder = component.get('v.appendToPlaceholder');
                if (!$A.util.isEmpty(appendToPlaceholder)) {
                    var placeholderCount = component.get('v.placeholderCount');
                    placeholder += appendToPlaceholder + placeholderCount++;
                    component.set('v.placeholderCount', placeholderCount);
                }
                newText.set('v.placeholder', placeholder);
                if (status === "SUCCESS") {
                    var body = component.get("v.body");
                    body.push(newText);
                    component.set("v.body", body);
                }
                else if (status === "INCOMPLETE") {
                    console.log("No response from server or client is offline.")
                }
                else if (status === "ERROR") {
                    console.log("Error: " + errorMessage);
                }
            }
        );
    },
    removeLast : function(component, event, helper) {
        var body = component.get("v.body");
        if ($A.util.isEmpty(body)) return;
        body.pop();
        component.set("v.body", body);
        var placeholderCount = component.get('v.placeholderCount');
        if (placeholderCount > 0) {
            placeholderCount--;
            component.set('v.placeholderCount', placeholderCount);
        }
    },
    updateValues : function(component, event, helper) {
        var values = [];
        var body = component.get("v.body");
        for (var i = 0; i < body.length; i++) {
            values.push(body[i].get('v.value'));
        }
        component.set('v.value', JSON.stringify(values));
    },
    reset : function(component, event, helper) {
        component.set('v.value', '[]');
        component.set('v.body', []);
    }
})