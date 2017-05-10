({
    startSearch : function(cmp) {
        this.reset(cmp);
        var reportId = cmp.get('v.reportId');
        if ($A.util.isEmpty(reportId) || (reportId.length != 15 && reportId.length != 18)) return;
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
        var that = this;
        this.getSearchUrls(cmp, params, $A.getCallback(function(searchUrls) {
            console.log('Search URLs :', searchUrls);
            cmp.set('v.searchUrls', searchUrls);
            if (searchUrls.length > 0) {
                cmp.set('v.currentPage', 1);
                cmp.set('v.totalPages', searchUrls.length);
            } else {
                that.showToast('No Results', 'No records found with provided search query.');
                cmp.set('v.currentPage', 0);
                cmp.set('v.totalPages', 0);
            }
        }));
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
    loadPage : function(cmp, page) {
        if (page == null || page == 0) return;
        cmp.set('v.loading', true);
        var currentPage = cmp.get('v.currentPage');
        var searchUrls = cmp.get('v.searchUrls');
        var searchUrl = searchUrls[currentPage - 1];
        cmp.set('v.searchUrl', searchUrl);
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
        cmp.set('v.loading', false);
        cmp.set('v.currentPage', 0);
        cmp.set('v.totalPages', 0);
        cmp.set('v.searchUrl', '');
    }
})