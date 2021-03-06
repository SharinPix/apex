global without sharing class SharinPixDemoAction {
    
    global string parameters{get;set;}
    global string contact{get;set;}
    global SharinPixDemoAction(ApexPages.standardController controller) {
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
        actions.add('Send an email');
        actions.add('Add to description');
        actions.add('Create a task');
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
    
    @RemoteAction
    global static string create_task(string AlbumId, string image_url){
        Task task = new Task();
        task.Subject = 'Created from SharinPix';
        task.Status='Active';
        task.Description='';
        task.WhoId = AlbumId;
        //task.SharinPix_Image__c = image_url;
        insert task;
        string id = (string)task.id;
        return id;
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



    @RemoteAction
    global static void add_to_description(string imageObj){
        list<object> imageList = (list<object>) Json.deserializeUntyped(imageObj);
        list<string> imageUrlList = new list<string>();
        string contactId ;
        for(object img: imageList){
            map<string, object> imgMap = (map<string, object>) img;
            map<string, object> thumbnailMap = (map<string, object>) imgMap.get('thumbnails');
            imageUrlList.add(string.valueof(thumbnailMap.get('large')));
            contactId = string.valueof(imgMap.get('album_id'));
        }
        Contact contact = [select id, description__c from Contact where id = :contactId limit 1];
        if (imageUrlList.size() > 0) {
            string body = contact.description__c == null ? '' : contact.description__c;
            for(string url: imageurllist){
                body += '<img src="'+url+'" /><br/>';
            }
            contact.description__c = body;
            update contact;

        }
    }
}