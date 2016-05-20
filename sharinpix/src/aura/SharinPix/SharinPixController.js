({
    doInit : function(component, event, helper) {
        var action = component.get('c.getToken');
        action.setParams({ albumId : component.get('v.AlbumId') });
        action.setCallback(this, function(response) {
            if (response.state == 'SUCCESS') {
            	component.set('v.url', response.returnValue);
            } else {
                component.set('v.error', response.error[0].message);
                component.set('v.loading', false);
            }
        });
        $A.enqueueAction(action);
        
        var eventMethod = window.addEventListener ? "addEventListener" : "attachEvent";
        var eventer = window[eventMethod];
        var messageEvent = eventMethod == "attachEvent" ? "onmessage" : "message";
        eventer(messageEvent,function(e) {
            if (component.find('iframe') && component.find('iframe').getElement().contentWindow === e.source) {
                var event = $A.get("e.c:Event");
                event.setParams({
                    "name" : e.data.name,
                    "payload": e.data.payload,
                    "albumId": component.get('v.AlbumId'),
                    "source": component
                 });
                event.fire();

                if (e.data.name == 'viewer-image-viewed') {
                     component.set('v.fullscreen', true);
                }
                if (e.data.name == 'viewer-closed') {
                     component.set('v.fullscreen', false);
                }
            }
        },false);
	},
    onLoaded : function(component, event) {
    	component.set('v.loading', false);
	}
})