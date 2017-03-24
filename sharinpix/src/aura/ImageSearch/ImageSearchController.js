({
    doInit : function(component, event, helper) {
        //console.log('v.reportId', component.get('v.reportId'));
        // how to pass report id on init !!!
        /*if (!$A.util.isEmpty(component.get('v.reportId'))) {
            helper.startSearch(component);
        }*/
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
    clearInput : function(component, event, helper) {
        component.find('txtReportId') && component.find('txtReportId').set('v.value', '');
        component.set('v.reportId', '');
        component.set('v.reportParameters', null);
        component.set('v.selectedTags', '');
        component.find('selTagList') && component.find('selTagList').set('v.value', '');
        component.find('no-tag') && component.find('no-tag').set('v.checked', true);
        component.set('v.displayTags', false);
        component.set('v.tagOperator', '');
        component.set('v.showResultsPanel', false)
    }
})