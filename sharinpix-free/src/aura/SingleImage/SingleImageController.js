({
	doInit : function(component, event, helper) {
		//component.set('v.style', 'height: 300px; line-height: 300px;');
		// if ($A.util.isEmpty(component.get('v.attachmentId'))){
		// 	component.set('v.loading', true);
		// }else {
		// 	component.set('v.loading', false);	
		// }
		
		var source = component.get('v.attachmentId');
		if (!$A.util.isEmpty(source) && (source.length === 15 || source.length === 18)) {
			component.set('v.source', '/servlet/servlet.FileDownload?file=' + source);
		}
		else {
			component.set('v.source', source);			
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