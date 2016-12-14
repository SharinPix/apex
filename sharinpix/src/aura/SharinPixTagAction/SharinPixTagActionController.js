({
	doInit : function(component, event, helper) {
		var eventMethod = window.addEventListener ? "addEventListener" : "attachEvent";
	    var eventer = window[eventMethod];
	    var messageEvent = eventMethod == "attachEvent" ? "onmessage" : "message";
	    eventer(messageEvent,function(e) {
	    	if(e === undefined) {return;}
	        if (e.origin.indexOf('app.sharinpix.com') == -1){
	        	return;
	        }
	        if (e.data.name === 'tag-image-new'){
	            if (e.data.payload.tag_image.tag.action !== null){
	            	helper.execCommand(component.get("v.recordId"),JSON.stringify(e.data.payload.tag_image), component, event);
	            }
	        }
	    },false);
	},
})