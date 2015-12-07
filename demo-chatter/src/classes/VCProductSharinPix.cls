global without sharing class VCProductSharinPix {
    
    global string parameters{get;set;}
    global string product{get;set;}
    global VCProductSharinPix(ApexPages.standardController controller) {
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
                body += '<image src="'+url+'"><br/>';
            }
            mail.setHtmlBody(body);
            mails.add(mail);
        }
          
        Messaging.sendEmail(mails);
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