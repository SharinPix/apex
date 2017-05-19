@isTest
private class EinsteinVisionProjectAlbumCtrlTest {
	private static EinsteinVisionProject__c project;
    private static list<EinsteinLabel__c> labels;

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

    @isTest static void displayAlbumTest() {

        ApexPages.StandardController stdController;
        PageReference pageRef = Page.EinsteinVisionProjectAlbum;

        Test.startTest();
        stdController = new ApexPages.StandardController(project);
        pageRef.getParameters().put('id', String.valueOf(project.Id));
        Test.setCurrentPage(pageRef);
        EinsteinVisionProjectAlbumCtrl controller = new EinsteinVisionProjectAlbumCtrl(stdController);
        Test.stopTest();

        string url = Client.getInstance().getHost() +'/pagelayout/' +project.Id +'?token=';

        system.assert(controller.albumUrl.startsWith(url));
    }
}