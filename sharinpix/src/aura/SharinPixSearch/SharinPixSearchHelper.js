({
    toggleLexSpinner : function(cmp, spinnerId, value) {
        var spinner = cmp.find(spinnerId);
        value = (value != null) ? value : !$A.util.hasClass(spinner, 'slds-hide');
        if (value) {
            $A.util.removeClass(spinner, "slds-hide");
        } else {
            $A.util.addClass(spinner, "slds-hide");
        }
    },
    getSearchUrls : function(cmp, params, callback) {
        var action = cmp.get("c.generateSearchUrls");
        action.setParams(params);
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (cmp.isValid() && state === "SUCCESS") {
                callback(response.getReturnValue());
            } else if (cmp.isValid() && state === "ERROR") {
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
    startSearch : function(cmp) {
        var reportId = cmp.get('v.reportId');
        if ($A.util.isEmpty(reportId)) {
            this.showToast('Error', 'No search parameter provided.');
            return;
        }
        var reportParameters = cmp.get('v.reportParameters');
        if (!$A.util.isEmpty(reportParameters)) {
            reportParameters = JSON.parse(reportParameters);
        }
        var selectedTags = cmp.get('v.selectedTags');
        if (!$A.util.isEmpty(selectedTags)) {
            selectedTags = JSON.parse(selectedTags);
        }
        var tagOperator = cmp.get('v.tagOperator');
        var pageSize = cmp.get('v.pageSize');
        var params = {
            reportId: reportId,
            reportParameters: reportParameters,
            tagOperator: tagOperator,
            selectedTags: selectedTags,
            pageSize: pageSize
        };
        console.log('params', params);
        var that = this;
        this.getSearchUrls(cmp, params, $A.getCallback(function(searchUrls) {
            console.log('searchUrls', searchUrls);
            cmp.set('v.searchUrls', searchUrls);
            if (searchUrls.length > 0) {
                cmp.set('v.showResultsPanel', true);
                cmp.find('queryResults') && cmp.find('queryResults').init();
            } else {
                cmp.set('v.showResultsPanel', false);
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