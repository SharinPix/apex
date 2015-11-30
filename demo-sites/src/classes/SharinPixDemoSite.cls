public with sharing class SharinPixDemoSite {
    public string url{get;set;}
	public String getToken() {
        String id = 'salesforce-id';

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

        Client sp = new Client('Secret-Id', 'Secret-Secret', 'https://api.sharinpix.com/api/v1');
        string token = new Token(sp, params).issue();
        String url = 'https://app.sharinpix.com/albums/'+id+'?token='+token;
        return url;
	}
}