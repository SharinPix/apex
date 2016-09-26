({
  doInit : function(component) {
    component.reload();
    /*var eventMethod = window.addEventListener ? 'addEventListener' : 'attachEvent';
    var eventer = window[eventMethod];
    var messageEvent = eventMethod === 'attachEvent' ? 'onmessage' : 'message';
    eventer(messageEvent, function(e) {
      if (e.origin !== 'https://app.sharinpix.com') { return; }
      if (component.find('iframe') && component.find('iframe').getElement().contentWindow !== e.source) { return; }
      switch(e.data.name) {
        case 'viewer-image-viewed':
          component.set('v.fullscreen', true);
          break;
        case 'viewer-closed':
          component.set('v.fullscreen', false);
          break;
        default:
          console.log('Unhandled event:', e.data.name);
      }
      var event = $A.get('e.sharinpix:Event');
      event.setParams({
        'name' : e.data.name,
        'payload': e.data.payload,
        'albumId': component.get('v.AlbumId'),
        'source': component
      });
      event.fire();
    }, false);*/
  },
  onLoaded : function(component) {
    component.set('v.loading', false);
  },
  doReload : function(component, event, helper) {
    var albumId = component.get('v.AlbumId') || component.get('v.recordId');
    if (albumId == null) {
      helper.setComponentAttributes(component, { 'v.loading': true, 'v.url': null, 'v.sharinpixError': null });
      return;
    }
    helper.getSharinPixURL(component, albumId, function(err, url) {
      if (component.isValid() && url != null) {
        helper.setComponentAttributes(component, { 'v.loading': false, 'v.url': url, 'v.sharinpixError': null });
      } else {
        helper.setComponentAttributes(component, { 'v.loading': false, 'v.url': null, 'v.sharinpixError': 'SharinPix Token Error' });
      }
    });
  }
})