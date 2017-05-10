({
    doInit : function(cmp, event, helper) {
        helper.startSearch(cmp);
    },
    startSearch : function(cmp, event, helper) {
        helper.startSearch(cmp);
    },
    stopLoading : function(cmp, event, helper) {
        cmp.set('v.loading', false);
    },
    loadFirstPage : function(cmp, event, helper) {
        cmp.set('v.currentPage', 1);
    },
    loadPreviousPage : function(cmp, event, helper) {
        var currentPage = cmp.get('v.currentPage');
        cmp.set('v.currentPage', --currentPage);
    },
    loadNextPage : function(cmp, event, helper) {
        var currentPage = cmp.get('v.currentPage');
        cmp.set('v.currentPage', ++currentPage);
    },
    loadLastPage : function(cmp, event, helper) {
        var lastPage = cmp.get('v.totalPages');
        cmp.set('v.currentPage', lastPage);
    },
    handlePageChange : function(cmp, event, helper) {
        var currentPage = event.getParam("value");
        helper.loadPage(cmp, currentPage);
    },
    reset : function(cmp, event, helper) {
        helper.reset(cmp);
    }
})