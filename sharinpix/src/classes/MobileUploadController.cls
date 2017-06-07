public with sharing class MobileUploadController {
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
    public Integer linkExpiration { get; set; }

    private Client clientInstance = Client.getInstance();

    /**
     * Generate SharinPix URL to launch mobile application
     * @return Application URL PageReference
     */
    public PageReference generateAppUrl() {
        if (String.isBlank(jobOptions)) jobOptions = '{}';
        Map<String, Object> appOptions = Utils.parseJsonParam(jobOptions);

        String appUrl = (new Utils()).generateMobileAppUrl(
            jobAlbumId,
            new Map<String, Object> {
                'name' => jobName,
                'appOptions' => appOptions,
                'linkExpiration' => linkExpiration
            }
        );
        PageReference pageRef = new PageReference(appUrl);
        pageRef.setRedirect(true);
        return pageRef;
    }
}