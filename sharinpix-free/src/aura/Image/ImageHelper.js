({
  getImages : function(component, recordId, callback) {
    console.log('GetImages!');
    var action = component.get('c.getFiles');
    action.setParams({ parentId : recordId, prefix: '', contentType: 'image/%' });
    action.setCallback(this, function(response) {
      console.log('callback !', response.getState());
      if (response.getState() === 'SUCCESS') {
      	console.log('ICIC : ', response.getReturnValue());
        callback(null, response.getReturnValue());
      } else {
        callback(JSON.stringify(response.getError()), null);
      }
    });
    $A.enqueueAction(action);
  },
  changeImage  : function(component, diff){
      console.log('CHANGE IMAGE !');
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
      console.log('Image changed !', images[index].Id);
  },
  setComponentAttributes : function(component, attributes) {
    if(!component.isValid()){
      console.log('component Invalid !');
      return;
    }
    console.log('shortcut !');
    for (var key in attributes) {
      console.log('set', key, attributes[key], component.isValid());
      component.set('v.'+key, attributes[key]);
    }
  },
  deleteAttachment : function(component, id, callback) {
    var action = component.get('c.deleteAttachment');
    action.setParams({ Id : id });
    console.log('delete:', { Id : id });
    action.setCallback(this, function(response) {
      console.log('callback !', response.getState());
      if (response.getState() === 'SUCCESS') {
        console.log('ICIC : ', response.getReturnValue());
        callback(null, response.getReturnValue());
      } else {
        callback(JSON.stringify(response.getError()), null);
      }
    });
    $A.enqueueAction(action);
  }
})