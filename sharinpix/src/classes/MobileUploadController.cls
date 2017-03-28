public class MobileUploadController {
    public String jobAlbumId { get; set; }
    public String jobName { get; set; }
    public String jobOptions { get; set; }
    public Integer jobDelay { get; set; }

    public PageReference generateAppUrl() {
        if (String.isBlank(jobAlbumId)) jobAlbumId = ApexPages.currentPage().getParameters().get('albumId');
        if (String.isBlank(jobAlbumId)) return null;
        if (String.isBlank(jobName))    jobName = ApexPages.currentPage().getParameters().get('name');
        if (String.isBlank(jobName))    jobName = jobAlbumId;
        if (String.isBlank(jobOptions)) jobOptions = '{}';

        Map<String, Object> options = getOptions(jobOptions);

        jobAlbumId = jobAlbumId instanceOf Id ? (Id)jobAlbumId : jobAlbumId;
        Map<String, Object> params = new Map<String, Object> {
            'album_id' => jobAlbumId,
            'name' => jobName,
            'exp' => jobDelay != 0 ? (DateTime.now().getTime()/1000) + jobDelay : 0,
            'native_app_options' => options,
            'abilities' => new Map<String, Object> {
                jobAlbumId => new Map<String, Object> {
                    'Access' => new Map<String, Boolean> {
                        'see' => true,
                        'image_upload' => true,
                        'image_list' => true,
                        'image_tag' => true,
                        'image_delete' => true,
                        'image_annotate' => true,
                        'image_rotate' => true,
                        'image_crop' => true,
                        'image_download' => true
                    }
                }
            }
        };
        sharinpix.Client clientInstance = sharinpix.Client.getInstance();
        String appUrl = 'https://app.sharinpix.com/native_upload?token=' + clientInstance.token(params);

        PageReference pageRef = new PageReference(appUrl);
        pageRef.setRedirect(true);
        return pageRef;
    }

    private Map<String, Object> getOptions(String options) {
        return (Map<String, Object>)JSON.deserializeUntyped(options.replace('\'', '"'));
    }
}