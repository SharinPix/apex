public with sharing class SharinPixDemoDownload {
    public String parameters { get; set; }

    public SharinPixDemoDownload(ApexPages.StandardController stdCtrl) {
        Id albumId = stdCtrl.getId();
        Map<String, Object> params = new Map<String, Object> {
            'abilities' => new Map<String, Object> {
                albumId => new Map<String, Object> {
                    'Access' => new Map<String, Boolean> {
                        'see' => true,
                        'image_list' => true,
                        'image_upload' => true,
                        'image_download' => true
                    }
                }
            }
        };
        parameters = JSON.serialize(params);
    }
}