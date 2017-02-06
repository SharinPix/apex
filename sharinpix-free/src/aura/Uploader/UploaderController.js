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
	      console.log(component);
	      component.set('v.iframeUrl', '/apex/SharinPixUploadApi?url='+baseUrl);

	      console.log('uploadchoice: ',component.get('v.uploadChoice'));
	    }

		window.addEventListener('message', $A.getCallback( function(postMessageEvent) {
			if (postMessageEvent && component.isValid() ){
				if (postMessageEvent.data.name=='loaded'){
					component.set('v.loaded', true);
				}
				if (postMessageEvent.data.eventIdentifier == component.getGlobalId()){
					if (postMessageEvent.data.name=='uploading'){
						component.set('v.progress', postMessageEvent.data.percent);
					}
					if (postMessageEvent.data.name=='uploaded'){
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
					//TODO: Handle error if any
				}
			}
			})
		);
	},
	fileInputChange: function(component, event, helper) {
		var loaded = component.get('v.loaded');
		console.log('loaded', loaded);
		if (loaded){
			console.log('uploading via api');
			//TODO: add this to helper
			//TODO: add choice of attachment or content document
			component.find('upload-iframe').getElement().contentWindow.postMessage({name: 'new-upload', 
																					recordId: component.get('v.recordId'),
																					eventIdentifier: component.getGlobalId(), 
																					files: component.find('file').getElement().files,
																					prefix: component.get('v.filenamePrefix'),
																					fileType: component.get('v.uploadChoice')
																					}, '*');	
		}
		else {
			console.log('fallback upload');
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