global class SharinPixDemoTagToFieldController {
    public String parameters { get; set; }

    public SharinPixDemoTagToFieldController(ApexPages.StandardController stdCtrl) {
        Id accountId = stdCtrl.getId();
        Map<String, Object> params = new Map<String, Object> {
            'Id' => accountId,
            'abilities' => new Map<String, Object> {
                accountId => new Map<String, Object> {
                    'Access' => new Map<String, Boolean> {
                        'see' => true,
                        'image_list' => true,
                        'image_tag' => true,
                        'image_upload' => true,
                        'image_delete' => true,
                        'image_copy' => true,
                        'image_duplicate' => true,
                        'image_annotate' => true,
                        'image_rotate' => true,
                        'image_crop' => true,
                        'image_download' => true,
                        'paste' => true,
                        'share' => true
                    },
                    'Tags' => new Map<String, Object> {
                        'tag_name' => new Map<String, String> {
                            'en' => 'tag_name',
                            'fr' => 'nom_tag'
                        }
                    }
                }
            }
        };
        parameters = JSON.serialize(params);
    }

    @RemoteAction
    global static void updateField(String jsonParams) {
        Map<String, Object> params = (Map<String, Object>)JSON.deserializeUntyped(jsonParams);
        Id albumId = (Id)params.get('albumId');
        String imageUrl = (String)params.get('imageUrl');
        Account a = new Account(Id = albumId);
        a.SharinPixField__c = '<img src="' + imageUrl + '" alt="SharinPix Image" width="200" height="200"/>';
        upsert a;
    }
}