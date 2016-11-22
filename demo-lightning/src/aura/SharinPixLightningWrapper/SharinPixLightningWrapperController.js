({
    doInit : function(component) {
        var id = component.find('album-id').get('v.value') || component.find('record-id').get('v.value');
        component.set('v.albumId', (id != null) ? id : component.get('v.recordId'));
    },
    changeId : function(component) {
        var id = component.find('album-id').get('v.value') || component.find('record-id').get('v.value');
        component.set('v.albumId', id);
    },
    changeHeight : function(component) {
        var height = component.find('height').get('v.value');
        component.set('v.height', height);
    },
    reloadSharinPix : function(component) {
        component.find('sharinpix-cmp').reload();
    }
})