({
    loadPage : function(cmp, page) {
        if (page == null || page == 0) return;
        cmp.set('v.loading', true);
        var baseUrl = cmp.get('v.baseUrl');
        var tokens = cmp.get('v.searchTokens');
        var searchUrl;
        if (page == 1) {
            searchUrl = baseUrl + tokens[0];
            cmp.set('v.searchUrl', searchUrl);
        } else {
            searchUrl = baseUrl + tokens[page-1];
            cmp.set('v.searchUrl', searchUrl);
        }
    },
    reset : function(cmp) {
        cmp.set('v.loading', false);
        cmp.set('v.currentPage', 0);
        cmp.set('v.totalPages', 0);
        cmp.set('v.searchUrl', '');
    }
})