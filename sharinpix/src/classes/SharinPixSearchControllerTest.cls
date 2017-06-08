@isTest
public class SharinPixSearchControllerTest {
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
        System.assert(String.isNotBlank(baseUrl));
        System.assert(tokens != null);
    }

    @isTest
    static void testGenerateQueryString() {
        Test.startTest();
        String queryStr = SharinPixSearchController.generateQueryString(
            new List<String> { 'album1', 'album2' },
            new List<String> { 'tag1', 'tag2' },
            'OR'
        );
        Test.stopTest();
        System.assertEquals('tags:(+("album1" "album2") +("tag1" OR "tag2"))', queryStr);
    }
}