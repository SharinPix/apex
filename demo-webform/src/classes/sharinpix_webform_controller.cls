public class sharinpix_webform_controller {
    
    public case cs {get;set;}
    public string url {get;set;}
    public string album_id{get;set;}
    
    public sharinpix_webform_controller(ApexPages.standardController controller) {
        cs = new Case();
        Blob hash = Crypto.generateDigest('MD5', Blob.valueOf(UserInfo.getOrganizationId()+system.now()));
        album_id = EncodingUtil.convertToHex(hash);

        map<string, object> claims = new map<string, object>{
            'abilities' => new map<string, object>{
                album_id => new map<string, object>{
                    'Access'  => new map<string, object>{
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
        url = 'https://app.sharinpix.com/pagelayout/'+album_id+'?token='+sharinpix.Client.getInstance().token(claims);
    }
    
    public PageReference saveCase(){
        try{
            insert cs;
            ApexPages.addmessage(new Apexpages.Message(ApexPages.Severity.CONFIRM,'Save successful'));   
        }
        catch(Exception e){
            ApexPages.addmessage(new Apexpages.Message(ApexPages.Severity.Error,'Error  occurred: '+e.getMessage()));    
        }
        return null;
    }

    public PageReference renameAlbum(){
        map<string, object> claims = new map<string, object>{
            'abilities' => new map<string, object>{
                album_id => new map<string, object>{
                    'Access'  => new map<string, object>{
                        'rename' => true,
                        'see' => true
                    }
                }
            }
        };
        System.debug(album_id);
        System.debug(cs.Id);
        map<string, object> payload = new map<string, object>{ 'album'=> new map<string, string>{ 'public_id'=>cs.id}};
        sharinpix.Client.getInstance().put('/albums/'+album_id, blob.valueof(JSON.serialize(payload)), claims);
        return null;
    }
}