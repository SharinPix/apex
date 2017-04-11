@isTest
public class MobileUploadControllerTest {
    /*
    ----------------------------------------------------------------------
    -- - Author        : SharinPix
    -- - Description   : Test class for MobileUpload component controller
    -- -
    -- - Maintenance History:
    --
    -- Date         Name  Version  Remarks
    -- -----------  ----  -------  ---------------------------------------
    -- 03-APR-2016  ABE   1.0      Initial version
    ----------------------------------------------------------------------
    */
    static testMethod void testAppUrl() {
        MobileUploadController mUploadCtrl = new MobileUploadController();
        mUploadCtrl.jobAlbumId = 'TestId';
        mUploadCtrl.jobName = 'TestName';
        mUploadCtrl.jobOptions = '{\'grayscale\':true}';

        Test.startTest();
        PageReference pageRef = mUploadCtrl.generateAppUrl();
        Test.stopTest();

        String appUrl = pageRef.getUrl();
        System.assert(appUrl.contains('native_upload'));
        String token = appUrl.substringAfter('token=');
        String[] tokenParts = token.split('\\.');
        String decodedData = EncodingUtil.base64Decode(tokenParts[1]).toString();
        System.assert(decodedData.contains('TestId'));
        System.assert(decodedData.contains('TestName'));
        System.assert(decodedData.contains('{"grayscale":true}'));
    }
}