({
    doInit : function(component, event, helper) {
        component.set('v.currentPage', 0);
        var albumIds = component.get('v.albumIds');
        var pageSize = component.get('v.pageSize') == 0 ? albumIds.length : component.get('v.pageSize');
        component.set('v.totalPages', Math.ceil(albumIds.length / pageSize));
        component.set('v.currentPage', 1);
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
    }
})