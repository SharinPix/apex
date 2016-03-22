global without sharing class SharinPixDemoActionDescription {
    
    global string parameters{get;set;}
    global string contact{get;set;}
    global SharinPixDemoActionDescription(ApexPages.standardController controller) {
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
        actions.add('Add to description');

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