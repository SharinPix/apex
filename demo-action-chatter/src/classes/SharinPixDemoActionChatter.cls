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