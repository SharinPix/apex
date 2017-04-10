({
    reloadSource: function(component) {
        var source = component.get('v.attachmentId');
        component.set('v.source', undefined);
        if (!$A.util.isEmpty(source) && (source.length === 15 || source.length === 18)) {
            if (this.validateStartsWith(source, '00P')){
                component.set('v.source', (component.get('v.siteUrl') === undefined ? '' : component.get('v.siteUrl')) + '/servlet/servlet.FileDownload?file=' + source);
            }
            else if (this.validateStartsWith(source, '068')){
                component.set('v.source', '/sfc/servlet.shepherd/version/download/'+source);
            }
        }
        else {
            component.set('v.source', source);
        }
    },
    siteUrl: function(component){
        var action = component.get("c.site");
        action.setCallback(this, function(response) {
            component.set('v.siteUrl', response.getReturnValue());
            this.reloadSource(component);
        });
        $A.enqueueAction(action);
    },
    validateStartsWith: function(source, searchString){
        return source.indexOf(searchString, 0) === 0;
    }
})