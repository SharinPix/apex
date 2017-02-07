({
	init : function(component) {
		component.set('v.uploading', false);
		component.set('v.n_uploading', 0);
		component.set('v.n_uploaded', 0);
		component.set('v.progress', 0);
		component.set('v.done', false);
		component.set('v.uploaderId', 'uploader_'+component.getGlobalId());
		component.set('v.loaded', false);

    if (component.isValid()){
      var baseUrl = window.location.protocol + '//' + window.location.hostname;
      component.set('v.iframeUrl', '/apex/sharinpix_free__SharinPixUploadApi?url='+baseUrl+'&eventIdentifier='+component.getGlobalId());
    }

		window.addEventListener('message', $A.getCallback( function(postMessageEvent) {
			if (postMessageEvent && component.isValid() ){
				if (postMessageEvent.data.name==='loaded' && postMessageEvent.data.eventIdentifier === component.getGlobalId()){
					console.log('api enabled');
					component.set('v.loaded', true);
				}
				if (postMessageEvent.data.eventIdentifier === component.getGlobalId()){
					if (postMessageEvent.data.name==='uploading'){
						component.set('v.progress', postMessageEvent.data.percent);
					}
					if (postMessageEvent.data.name==='uploaded'){
						component.set('v.n_uploaded', 0);
						component.set('v.n_uploading', 0);
						component.set('v.progress', 0);
						component.set('v.done', true);
						var input = component.find("file").getElement();
						input.type = '';
						input.type = 'file';

						var eventUploaded = $A.get('e.c:Uploaded')
						eventUploaded.setParam('eventIdentifier', component.get('v.eventIdentifier'));
						eventUploaded.fire();
					}
					if (postMessageEvent.data.name==='error'){
						var error = JSON.parse(postMessageEvent.data.message)[0];
            var event = $A.get('e.c:ErrorHandling').setParams({error: error.message, eventIdentifier: component.get('v.eventIdentifier')});
            event.fire();
					}
				}
			}
			})
		);
	},
	fileInputChange: function(component, event, helper) {
		var loaded = component.get('v.loaded');
		if (loaded){
			//TODO: add this to helper
			var payload = {name: 'new-upload', 
							recordId: component.get('v.recordId'),
							eventIdentifier: component.getGlobalId(), 
							files: component.find('file').getElement().files,
							prefix: component.get('v.filenamePrefix'),
							fileType: 'Attachment'
						};
			helper.upload_via_api(component, payload);
		}
		else {
			helper.upload(component, component.find("file").getElement().files, function(err, res){
				if (err !== 'Error occurred'){
					var eventUploaded = $A.get('e.c:Uploaded');
					eventUploaded.setParam('eventIdentifier', component.get('v.eventIdentifier'));
	        		eventUploaded.fire();
				}
			});
		}
	}
})