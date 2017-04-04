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

    private sharinpix.Client clientInstance = sharinpix.Client.getInstance();

    /**
     * Generate SharinPix URL to launch mobile application
     * @return Application URL PageReference
     */
    public PageReference generateAppUrl() {
        if (String.isBlank(jobOptions)) jobOptions = '{}';
        Map<String, Object> options = sharinpix.Utils.parseJsonParam(jobOptions);

        String appUrl = (new sharinpix.Utils()).generateMobileAppUrl(jobAlbumId, jobName, options, linkExpiration);
        PageReference pageRef = new PageReference(appUrl);
        pageRef.setRedirect(true);
        return pageRef;
    }
}