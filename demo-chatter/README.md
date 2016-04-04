# Abstract 

Auto-generate a Chatter post in record feed when a new image is added to SharinPix album of record.

## Implementation Steps

Apex Controller (with API level 35)

```java
global without sharing class SharinPixDemoCaseChatter {
    
    global string parameters{get;set;}
    global string product{get;set;}
    global SharinPixDemoCaseChatter(ApexPages.standardController controller) {
        String id = controller.getId(); // Can be any string
        system.debug('#### id: '+id);
        product = id;

        map<string, boolean> access = new map<string, boolean>();
        access.put('see', true);
        access.put('image_list', true);
        access.put('image_upload', true);
        access.put('image_delete', true);
        access.put('image_crop', true);
        access.put('image_rotate', true);

        List<string> actions = new List<string>();
        //actions.add('Send an email');

        map<string, object> album_abilities = new map<string, object>();
        album_abilities.put('Access', access);
        album_abilities.put('Actions', actions);


        map<string, object> abilities = new map<string, object>();
        abilities.put(id, album_abilities);

        map<string, object> params = new map<string, object>();
        params.put('abilities', abilities);

        params.put('Id', id);
  
        parameters = JSON.serialize(params);
    }

    @RemoteAction
    global static void new_image_uploaded(string imageObj, string idObj){
        map<string, object> imageMap = (map<string, object>)Json.deserializeUntyped(imageObj);
        map<string, object> thumbnailMap = (map<string, object>) imageMap.get('thumbnails');
        string url = (string)thumbnailMap.get('large');

        HttpRequest req = new HttpRequest();
        req.setEndpoint(url);
        req.setMethod('GET');
        Http binding = new Http();
        HttpResponse res = binding.send(req);
        Blob image = res.getBodyAsBlob();

        FeedItem post = new FeedItem();
        post.ParentId = idObj;
        post.Body = 'A new image has been added';
        post.ContentData = image;
        post.ContentFileName = 'image.jpg';
        insert post;
    }
}
```


VisualForce page:

```html
<apex:page standardController="Case" extensions="SharinPixDemoCaseChatter">
  <script>
    var eventMethod = window.addEventListener ? "addEventListener" : "attachEvent";
    var eventer = window[eventMethod];
    var messageEvent = eventMethod == "attachEvent" ? "onmessage" : "message";
    eventer(messageEvent,function(e) {
        //post to chatter
        if (e.data.name === 'image-new'){
            SharinPixDemoCaseChatter.new_image_uploaded(JSON.stringify(e.data.payload.image), "{!$CurrentPage.parameters.Id}", function(res){
                console.log(res);
            });
        } 
    },false);

  </script>
  <apex:canvasApp developerName="Albums" height="500px" parameters="{!parameters}" width="100%"/>
</apex:page>
```