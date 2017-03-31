({
    toggleLexSpinner : function(component, spinnerId, value) {
        var spinner = component.find(spinnerId);
        value = (value != null) ? value : !$A.util.hasClass(spinner, 'slds-hide');
        if (value) {
            $A.util.removeClass(spinner, "slds-hide");
        } else {
            $A.util.addClass(spinner, "slds-hide");
        }
    },
    getSearchUrls : function(component, params, callback) {
        var action = component.get("c.generateSearchUrls");
        action.setParams(params);
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
    startSearch : function(component) {
        var reportId = component.get('v.reportId');
        if ($A.util.isEmpty(reportId)) {
            this.showToast('Error', 'No search parameter provided.');
            return;
        }
        var reportParameters = component.get('v.reportParameters');
        if (!$A.util.isEmpty(reportParameters)) {
            reportParameters = JSON.parse(reportParameters);
        }
        var selectedTags = component.get('v.selectedTags');
        if (!$A.util.isEmpty(selectedTags)) {
            selectedTags = selectedTags.split(';');
        } else {
            selectedTags = [];
        }
        var tagOperator = component.get('v.tagOperator');
        var pageSize = component.get('v.pageSize');
        var params = {
            reportId: reportId,
            reportParameters: reportParameters,
            tagOperator: tagOperator,
            selectedTags: selectedTags,
            pageSize: pageSize
        };
        console.log('params', params);
        var that = this;
        this.getSearchUrls(component, params, $A.getCallback(function(searchUrls) {
            console.log('searchUrls', searchUrls);
            component.set('v.searchUrls', searchUrls);
            if (searchUrls.length > 0) {
                component.set('v.showResultsPanel', true);
                component.find('queryResults') && component.find('queryResults').init();
            } else {
                component.set('v.showResultsPanel', false);
                that.showToast('No Results', 'No records found with provided search query.');
            }
        }));
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