@isTest
private class SharinPixComponentControllerTEST {

	@isTest static void componentUrlTest() {
		SharinPixComponentController controller = new SharinPixComponentController();
        controller.parametersInput = '{\'path\': \'/pagelayout/superid\', \'abilities\': {\'superid\': { \'Access\': {\'see\': true, \'image_upload\': true, \'image_list\': true}}}}';
        controller.heightInput = '200px';
        controller.iframeIdInput = 'iframe';
        controller.secretUrlInput = 'sharinpix://clientid:clientsecret@api.sharinpix.com/api/v1';

        Test.startTest();
        string url = controller.getUrl();
        string iframeId = controller.getIframeId();
        string style = controller.getStyle();
        Test.stopTest();

        Client clientInstance = new Client(controller.secretUrlInput);
        String assertUrl = clientInstance.getAppHost() + '?token=' + clientInstance.token(sharinpix.Utils.parseJsonParam(controller.parametersInput));
        system.assertEquals(url, assertUrl);
        system.assertEquals(iframeId, 'iframe');
        system.assertEquals(style, 'border: none; width: 100%; height: 200px;');
	}

    @isTest static void componentInstanceTest() {
        SharinPixComponentController controller = new SharinPixComponentController();
        controller.parametersInput = '{\'path\': \'/pagelayout/superid\', \'abilities\': {\'superid\': { \'Access\': {\'see\': true, \'image_upload\': true, \'image_list\': true}}}}';
        controller.heightInput = '200px';
        controller.iframeIdInput = 'iframe';

        Test.startTest();
        string url = controller.getUrl();
        string iframeId = controller.getIframeId();
        string style = controller.getStyle();
        Test.stopTest();

        Client clientInstance = new Client('sharinpix://test:test@api.sharinpix.com/api/v1');
        String assertUrl = clientInstance.getAppHost() + '?token=' + clientInstance.token(sharinpix.Utils.parseJsonParam(controller.parametersInput));
        System.assertEquals(url, assertUrl);
        System.assertEquals(iframeId, 'iframe');
        System.assertEquals(style, 'border: none; width: 100%; height: 200px;');
    }
}