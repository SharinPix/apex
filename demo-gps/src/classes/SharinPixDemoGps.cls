public with sharing class SharinPixDemoGps {
	public string url {get;set;}
	public SharinPixDemoGps(ApexPages.standardController controller) {
        Id id = controller.getId();

        String token = SharinPix.Client.getInstance().token(
        	new Map<string, object>{
        		'abilities'=>new Map<string, object>{
        			id=>new Map<string, object>{
        				'Access'=>new Map<string, boolean>{
	        				'see'=> true,
	        				'image_list'=> true,
	        				'image_delete'=> true,
	        				'image_crop'=> true,
	        				'image_upload'=> true,
	        				'image_rotate'=> true,
	        				'see'=> true
	        			}
        			}
        		}
        	}
       	);
        url = 'https://app.sharinpix.com/pagelayout/'+id+'?token='+token;
    }
}