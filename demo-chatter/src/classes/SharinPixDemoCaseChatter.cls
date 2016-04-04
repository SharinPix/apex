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
