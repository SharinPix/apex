({
	doInit : function(component, event, helper) {
		component.set('v.loading', true);
	},
	doReload: function(component){
		component.set('v.loading', true);
	},
	onLoaded: function (component) {
		component.set('v.loading', false);
	}
})