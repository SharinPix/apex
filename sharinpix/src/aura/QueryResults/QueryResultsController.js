({
    doInit : function(component, event, helper) {
        component.set('v.currentPage', 0);
        var searchUrls = component.get('v.searchUrls');
        component.set('v.totalPages', searchUrls.length);
        component.set('v.currentPage', 1);
    },
    stopLoading : function(component, event, helper) {
        component.set('v.loading', false);
    },
    loadFirstPage : function(component, event, helper) {
        component.set('v.currentPage', 1);
    },
    loadPreviousPage : function(component, event, helper) {
        var currentPage = component.get('v.currentPage');
        component.set('v.currentPage', --currentPage);
    },
    loadNextPage : function(component, event, helper) {
        var currentPage = component.get('v.currentPage');
        component.set('v.currentPage', ++currentPage);
    },
    loadLastPage : function(component, event, helper) {
        var lastPage = component.get('v.totalPages');
        component.set('v.currentPage', lastPage);
    },
    handlePageChange : function(component, event, helper) {
        var currentPage = event.getParam("value");
        helper.loadPage(component, currentPage);
    },
    reset : function(component, event, helper) {
        helper.reset(component);
    }
})