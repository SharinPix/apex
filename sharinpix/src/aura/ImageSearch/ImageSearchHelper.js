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
    getAlbumIds : function(component, reportId, reportParameters, callback) {
        if (!$A.util.isEmpty(reportId)) {
            var action = component.get("c.getAlbumIdsFromReport");
            action.setParams({ reportId: reportId, reportParameters: reportParameters });
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
        }
    },
    startSearch : function(component) {
        var tagOptions = {};
        //component.set('v.currentPage', 0);
        var reportId = component.get('v.reportId');
        if ($A.util.isEmpty(reportId)) {
            this.showToast('Error', 'No search parameter provided.');
            return;
        }
        var reportParameters = component.get('v.reportParameters');
        if (!$A.util.isEmpty(reportParameters)) {
            reportParameters = reportParameters.split('\n');
        }
        var selectedTags = component.get('v.selectedTags') || '';
        if (!$A.util.isEmpty(selectedTags)) {
            selectedTags = selectedTags.split(';');
            tagOptions['selectedTags'] = selectedTags;
        }
        var tagOperator = component.get('v.tagOperator');
        tagOptions['tagOperator'] = tagOperator;
        component.set('v.tagOptions', tagOptions);
        var that = this;
        this.getAlbumIds(component, reportId, reportParameters, $A.getCallback(function(albumIds) {
            //console.log('albumIds IS2C', albumIds);
            component.set('v.albumIds', albumIds);
            component.set('v.showResultsPanel', true);
            //var pageSize = component.get('v.pageSize') == 0 ? albumIds.length : component.get('v.pageSize');
            //component.set('v.totalPages', Math.ceil(albumIds.length / pageSize));
            //component.set('v.currentPage', 1);
            component.find('queryResults') && component.find('queryResults').init();
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