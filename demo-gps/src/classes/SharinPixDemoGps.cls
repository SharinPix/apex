public with sharing class SharinPixDemoGps {
    public String url { get; set; }

    public SharinPixDemoGps(ApexPages.StandardController controller) {
        Id id = controller.getId();

        String token = SharinPix.Client.getInstance().token(
            new Map<String, Object> {
                'abilities' => new Map<String, Object> {
                    id => new Map<String, Object> {
                        'Access' => new Map<String, Boolean> {
                            'see' => true,
                            'image_list' => true,
                            'image_delete' => true,
                            'image_crop' => true,
                            'image_upload' => true,
                            'image_rotate' => true,
                            'see' => true
                        }
                    }
                }
            }
        );
        url = 'https://app.sharinpix.com/pagelayout/' + id + '?token=' + token;
    }
}