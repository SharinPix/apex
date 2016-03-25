# Abstract

Share images with your contacts in one click from a call to action on SharinPix contact album.

## Implementation Steps

Apex Controller (with API version 36)

```java
global without sharing class SharinPixDemoActionEmail {
    global string parameters{get;set;}
    global string contact{get;set;}
    global SharinPixDemoActionEmail(ApexPages.standardController controller) {
        String id = (Id)controller.getId(); // Can be any string
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
        actions.add('Send an email');

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
    global static void send_mail(string imageObj){
        list<object> imageList = (list<object>) Json.deserializeUntyped(imageObj);
        list<string> imageUrlList = new list<string>();
        string contactId ;
        for(object img: imageList){
            map<string, object> imgMap = (map<string, object>) img;
            map<string, object> thumbnailMap = (map<string, object>) imgMap.get('thumbnails');
            imageUrlList.add(string.valueof(thumbnailMap.get('mini')));
            contactId = string.valueof(imgMap.get('album_id'));
        }
        
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        
        Contact contact = [select id, name, email from Contact where id = :contactId limit 1];
        if (imageUrlList.size() > 0) {
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            
            List<String> sendTo = new List<String>();
            sendTo.add(contact.Email);
            mail.setToAddresses(sendTo);
            
            mail.setReplyTo(UserInfo.getUserEmail());
            mail.setSenderDisplayName(UserInfo.getName());
            
            mail.setSubject('Photo Uploaded');
            String body = 'Hello '+contact.name;
            body += '<br/>The following photos has been uploaded on your record: <br/>';
            for(string url: imageurllist){
                body += '<img src="'+url+'" /><br/>';
            }
            mail.setHtmlBody(body);
            mails.add(mail);
        }
        Messaging.sendEmail(mails);
    }
}
```


VisualForce page

```html
<apex:page standardController="Contact" extensions="SharinPixDemoActionEmail">
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
        if (e.data.payload.action == 'Send an email'){
            SharinPixDemoActionEmail.send_mail(JSON.stringify(e.data.payload.images), function(res){
                alert('Email has been sent.')
            });
        }
    },false);
  </script>
  <apex:canvasApp developerName="Albums" height="500px" parameters="{!parameters}" width="100%"/>
</apex:page>
```