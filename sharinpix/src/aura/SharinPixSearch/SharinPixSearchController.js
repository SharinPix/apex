({
    doInit : function(cmp, event, helper) {

    },
    startLexSpinner : function(cmp, event, helper) {
        helper.toggleLexSpinner(cmp, 'lexSpinner', true);
    },
    stopLexSpinner : function(cmp, event, helper) {
        helper.toggleLexSpinner(cmp, 'lexSpinner', false);
    },
    go : function(cmp, event, helper) {
        cmp.find('searchResults') && cmp.find('searchResults').startSearch();
        cmp.set('v.showResultsPanel', true);
    },
    reset : function(cmp, event, helper) {
        cmp.find('reportSelector') && cmp.find('reportSelector').reset();
        cmp.find('tagSelector') && cmp.find('tagSelector').reset();
        cmp.find('searchResults') && cmp.find('searchResults').reset();
        cmp.set('v.showResultsPanel', false);
    }
})