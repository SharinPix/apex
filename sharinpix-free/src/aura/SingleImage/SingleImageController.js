({
	doInit : function(component, event, helper) {
		//component.set('v.style', 'height: 300px; line-height: 300px;');
		if (component.get('v.attachmentId') === undefined){
			component.set('v.loading', false);
		}else {
			component.set('v.loading', true);	
		}
		var height = component.get('v.height');
		if (typeof height !== "undefined" && height !== null && height > 200) {
			
		}else{
			height = 200;
		}
		component.set('v.style', 'height: '+height+'px; line-height: '+height+'px;');
	},
	doReload: function(component){
		component.set('v.loading', true);
	},
	onLoaded: function (component) {
		component.set('v.loading', false);
	}
})