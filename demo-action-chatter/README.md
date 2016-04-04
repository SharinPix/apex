# Abstract

Share a post in the Salesforce Chatter feed of a record from a SharinPix image seamlessly.


## Implementation Steps

Apex controller (with API version 35):

```java
global without sharing class SharinPixDemoActionChatter {
    
    global string parameters{get;set;}
    global string contact{get;set;}
    global SharinPixDemoActionChatter(ApexPages.standardController controller) {
        String id = (Id)controller.getId();// Can be any string
        system.debug('#### id: '+id);
        contact = id;

        map<string, boolean> access = new map<string, boolean>();
        access.put('see', true);
        access.put('image_list', true);
        access.put('image_upload', true);
        access.put('image_delete', true);
        access.put('image_crop', true);
        access.put('image_rotate', true);

        List<string> actions = new List<string>();
        actions.add('Post to chatter');

        map<string, object> album_abilities = new map<string, object>();
        album_abilities.put('Access', access);
        album_abilities.put('Actions', actions);


        map<string, object> abilities = new map<string, object>();
        abilities.put(id, album_abilities);

        map<string, object> params = new map<string, object>();
        params.put('abilities', abilities);
  
        parameters = JSON.serialize(params);
    }

    @RemoteAction
    global static void post_to_chatter(string AlbumId, string image_url){
        HttpRequest req = new HttpRequest();
        req.setEndpoint(image_url);
        req.setMethod('GET');
        Http binding = new Http();
        HttpResponse res = binding.send(req);
        Blob image = res.getBodyAsBlob();

        FeedItem post = new FeedItem();
        post.ParentId = AlbumId;
        post.Body = 'posted :';
        post.ContentData = image;
        post.ContentFileName = 'image.jpg';
        insert post;
    }
}
```


VisualForce page:

```html
<apex:page standardController="Contact" extensions="SharinPixDemoActionChatter">
<a id="reloadlink" href="/{!id}" target="_top" style="display: none;"></a>
<a id="newlink" href="#" target="_blank" style="display: none;"></a>
<script>
    var eventMethod = window.addEventListener ? "addEventListener" : "attachEvent";
    var eventer = window[eventMethod];
    var messageEvent = eventMethod == "attachEvent" ? "onmessage" : "message";
    eventer(messageEvent,function(e) {
        console.log('parent received message!:  ',e);
        if (e.origin !== "https://app.sharinpix.com"){return;}
        console.log(e.data.payload.images);
        if (e.data.payload.action == 'Post to chatter'){
            images = e.data.payload.images;
            for(var i=images.length; i--;){
                SharinPixDemoActionChatter.post_to_chatter(images[i].album_id, images[i].thumbnails.mini, function(res){
                    var elem = document.getElementById('reloadlink');
                    var event = new Event('click');
                    elem.dispatchEvent(event);
                });
            }
        }
    },false);
  </script>
  <apex:canvasApp developerName="Albums" height="500px" parameters="{!parameters}" width="100%"/>
</apex:page>
```