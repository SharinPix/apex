public without sharing class SharinPixDemoWebhook {
    public PageReference handleWebHook() {
        string eventType =  ApexPages.currentPage().getHeaders().get('x-sharinpix-event');

        Map<String, Object> body = apexPages.currentPage().getParameters().containsKey('p')?
            (Map<String, Object>)JSON.deserializeUntyped(ApexPages.currentPage().getParameters().get('p')):
            new map<string, object>();

        if (eventType=='new_image'){
            Map<String, Object> album = (Map<String, Object>)body.get('album');
            String Id = (String) album.get('public_id');
            // Do whatever you want with the information from the payload of a new_image
        } else if (eventType=='new_provider_reply') {
            map<string, object> payload = (Map<String, Object>)body.get('payload');
            map<string, object> provider = (Map<String, object>)body.get('provider');
            string providerName = (string)provider.get('name');
            string providerId = (string)provider.get('id');
            map<string, object> image = (map<string, object>)body.get('image');
            map<string, object> thumbnails = (map<string, object>)image.get('thumbnails');
            string thumbnail = (string)thumbnails.get('mini');
            map<string, object> album = (map<string, object>)image.get('album');
            String id = (String) album.get('public_id');
            // Do whatever you want with the information from the payload of a new_provider_reply
        } else {
            // Handle other events
            system.debug('## unknown request');
        }
        return null;
    }
}