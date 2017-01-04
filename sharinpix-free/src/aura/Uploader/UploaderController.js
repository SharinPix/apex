({
	init : function(component) {
		component.set('v.uploading', false);
		component.set('v.n_uploading', 0);
		component.set('v.n_uploaded', 0);
		component.set('v.progress', 0);
		component.set('v.done', false);
		component.set('v.uploaderId', 'uploader_'+component.getGlobalId());
	},
	fileInputChange: function(component, event, helper) {
		helper.upload(component, component.find("file").getElement().files, function(err, res){
			if (err !== 'Error occurred'){
				var eventUploaded = $A.get('e.c:Uploaded');
        		eventUploaded.fire();	
			}
		});	
	}
})