@isTest
private class EinsteinTriggerUtilsTest {

    static String API_URL = 'https://api.sharinpix.com/api/v1';

    private static EinsteinVisionProject__c project;
    private static list<EinsteinLabel__c> labels;
    private static EinsteinDataset__c dataset;
    private static EinsteinModel__c model;

    static {
        project = new EinsteinVisionProject__c(Name='project');
        insert project;

        labels = new list<EinsteinLabel__c>{
            new EinsteinLabel__c(Name='red', EinsteinVisionProject__c=project.id),
            new EinsteinLabel__c(Name='blue', EinsteinVisionProject__c=project.id),
            new EinsteinLabel__c(Name='yellow', EinsteinVisionProject__c=project.id)
        };
        insert labels;


    }

	@isTest static void createDatasetTest() {
        Map<String, HttpCalloutMock> requestResponses = new Map<String, HttpCalloutMock> {
          API_URL + '/einstein_dataset' => new SingleRequestMock(200, 'OK', '{"dataset_id": "IEHOUPWMCEROEH9823NC"}', null)
        };
        Test.setMock(HttpCalloutMock.class, new MultiRequestMock(requestResponses));

        dataset = new EinsteinDataset__c(Name='Dataset', EinsteinVisionProject__c=project.id);

        Test.starttest();
        insert dataset;
        Test.stopTest();

        system.assertEquals('Dataset', [select name from EinsteinDataset__c limit 1].Name);
	}

	@isTest static void createModelTest() {
        Map<String, HttpCalloutMock> requestResponses = new Map<String, HttpCalloutMock> {
            API_URL + '/einstein_dataset' => new SingleRequestMock(200, 'OK', '{"dataset_id": "IEHOUPWMCEROEH9823NC"}', null),
            API_URL + '/einstein_model' => new SingleRequestMock(200, 'OK', '{"model_id": "IEHOUPWMCEROEH9823NC"}', null)
        };
        Test.setMock(HttpCalloutMock.class, new MultiRequestMock(requestResponses));

        dataset = new EinsteinDataset__c(Name='Dataset', EinsteinVisionProject__c=project.id);
        insert dataset;

		model = new EinsteinModel__c(Name='Model', EinsteinDataset__c=dataset.id);
        Test.startTest();
        insert model;
        Test.stopTest();

        system.assertEquals('Model', [select name from EinsteinModel__c limit 1].Name);
	}

}