@isTest
public class SharinPixSearchControllerTest {

    @isTest(seeAllData=true)
    static void testGetReports() {
        Test.startTest();
        Map<String, List<Report>> reports = SharinPixSearchController.getReports();
        Test.stopTest();
        System.assert(reports.get('SharinPix Sample Reports') != null);
    }

    @isTest
    static void testGetAllTags() {
        Test.startTest();
        List<String> tags = SharinPixSearchController.getAllTags();
        Test.stopTest();
        System.assertEquals('Tag 1', tags[0]);
    }

    @isTest(seeAllData=true)
    static void testGenerateUrlAndTokens() {
        Id reportId = [SELECT Id FROM Report WHERE DeveloperName = 'SharinPix_Sample_Account_Report' LIMIT 1].Id;
        String tagOp = 'AND';
        List<String> tagNames = new List<String> { 'Tag 1' };
        Test.startTest();
        Map<String, Object> urlAndTokens = SharinPixSearchController.generateUrlAndTokens(reportId, null, tagOp, tagNames);
        Test.stopTest();

        String baseUrl = (String)urlAndTokens.get('baseUrl');
        List<String> tokens = (List<String>)urlAndTokens.get('tokens');
        System.assert(baseUrl != null);
        System.assert(tokens != null);
    }
}