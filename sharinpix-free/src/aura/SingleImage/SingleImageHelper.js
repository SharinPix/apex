({
	reloadSource: function(component) {
		var source = component.get('v.attachmentId');
		if (!$A.util.isEmpty(source) && (source.length === 15 || source.length === 18)) {
			component.set('v.source', '/servlet/servlet.FileDownload?file=' + source);
		}
		else {
			component.set('v.source', source);			
		}
	}
})