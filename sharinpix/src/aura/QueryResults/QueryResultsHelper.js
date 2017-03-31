({
    loadPage : function(component, page) {
        if (page == null || page == 0) return;
        component.set('v.loading', true);
        var currentPage = component.get('v.currentPage');
        var searchUrls = component.get('v.searchUrls');
        var searchUrl = searchUrls[currentPage - 1];
        component.set('v.searchUrl', searchUrl);
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
    reset : function(component) {
        component.set('v.loading', false);
        component.set('v.currentPage', 0);
        component.set('v.searchUrl', '');
    }
})