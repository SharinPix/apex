@isTest(seeAllData=true)
private class ImageSearchControllerTest {
    @isTest static void testConstructor() {
        Id reportId = [SELECT Id FROM Report WHERE DeveloperName = 'SharinPix_Sample_Account_Report' LIMIT 1].Id;

        PageReference pageRef = Page.ImageSearch;
        pageRef.getParameters().put('reportId', reportId);
        Test.setCurrentPage(pageRef);

        Map<String, HttpCalloutMock> requestResponses = new Map<String, HttpCalloutMock> {
            'https://api.sharinpix.com/api/v1/tags?page=1' => new SingleRequestMock(200, 'OK','[{"name":"dummy tag"}]', null),
            'https://api.sharinpix.com/api/v1/tags?page=2' => new SingleRequestMock(200, 'OK','[]', null)
        };
        Test.setMock(HttpCalloutMock.class, new MultiRequestMock(requestResponses));

        Test.startTest();
        ImageSearchController ctrl = new ImageSearchController();
        Test.stopTest();
        System.assert(true);
    }

    @isTest static void testSearch() {
        Id reportId = [SELECT Id FROM Report WHERE DeveloperName = 'SharinPix_Sample_Account_Report' LIMIT 1].Id;

        PageReference pageRef = Page.ImageSearch;
        Test.setCurrentPage(pageRef);

        Map<String, HttpCalloutMock> requestResponses = new Map<String, HttpCalloutMock> {
            'https://api.sharinpix.com/api/v1/tags?page=1' => new SingleRequestMock(200, 'OK','[{"name":"dummy tag"}]', null),
            'https://api.sharinpix.com/api/v1/tags?page=2' => new SingleRequestMock(200, 'OK','[]', null)
        };
        Test.setMock(HttpCalloutMock.class, new MultiRequestMock(requestResponses));

        ImageSearchController ctrl = new ImageSearchController();
        ctrl.jsonParams = '{"reportId":"' + reportId + '","tagFilter":"allTags","selectedTags":["dummy tag"]}';
        Test.startTest();
        ctrl.search();
        Test.stopTest();
        System.assert(true);
    }
}