/**
 * Apex controller used for displaying Einstein Vision Project album
 * @author Kevan
 * @since April 2017
 */
public with sharing class EinsteinVisionProjectAlbumCtrl {
    public string albumUrl {get;set;}

    /**
     * Constructor
     * @param  controller ApexPages.StandardController
     * @return            generate albumUrl for Einstein Vision Project
     */
    public EinsteinVisionProjectAlbumCtrl(ApexPages.standardController controller){
        Id albumId = controller.getId();
        map<string, object> tags = new map<string, object>();
        for(EinsteinLabel__c label: [select id, name from EinsteinLabel__c where EinsteinVisionProject__c = :albumId]){
            tags.put(label.name, new map<string, string>{ 'en' => label.name });
        }
        Map<String, Object> params = new Map<String, Object> {
            'Id' => albumId,
            'abilities' => new Map<String, Object> {
                albumId => new Map<String, Object> {
                    'Access' => new Map<String, Boolean> {
                        'see' => true,
                        'image_list' => true,
                        'image_tag' => true,
                        'image_upload' => true,
                        'image_delete' => true,
                        'image_copy' => false,
                        'image_duplicate' => false,
                        'image_annotate' => false,
                        'image_rotate' => false,
                        'image_crop' => false,
                        'image_download' => true,
                        'paste' => false,
                        'share' => false
                    },
                    'Tags' => tags
                },
                'Display' => new map<string, object>{
                    'tags'=> true
                }
            }
        };
        Client clientInstance = Client.getInstance();

        albumUrl = clientInstance.getHost() +'/pagelayout/' +albumId +'?token='+clientInstance.token(params);
    }

}