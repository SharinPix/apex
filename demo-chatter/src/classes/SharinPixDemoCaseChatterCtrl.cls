global with sharing class SharinPixDemoCaseChatterCtrl {
    public String parameters { get; set; }
    
    public SharinPixDemoCaseChatterCtrl(ApexPages.StandardController stdCtrl) {
        Id albumId = stdCtrl.getId();
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
                        'image_annotate' => true,
                        'image_rotate' => true,
                        'image_crop' => true,
                        'image_download' => true,
                        'paste' => true,
                        'share' => true
                    },
                    'Tags' => new Map<String, Object> {
                        'Tag 1' => new Map<String, Object> {
                            'en' => 'Tag 1',
                            'fr' => 'Tag 1'
                        },
                        'Tag 2' => new Map<String, Object> {
                            'en' => 'Tag 2',
                            'fr' => 'Tag 2'
                        }
                    }
                }
            }
        };
        parameters = JSON.serialize(params);
    }

    @RemoteAction
    global static void newEvent(String jsonParams) {
        Map<String, Object> params = (Map<String, Object>)JSON.deserializeUntyped(jsonParams);
        String eventName = (String)params.get('eventName');
        String albumId = (String)params.get('albumId');
        String imageThumbUrl = (String)params.get('imageThumbUrl');
        String filename = (String)params.get('filename') + '.jpg';
        
        HttpRequest req = new HttpRequest();
        req.setEndpoint(imageThumbUrl);
        req.setMethod('GET');
        Http binding = new Http();
        HttpResponse res = binding.send(req);
        Blob imageBlob = res.getBodyAsBlob();
        
        String postText;
        if (eventName == 'image-new') {
            postText = 'A new image has been uploaded.';
        } else if (eventName == 'tag-image-new') {
            String tagName = (String)params.get('tagName');
            postText = 'An image has been tagged with ' + tagName + '.';
        }
        
        ContentVersion version = new ContentVersion();
        version.Title = filename;
        version.PathOnClient = 'sharinpix://' + filename;
        version.VersionData = imageBlob;
        insert version;
        
        FeedItem post = new FeedITem();
        post.Body = postText;
        post.ParentID = albumId;
        insert post;
        
        FeedAttachment feedAtt = new FeedAttachment();
        feedAtt.FeedEntityId = post.id;
        feedAtt.Type = 'Content';
        feedAtt.RecordId = version.id;
        insert feedAtt;
    }
}