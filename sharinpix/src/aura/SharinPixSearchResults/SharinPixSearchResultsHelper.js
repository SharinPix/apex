({
    startSearch : function(cmp) {
        this.reset(cmp);
        var reportId = cmp.get('v.reportId');
        if ($A.util.isEmpty(reportId) || (reportId.length != 15 && reportId.length != 18)) return;

        var params = this.extractParams(cmp);

        var that = this;
        this.getSearchTokens(cmp, params, $A.getCallback(function(urlTokens) {
            console.log('urlTokens :', urlTokens);
            if (urlTokens.tokens.length > 0) {
                cmp.set('v.baseUrl', urlTokens.baseUrl);
                cmp.set('v.searchTokens', urlTokens.tokens);
            } else {
                that.showToast('No Results', 'No records found with provided search query.');
            }
        }));
    },
    extractParams : function(cmp) {
        var reportId = cmp.get('v.reportId');
        var reportParameters = cmp.get('v.reportParameters');
        if (!$A.util.isEmpty(reportParameters)) {
            reportParameters = JSON.parse(reportParameters);
        }
        var tagOperator = cmp.get('v.tagOperator');
        var tagNames = cmp.get('v.tagNames');
        if (!$A.util.isEmpty(tagNames)) {
            tagNames = JSON.parse(tagNames);
        }
        var pageSize = cmp.get('v.pageSize');

        var params = {
            reportId: reportId,
            reportParameters: reportParameters,
            tagOperator: tagOperator,
            tagNames: tagNames,
            pageSize: pageSize
        }
        console.log('Params :', params);
        return params;
    },
    getSearchTokens : function(cmp, params, callback) {
        var action = cmp.get("c.generateUrlAndTokens");
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
    },
    reset : function(cmp) {
        cmp.find('paginator') && cmp.find('paginator').reset();
    }
})