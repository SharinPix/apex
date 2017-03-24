({
    doInit : function(component, event, helper) {
        console.log('doInit');
        helper.fillReports(component);
    },
    setReportId : function(component, event, helper) {
        var reportId = component.find('txtReportId').get('v.value');
        if ($A.util.isEmpty(reportId)) return;
        if (reportId.trim().length == 15) {
            component.set('v.reportId', helper.toCaseSafeId(reportId));
        } else if (reportId.trim().length == 18) {
            component.set('v.reportId', reportId);
        }
    },
})