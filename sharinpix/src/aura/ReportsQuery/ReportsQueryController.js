({
    doInit : function(component, event, helper) {
        helper.fillReports(component);
        var reportId = component.get('v.reportId');
        if (!$A.util.isEmpty(reportId)) {
            component.set('v.id', reportId);
        }
    },
    setId : function(component, event, helper) {
        var id = component.find('txtReportId').get('v.value');
        if ($A.util.isEmpty(id)) return;
        id = id.trim();
        if (id.length != 15 && id.length != 18) return;
        if (id.length == 15) id = helper.toCaseSafeId(id);
        component.set('v.id', id);
    },
    setReportId : function(component, event, helper) {
        var id = component.get('v.id');
        if (!$A.util.isEmpty(id)) {
            component.find('txtReportId').set('v.value', id)
            component.set('v.reportId', id);
        }
    },
    reset : function(component, event, helper) {
        component.find('txtReportId') && component.find('txtReportId').set('v.value', '');
        component.set('v.reportId', '');
        component.find('reportParams') && component.find('reportParams').reset();
        component.set('v.id', '');
    }
})