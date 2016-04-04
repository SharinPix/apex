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
        //task.SharinPix_Image__c = image_url;
        insert task;
        string id = (string)task.id;
        return id;
    }
}