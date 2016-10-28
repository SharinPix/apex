({
  doInit : function(component) {
    component.reload();
  },
  doNext : function(component, event, helper){
    helper.changeImage(component, 1);
  },
  doPrevious : function(component, event, helper){
    helper.changeImage(component, -1);
  },
  uploaded: function(component){
    component.reload();
  },
  doReload : function(component, event, helper) {
    console.log('Reload !');
    helper.setComponentAttributes(component, { loading: true, images: [], total: 0, index: 0, image: {id: ''} });
    helper.getImages(component, component.get('v.recordId'), function(err, images) {
      if (component.isValid() && images != null) {
        helper.setComponentAttributes(component, {
          total: images.length,
          index: 0,
          images: images,
          image: images[0],
          loading: false
        });
        //helper.setComponentAttributes(component, { 'v.loading': false, 'v.images': images, 'v.errorMessage': null });
      } else {
        //console.log('is Not Valid !');
        //helper.setComponentAttributes(component, { 'v.loading': false, 'v.images': []], 'v.errorMessage': 'SharinPix Token Error' });
      }
    });
  },
  doDelete: function(component, event, helper) {
    component.set('v.loading', true);
    var id = component.get('v.image').Id;
    helper.deleteAttachment(component, id, function(){
      component.reload();
        /*var event = $A.get('e.sharinpix_free:ImageDeleted');
        event.setParams({ id : id});
        event.fire();
        component.set('v.loading', false);*/
    });
  }
})