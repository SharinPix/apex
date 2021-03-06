global without sharing class SharinPixDemoDeleteImage {
    
    global string parameters{get;set;}
    global string contact{get;set;}
    global SharinPixDemoDeleteImage(ApexPages.standardController controller) {
        String id = (Id)controller.getId();// Can be any string
        system.debug('#### id: '+id);
        contact = id;

        map<string, boolean> access = new map<string, boolean>();
        access.put('see', true);
        access.put('image_list', true);

        List<string> actions = new List<string>();
        actions.add('Delete Images');

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
    global static void delete_images(string imageObj){

        String id = 'salesforce-id';
        SharinPix.Client sp = SharinPix.Client.getInstance();

        list<object> imageList = (list<object>) Json.deserializeUntyped(imageObj);
        list<string> imageUrlList = new list<string>();
        for(object img: imageList){
            map<string, object> imgMap = (map<string, object>) img;
            String imageId = string.valueof(imgMap.get('public_id'));
            system.debug('#### imageId: '+imageId);

            map<string, boolean> access = new map<string, boolean>();
	        access.put('image_delete', true);
	        map<string, object> album_abilities = new map<string, object>();
	        album_abilities.put('Access', access);
	        map<string, object> abilities = new map<string, object>();
	        abilities.put((string)imgMap.get('album_id'), album_abilities);
	        map<string, object> params = new map<string, object>();
        	params.put('abilities', abilities);
            sp.destroy('/images/'+imageId, params);
        }
    }
}