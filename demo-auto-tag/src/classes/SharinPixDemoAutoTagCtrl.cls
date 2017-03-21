public class SharinPixDemoAutoTagCtrl {
    public String parameters { get; set; }

    public SharinPixDemoAutoTagCtrl(ApexPages.StandardController stdCtrl) {
        Id albumId = stdCtrl.getId();
        Map<String, Object> params = new Map<String, Object> {
            'Id' => albumId,
            'abilities' => new Map<String, Object> {
                'tags' => new Map<String, Object> {
                    /*'create' => true,*/
                    'auto_tag' => 'Sea'
                    //'auto_tag' => new List<String> { 'Sea', 'Land' }
                },
                albumId => new Map<String, Object> {
                    'Access' => new Map<String, Boolean> {
                        'see' => true,
                        'image_list' => true,
                        'image_tag' => true
                    },
                    'Tags' => new Map<String, Object> {
                        'Sea' => new Map<String, Object> {
                            'en' => 'Sea',
                            'fr' => 'Mer'
                        },
                        'Land' => new Map<String, Object> {
                            'en' => 'Land',
                            'fr' => 'Terre'
                        }
                    }
                }
            }
        };
        parameters = JSON.serialize(params);
    }
}