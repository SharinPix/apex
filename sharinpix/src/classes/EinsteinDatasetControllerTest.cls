@isTest
private class EinsteinDatasetControllerTest {

    static String API_URL = 'https://api.sharinpix.com/api/v1';
    private static EinsteinVisionProject__c project;
    private static list<EinsteinLabel__c> labels;
    private static EinsteinDataset__c dataset;

    static {
        project = new EinsteinVisionProject__c(Name='project');
        insert project;

        labels = new list<EinsteinLabel__c>{
            new EinsteinLabel__c(Name='red', EinsteinVisionProject__c=project.id),
            new EinsteinLabel__c(Name='blue', EinsteinVisionProject__c=project.id),
            new EinsteinLabel__c(Name='yellow', EinsteinVisionProject__c=project.id)
        };
        insert labels;

        dataset = new EinsteinDataset__c(Name='Dataset', EinsteinVisionProject__c=project.id);
        insert dataset;
    }

	@isTest static void displayAlbumTest() {
        Map<String, HttpCalloutMock> requestResponses = new Map<String, HttpCalloutMock> {
            API_URL + '/einstein_dataset' => new SingleRequestMock(200, 'OK', '{"dataset_id": "IEHOUPWMCEROEH9823NC"}', null),
            API_URL + '/einstein_model' => new SingleRequestMock(200, 'OK', '{"model_id": "IEHOUPWMCEROEH9823NC"}', null)
        };
        Test.setMock(HttpCalloutMock.class, new MultiRequestMock(requestResponses));

        ApexPages.StandardController stdController;
        PageReference pageRef = Page.EinsteinDataset;

        Test.startTest();
        stdController = new ApexPages.StandardController(dataset);
        pageRef.getParameters().put('id', String.valueOf(dataset.Id));
        Test.setCurrentPage(pageRef);
        EinsteinDatasetController controller = new EinsteinDatasetController(stdController);
        Test.stopTest();

        string url = Client.getInstance().getHost() +'/pagelayout/' +dataset.Id +'?token=';

        system.assert(controller.albumUrl.startsWith(url));
	}
}