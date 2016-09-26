({
  setComponentAttributes : function(component, attributes) {
    for (var key in attributes) {
      component.set(key, attributes[key]);
    }
  },
  getSharinPixURL : function(component, albumId, callback) {
    var action = component.get('c.getToken');
    action.setParams({ albumId : albumId });
    action.setCallback(this, function(response) {
      if (response.getState() === 'SUCCESS') {
        callback(null, response.getReturnValue());
      } else {
        callback(JSON.stringify(response.getError()));
      }
    });
    $A.enqueueAction(action);
  }
})