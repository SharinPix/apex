public class MobileUploadController {
    /*
    ----------------------------------------------------------------------
    -- - Author        : SharinPix
    -- - Description   : Controller for MobileUpload component
    -- -
    -- - Maintenance History:
    --
    -- Date         Name  Version  Remarks
    -- -----------  ----  -------  ---------------------------------------
    -- 03-APR-2016  ABE   1.0      Initial version
    ----------------------------------------------------------------------
    */
    public String jobAlbumId { get; set; }
    public String jobName { get; set; }
    public String jobOptions { get; set; }
    public Integer jobDelay { get; set; }

    /**
     * Generate SharinPix URL to launch mobile application
     * @return Application URL
     */
    public PageReference generateAppUrl() {
        if (String.isBlank(jobAlbumId)) jobAlbumId = ApexPages.currentPage().getParameters().get('albumId');
        if (String.isBlank(jobAlbumId)) return null;
        if (jobAlbumId InstanceOf Id)   jobAlbumid = (Id)jobAlbumId;
        if (String.isBlank(jobName))    jobName = ApexPages.currentPage().getParameters().get('name');
        if (String.isBlank(jobName))    jobName = jobAlbumId;
        if (String.isBlank(jobOptions)) jobOptions = '{}';
        if (jobDelay == null)           jobDelay = 300;

        Map<String, Object> options = getOptions(jobOptions);

        Map<String, Object> params = new Map<String, Object> {
            'album_id' => jobAlbumId,
            'name' => jobName,
            'exp' => (jobDelay != 0) ? (DateTime.now().getTime()/1000) + jobDelay : 0,
            'native_app_options' => options,
            'abilities' => new Map<String, Object> {
                jobAlbumId => new Map<String, Object> {
                    'Access' => new Map<String, Boolean> {
                        'see' => true,
                        'image_upload' => true
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

    /**
     * Returns parsed JSON of SharinPix Mobile App options, passed to component.
     * @param  options JSON representation of SharinPix mobile app options. Example: {'grayscale':true}
     * @return         Map of String to Object representation of JSON
     */
    private Map<String, Object> getOptions(String options) {
        return (Map<String, Object>)JSON.deserializeUntyped(options.replace('\'', '"'));
    }
}