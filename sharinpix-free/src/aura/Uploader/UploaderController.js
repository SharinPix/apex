({
	init : function(component) {
		component.set('v.uploading', false);
		component.set('v.n_uploading', 0);
		component.set('v.n_uploaded', 0);
		component.set('v.progress', 0);
		component.set('v.done', false);
		component.set('v.uploaderId', 'uploader_'+component.getGlobalId());

	    if (component.isValid()){
	      var baseUrl = window.location.protocol + '//' + window.location.hostname;
	      console.log(component);
	      component.set('v.iframeUrl', '/apex/test_upload?url='+baseUrl);
	    }

	    window.addEventListener('message', $A.getCallback( function(postMessageEvent) {
	        // if (postMessageEvent.origin !== 'https://app.sharinpix.com'){
	        //   return;
	        // }
	        if (postMessageEvent && component.isValid() ){
				if (postMessageEvent.data.eventIdentifier == component.getGlobalId()){
					console.log('Unhandled event:', postMessageEvent.data);
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
				}
	        }
	      })
	    );

	    // setInterval(function(event){
	    //   component.find('upload-iframe').getElement().contentWindow.postMessage('loaded parent', '*');
	    // }, 3000)



	},
	fileInputChange: function(component, event, helper) {
		// helper.upload(component, component.find("file").getElement().files, function(err, res){
		// 	if (err !== 'Error occurred'){
		// 		var eventUploaded = $A.get('e.c:Uploaded')
		// 		eventUploaded.setParam('eventIdentifier', component.get('v.eventIdentifier'));
  //       		eventUploaded.fire();
		// 	}
		// });	

		component.find('upload-iframe').getElement().contentWindow.postMessage({name: 'new-upload', 
																				recordId: component.get('v.recordId'),
																				eventIdentifier: component.getGlobalId(), 
																				files: component.find('file').getElement().files
																				}, '*');
	}
})