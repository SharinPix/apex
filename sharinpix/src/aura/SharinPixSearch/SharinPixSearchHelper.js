({
    startSearch : function(cmp) {
        this.reset(cmp);
        var reportId = cmp.get('v.reportId');
        if (!this.isValidSFID(reportId)) return;
        cmp.set('v.page', 0);
    },
    doSearch : function(cmp) {
        var params = this.extractParams(cmp);
        var page = cmp.get('v.page');
        if (page == -1) return;
        var baseUrl = cmp.get('v.baseUrl');
        var self = this;

        this.fetchTokens(cmp, params, $A.getCallback(function(urlAndTokens) {
            if (page == 0 && $A.util.isEmpty(urlAndTokens.tokens)) {
                self.showToast('No Results', 'No records found with provided search query.');
                return;
            }
            if ($A.util.isEmpty(urlAndTokens.tokens)) {
                return;
            }
            if (page == 0) {
                var searchUrl = urlAndTokens.baseUrl + urlAndTokens.tokens[0];
                cmp.set('v.searchUrl', searchUrl);
                urlAndTokens.tokens.shift();
            }
            cmp.set('v.tokens', urlAndTokens.tokens);
        }));
    },
    isValidSFID : function(id) {
        if ($A.util.isEmpty(id)) return false;
        if (id.length == 15 || id.length == 18) return true;
        return false;
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
        var page = cmp.get('v.page');
        var params = {
            reportId: reportId,
            reportParameters: reportParameters,
            tagOperator: tagOperator,
            tagNames: tagNames,
            page: page
        }

        return params;
    },
    fetchTokens : function(cmp, params, callback) {
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
    handleNewTokens : function(cmp) {
        var isLoading = cmp.get('v.loading');
        if (isLoading) return;
        var iframeEl = cmp.find('SharinPix').getElement();
        var tokens = cmp.get('v.tokens');
        if ($A.util.isEmpty(tokens)) return;

        tokens.forEach(function(token) {
            iframeEl.contentWindow.postMessage({
                name: 'search-aggregate',
                payload: token
            }, '*');
        });
        var page = cmp.get('v.page');
        cmp.set('v.page', page + 1);
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
        cmp.set('v.currentPage', -1);
        cmp.set('v.searchUrl', '');
    }
})
