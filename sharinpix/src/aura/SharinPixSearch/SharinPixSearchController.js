({
    doInit : function(cmp, event, helper) {
        helper.startSearch(cmp);
    },
    startSearch : function(cmp, event, helper) {
        helper.startSearch(cmp);
    },
    doSearch : function(cmp, event, helper) {
        helper.doSearch(cmp);
    },
    handleNewTokens : function(cmp, event, helper) {
        var searchReady = cmp.get('v.searchReady');
        if (searchReady) {
            helper.handleNewTokens(cmp);
        }
    },
    startLoading : function(cmp) {
        cmp.set('v.loading', true);
        cmp.set('v.searchReady', false);
    },
    stopLoading : function(cmp, event, helper) {
        cmp.set('v.loading', false);
    }
})