/**
 * Controller used for displaying Einstein Model training status
 * @author  Kevan
 * @since April 2017
 */
global with sharing class EinsteinModelStatusController {

    global Id recordId {get;set;}
    global string albumUrl{get;set;}
    global string modelStatusUrl{get;set;}
    global string domain {get;private set;}

    /**
     * Contructor which generate iframe url for displaying status and test album
     * @param  controller [description]
     * @return            [description]
     */
	global EinsteinModelStatusController(ApexPages.StandardController controller) {
        recordId = controller.getId();

        EinsteinModel__c model = [Select id, EinsteinDataset__r.EinsteinVisionProject__c, EinsteinDataset__c from EinsteinModel__c where Id = :recordId];
        string albumId = model.EinsteinDataset__c+'_test';
        map<string, object> tags = new map<string, object>();
        for(EinsteinLabel__c label: [select id, name from EinsteinLabel__c where EinsteinVisionProject__c = :model.EinsteinDataset__r.EinsteinVisionProject__c]){
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
                        'image_copy' => true,
                        'image_duplicate' => true,
                        'image_annotate' => false,
                        'image_rotate' => true,
                        'image_crop' => true,
                        'image_download' => true,
                        'paste' => true,
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

        domain = clientInstance.getAppHost();
        albumUrl = clientInstance.getAppHost() +'/pagelayout/' +albumId +'?token='+clientInstance.token(params);
        modelStatusUrl = clientInstance.getAppHost() + '?token='+clientInstance.token(new map<string, object>{'einstein'=>true, 'path'=>'/einstein_model/'+recordId});
	}
}