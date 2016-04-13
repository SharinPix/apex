public with sharing class SharinPixDemoSite {
    public String getUrl() {
        String id = 'salesforce-id';
        
        Map<string, boolean> access = new Map<string, boolean>();
        access.put('see', true);
        access.put('image_list', true);
        access.put('image_upload', true);
        access.put('image_delete', true);
        access.put('image_crop', true);
        access.put('image_rotate', true);

        Map<string, object> album_abilities = new Map<string, object>();
        album_abilities.put('Access', access);

        Map<string, object> abilities = new Map<string, object>();
        abilities.put(id, album_abilities);

        Map<string, object> params = new Map<string, object>();
        params.put('abilities', abilities);

        SharinPix.Client clientInstance = SharinPix.Client.getInstance();
        String token = clientInstance.token(params);
        String url = 'https://app.sharinpix.com/albums/'+id+'?token='+token;
        return url;
    }
}