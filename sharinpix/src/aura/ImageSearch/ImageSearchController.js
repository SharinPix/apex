({
    doInit : function(component, event, helper) {

    },
    startLexSpinner : function(component, event, helper) {
        helper.toggleLexSpinner(component, 'lexSpinner', true);
    },
    stopLexSpinner : function(component, event, helper) {
        helper.toggleLexSpinner(component, 'lexSpinner', false);
    },
    go : function(component, event, helper) {
        component.find('queryResults') && component.find('queryResults').startSearch();
        component.set('v.showResultsPanel', true);
    },
    reset : function(component, event, helper) {
        component.find('reportsQuery') && component.find('reportsQuery').reset();
        component.find('tagsQuery') && component.find('tagsQuery').reset();
        component.find('queryResults') && component.find('queryResults').reset();
        component.set('v.showResultsPanel', false);
    }
})