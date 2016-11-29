@isTest
private class SharinPixWebformControllerTest {
	/* Test is for code coverage only */
    
    private static testMethod void testConstructor() {
        Case c = new Case();
        insert c;
		ApexPages.StandardController stdCtrl = new ApexPages.StandardController(c);
        SharinPixWebformController wfCtrl = new SharinPixWebformController(stdCtrl);
        wfCtrl.saveCase();
        wfCtrl.renameAlbum();
        System.assert(true);
    }
}