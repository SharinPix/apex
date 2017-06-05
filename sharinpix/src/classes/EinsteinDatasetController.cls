/**
 * Apex Controller to display album on Einstein Dataset
 * @author  Kevan
 * @since April 2017
 */
public with sharing class EinsteinDatasetController {

    public string albumUrl {get;set;}
    /**
     * Constructor
     * @param  controller ApexPages.StandardController
     * @return will generate iframe albumUrl
     */
    public EinsteinDatasetController(ApexPages.StandardController controller){
        Id albumId = controller.getId();
        Id visionProjectId = [Select id, EinsteinVisionProject__c from EinsteinDataset__c where Id = :albumId].EinsteinVisionProject__c;
        map<string, object> tags = new map<string, object>();
        for(EinsteinLabel__c label: [select id, name from EinsteinLabel__c where EinsteinVisionProject__c = :visionProjectId]){
            tags.put(label.name, new map<string, string>{ 'en' => label.name });
        }
        Map<String, Object> params = new Map<String, Object> {
            'Id' => albumId,
            'abilities' => new Map<String, Object> {
                albumId => new Map<String, Object> {
                    'Access' => new Map<String, Boolean> {
                        'see' => true,
                        'image_list' => true,
                        'image_tag' => false,
                        'image_upload' => false,
                        'image_delete' => false,
                        'image_copy' => false,
                        'image_duplicate' => false,
                        'image_annotate' => false,
                        'image_rotate' => false,
                        'image_crop' => false,
                        'image_download' => true,
                        'paste' => false,
                        'share' => false
                    },
                    'Tags' => tags,
                    'Display' => new map<string, object>{
                        'tags'=> true
                    }
                }
            }
        };
        Client clientInstance = Client.getInstance();

        albumUrl = clientInstance.getAppHost() +'/pagelayout/' +albumId +'?token='+clientInstance.token(params);
    }
}