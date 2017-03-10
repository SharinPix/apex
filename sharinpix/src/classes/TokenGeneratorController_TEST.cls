@isTest
private class TokenGeneratorController_TEST {
// Kevan 20170310

    static {

    }

	@isTest static void testLoadPageNewToken() {
        SharinPixPermission__c permission = new SharinPixPermission__c();
        ApexPages.StandardController stdController = new ApexPages.StandardController(permission);
        PageReference pageRefPermission = Page.SharinPixTokenGenerator;

        Test.startTest();
        //pageRefPermission.getParameters().put('id', String.valueOf(cnt.Id));
        Test.setCurrentPage(pageRefPermission);
        TokenGeneratorController controller = new TokenGeneratorController(stdController);
        Test.stopTest();

        system.assertEquals(controller.vfMode, 'New');
	}

	@isTest static void testNewTokenInsert() {
		SharinPixPermission__c permission = new SharinPixPermission__c();
        ApexPages.StandardController stdController = new ApexPages.StandardController(permission);
        PageReference pageRefPermission = Page.SharinPixTokenGenerator;

        Test.setCurrentPage(pageRefPermission);
        TokenGeneratorController controller = new TokenGeneratorController(stdController);
        controller.token.Name = 'Lightning';
        controller.token.Description__c = 'Description';
        controller.token.Json__c = '{"Access": {"see": true, "image_list": true}}';

        Test.startTest();
        PageReference pageref = controller.updateToken();
        Test.stopTest();

        SharinPixPermission__c perm = [Select Id, Name, Description__c, Json__c
                                        From SharinPixPermission__c
                                        Where Id = :controller.token.Id
                                        Limit 1];
        system.assertEquals(controller.vfMode, 'New');
        system.assertEquals(pageref.getUrl(), '/'+controller.token.Id);
        system.assertEquals(perm.Name, controller.token.Name);
        system.assertEquals(perm.Description__c, controller.token.Description__c);
        system.assertEquals(perm.Json__c, controller.token.Json__c);
	}

    @isTest static void testTokenUpdate() {
        SharinPixPermission__c permission = new SharinPixPermission__c(Name='Contact', Description__c='Available for contact', Json__c='{"Access": {"see": true}}');
        insert permission;
        ApexPages.StandardController stdController = new ApexPages.StandardController(permission);
        PageReference pageRefPermission = Page.SharinPixTokenGenerator;
        pageRefPermission.getParameters().put('retUrl', '/001');
        Test.setCurrentPage(pageRefPermission);
        TokenGeneratorController controller = new TokenGeneratorController(stdController);
        controller.token.Name = 'Lightning';
        controller.token.Description__c = 'Description';
        controller.token.Json__c = '{"Access": {"see": true, "image_list": true}}';

        Test.startTest();
        PageReference pageref = controller.updateToken();
        Test.stopTest();

        SharinPixPermission__c perm = [Select Id, Name, Description__c, Json__c
                                        From SharinPixPermission__c
                                        Where Id = :controller.token.Id
                                        Limit 1];
        system.assertEquals(controller.vfMode, 'Edit');
        system.assertEquals(pageref.getUrl(), '/'+controller.token.Id);
        system.assertEquals(perm.Name, controller.token.Name);
        system.assertEquals(perm.Description__c, controller.token.Description__c);
        system.assertEquals(perm.Json__c, controller.token.Json__c);
    }

    @isTest static void testCancel() {
        SharinPixPermission__c permission = new SharinPixPermission__c();
        ApexPages.StandardController stdController = new ApexPages.StandardController(permission);
        PageReference pageRefPermission = Page.SharinPixTokenGenerator;
        pageRefPermission.getParameters().put('retUrl', '/001');
        Test.setCurrentPage(pageRefPermission);

        TokenGeneratorController controller = new TokenGeneratorController(stdController);
        Test.startTest();
        PageReference pageref = controller.cancelEdit();
        Test.stopTest();

        system.assertEquals(pageref.getUrl(), '/001');
    }

    @isTest static void testViewToken() {
        SharinPixPermission__c permission = new SharinPixPermission__c(Name='Contact', Description__c='Available for contact', Json__c='{"Access": {"see": true}}');
        insert permission;
        ApexPages.StandardController stdController = new ApexPages.StandardController(permission);
        PageReference pageRefPermission = Page.SharinPixTokenGenerator;

        Test.startTest();
        //pageRefPermission.getParameters().put('id', String.valueOf(cnt.Id));
        Test.setCurrentPage(pageRefPermission);
        TokenGeneratorController controller = new TokenGeneratorController(stdController);
        Test.stopTest();

        system.assertEquals(controller.vfMode, 'View');
    }
}