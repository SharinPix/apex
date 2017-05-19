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
        helper.handleNewTokens(cmp);
    },
    startLoading : function(cmp) {
        cmp.set('v.loading', true);
    },
    stopLoading : function(cmp, event, helper) {
        cmp.set('v.loading', false);
        if ($A.util.isEmpty(cmp.get('v.searchUrl'))) return;
        helper.handleNewTokens(cmp);
    }
})