({
	reloadSource: function(component) {
		var source = component.get('v.attachmentId');
		if (!$A.util.isEmpty(source) && (source.length === 15 || source.length === 18)) {
			if (source.startsWith('00P')){
				component.set('v.source', '/servlet/servlet.FileDownload?file=' + source);	
			}
			else if (source.startsWith('068')){
				component.set('v.source', '/sfc/servlet.shepherd/version/download/'+source);
			}
		}
		else {
			component.set('v.source', source);
		}
	}
})