({
    startSearch : function(cmp) {
        var reportId = cmp.get('v.reportId');
        if (!this.isValidSFID(reportId)) return;
        var that = this;
        var _doSearch = this.debounce($A.getCallback(function() {
            that.doSearch(cmp);
        }), 2000);
        _doSearch();
    },
    isValidSFID : function(id) {
        if ($A.util.isEmpty(id)) return false;
        if (id.length == 15 || id.length == 18) return true;
        return false;
    },
    debounce : function(func, wait, immediate) {
        // https://davidwalsh.name/javascript-debounce-function
        var timeout;
        return function() {
            var context = this, args = arguments;
            var later = function() {
                timeout = null;
                if (!immediate) func.apply(context, args);
            };
            var callNow = immediate && !timeout;
            clearTimeout(timeout);
            timeout = setTimeout(later, wait);
            if (callNow) func.apply(context, args);
        };
    },
    doSearch : function(cmp) {
        var params = this.extractParams(cmp);
        var self = this;

        this.fetchTokens(cmp, params, $A.getCallback(function(urlAndTokens) {
            if ($A.util.isEmpty(urlAndTokens.tokens)) {
                self.showToast('No Results', 'No records found with provided search query.');
                return;
            }
            var searchUrl = urlAndTokens.baseUrl + urlAndTokens.tokens[0];
            cmp.set('v.searchUrl', searchUrl);
            urlAndTokens.tokens.shift();
            cmp.set('v.tokens', urlAndTokens.tokens);
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
        var params = {
            reportId: reportId,
            reportParameters: reportParameters,
            tagOperator: tagOperator,
            tagNames: tagNames
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