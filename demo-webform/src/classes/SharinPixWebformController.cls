public class SharinPixWebformController {
    
    public Case cs { get; set; }
    public String url { get; set; }
    public String albumId { get; set; }
    
    public SharinPixWebformController() {
        cs = new Case();
        Blob hash = Crypto.generateDigest('MD5', Blob.valueOf(UserInfo.getOrganizationId() + System.now()));
        albumId = EncodingUtil.convertToHex(hash);

        Map<String, Object> claims = new Map<String, Object> {
            'abilities' => new Map<String, Object> {
                albumId => new Map<String, Object> {
                    'Access'  => new Map<String, Object> {
                        'see' => true,
                        'image_list' => true,
                        'image_upload' => true,
                        'image_delete' => true,
                        'image_crop' => true,
                        'image_rotate' => true,
                        'image_annotate' => true
                    }
                }
            }
        };
        url = 'https://app.sharinpix.com/pagelayout/' + albumId + '?token=' + sharinpix.Client.getInstance().token(claims);
    }
    
    public PageReference saveCase() {
        try {
            insert cs;
            ApexPages.addmessage(new Apexpages.Message(ApexPages.Severity.CONFIRM, 'Save successful'));   
        }
        catch(Exception e) {
            ApexPages.addmessage(new Apexpages.Message(ApexPages.Severity.Error, 'Error occurred: ' + e.getMessage()));    
        }
        return null;
    }

    public PageReference renameAlbum() {
        if (!Test.isRunningTest()) {
            (new sharinpix.Utils()).renameAlbum(albumId, cs.Id);
        }
        return null;
    }
}
