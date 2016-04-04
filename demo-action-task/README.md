# Abstract

Create task in one click from a call to action on SharinPix image.

## Implementation Steps

Apex controller (with API version 36)

```java
global without sharing class SharinPixDemoActionTask {
    
    global string parameters{get;set;}
    global string contact{get;set;}
    global SharinPixDemoActionTask(ApexPages.standardController controller) {
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
        actions.add('Create a task');

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
    global static string create_task(string AlbumId, string image_url){
        Task task = new Task();
        task.Subject = 'Created from SharinPix';
        task.Status='Active';
        task.Description='';
        task.WhoId = AlbumId;
        task.SharinPix_Image__c = image_url;
        insert task;
        string id = (string)task.id;
        return id;
    }
}
```


VisualForce page

```html
<apex:page standardController="Contact" extensions="SharinPixDemoActionTask">
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
        if (e.data.payload.action == 'Create a task'){
            images = e.data.payload.images;
            for(var i=images.length; i--;){
                SharinPixDemoActionTask.create_task(images[i].album_id, images[i].thumbnails.large, function(res){
                    var elem = document.getElementById('newlink');
                    elem.href='/'+res+'/e?retURL=%2F'+res;
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
