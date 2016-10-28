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
		console.log('UPLOADING !');
		helper.upload(component, component.find("file").getElement().files, function(err, res){
			var event = $A.get('e.sharinpix_free:Uploaded');
		event.fire();
			console.log('UPLOAD DONE !');
		});
	}
})