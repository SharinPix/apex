({
    doInit : function(component, event, helper) {
        console.log('reportId', component.get('v.reportId'));
        console.log('reportParameters', component.get('v.reportParameters'));
        if (!$A.util.isEmpty(component.get('v.reportId'))) {
            helper.startSearch(component);
        }
    },
    startLexSpinner : function(component, event, helper) {
        helper.toggleLexSpinner(component, 'lexSpinner', true);
    },
    stopLexSpinner : function(component, event, helper) {
        helper.toggleLexSpinner(component, 'lexSpinner', false);
    },
    doSearch : function(component, event, helper) {
        helper.startSearch(component);
    },
    reset : function(component, event, helper) {
        component.find('reportsQuery') && component.find('reportsQuery').reset();
        component.find('tagsQuery') && component.find('tagsQuery').reset();
        component.find('queryResults') && component.find('queryResults').reset();
        component.set('v.showResultsPanel', false);
    }
})