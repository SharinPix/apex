({
  getImages : function(component, recordId, callback) {
    var action = component.get('c.getFiles');
    action.setParams({ parentId : recordId, prefix: '', contentType: 'image/%' });
    action.setCallback(this, function(response) {
      if (response.getState() === 'SUCCESS') {
        callback(null, response.getReturnValue());
      } else {
        callback(JSON.stringify(response.getError()), null);
      }
    });
    $A.enqueueAction(action);
  },
  changeImage  : function(component, diff){
      var index = component.get('v.index') + diff;
      var images = component.get('v.images');
      if(index >= images.length) {
        index = 0;
      }
      if(index < 0){
          index = images.length-1;
      }
      this.setComponentAttributes(component, {
        index: index,
        image: images[index]
      })
  },
  setComponentAttributes : function(component, attributes) {
    if(!component.isValid()){
      return;
    }
    for (var key in attributes) {
      component.set('v.'+key, attributes[key]);
    }
  },
  deleteAttachment : function(component, id, callback) {
    var action = component.get('c.deleteAttachment');
    action.setParams({ Id : id });
    action.setCallback(this, function(response) {
      if (response.getState() === 'SUCCESS') {
        callback(null, response.getReturnValue());
      } else {
        callback(JSON.stringify(response.getError()), null);
      }
    });
    $A.enqueueAction(action);
  }
})