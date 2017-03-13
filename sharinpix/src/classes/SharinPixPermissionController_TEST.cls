@isTest
private class SharinPixPermissionController_TEST {
// Kevan 20170310

    @isTest static void testLoadPageNewPermission() {
        SharinPixPermission__c permission = new SharinPixPermission__c();
        ApexPages.StandardController stdController = new ApexPages.StandardController(permission);
        PageReference pageRefPermission = Page.SharinPixPermission;

        Test.startTest();
        Test.setCurrentPage(pageRefPermission);
        SharinPixPermissionController controller = new SharinPixPermissionController(stdController);
        Test.stopTest();

        system.assertEquals(controller.vfMode, 'New');
    }

    @isTest static void testNewPermissionInsert() {
        SharinPixPermission__c permission = new SharinPixPermission__c();
        ApexPages.StandardController stdController = new ApexPages.StandardController(permission);
        PageReference pageRefPermission = Page.SharinPixPermission;

        Test.setCurrentPage(pageRefPermission);
        SharinPixPermissionController controller = new SharinPixPermissionController(stdController);
        controller.permission.Name = 'Lightning';
        controller.permission.Description__c = 'Description';
        controller.permission.Json__c = '{"Access": {"see": true, "image_list": true}}';

        Test.startTest();
        PageReference pageref = controller.updatePermission();
        Test.stopTest();

        SharinPixPermission__c perm = [Select Id, Name, Description__c, Json__c
                                        From SharinPixPermission__c
                                        Where Id = :controller.permission.Id
                                        Limit 1];
        system.assertEquals(controller.vfMode, 'New');
        system.assertEquals(pageref.getUrl(), '/'+controller.permission.Id);
        system.assertEquals(perm.Name, controller.permission.Name);
        system.assertEquals(perm.Description__c, controller.permission.Description__c);
        system.assertEquals(perm.Json__c, controller.permission.Json__c);
    }

    @isTest static void testPermissionUpdate() {
        SharinPixPermission__c permission = new SharinPixPermission__c(Name='Contact', Description__c='Available for contact', Json__c='{"Access": {"see": true}}');
        insert permission;
        ApexPages.StandardController stdController = new ApexPages.StandardController(permission);
        PageReference pageRefPermission = Page.SharinPixPermission;
        pageRefPermission.getParameters().put('retUrl', '/001');
        Test.setCurrentPage(pageRefPermission);
        SharinPixPermissionController controller = new SharinPixPermissionController(stdController);
        controller.permission.Name = 'Lightning';
        controller.permission.Description__c = 'Description';
        controller.permission.Json__c = '{"Access": {"see": true, "image_list": true}}';

        Test.startTest();
        PageReference pageref = controller.updatePermission();
        Test.stopTest();

        SharinPixPermission__c perm = [Select Id, Name, Description__c, Json__c
                                        From SharinPixPermission__c
                                        Where Id = :controller.permission.Id
                                        Limit 1];
        system.assertEquals(controller.vfMode, 'Edit');
        system.assertEquals(pageref.getUrl(), '/'+controller.permission.Id);
        system.assertEquals(perm.Name, controller.permission.Name);
        system.assertEquals(perm.Description__c, controller.permission.Description__c);
        system.assertEquals(perm.Json__c, controller.permission.Json__c);
    }

    @isTest static void testCancel() {
        SharinPixPermission__c permission = new SharinPixPermission__c();
        ApexPages.StandardController stdController = new ApexPages.StandardController(permission);
        PageReference pageRefPermission = Page.SharinPixPermission;
        pageRefPermission.getParameters().put('retUrl', '/001');
        Test.setCurrentPage(pageRefPermission);

        SharinPixPermissionController controller = new SharinPixPermissionController(stdController);
        Test.startTest();
        PageReference pageref = controller.cancelEdit();
        Test.stopTest();

        system.assertEquals(pageref.getUrl(), '/001');
    }

    @isTest static void testViewPermission() {
        SharinPixPermission__c permission = new SharinPixPermission__c(Name='Contact', Description__c='Available for contact', Json__c='{"Access": {"see": true}}');
        insert permission;
        ApexPages.StandardController stdController = new ApexPages.StandardController(permission);
        PageReference pageRefPermission = Page.SharinPixPermission;

        Test.startTest();
        Test.setCurrentPage(pageRefPermission);
        SharinPixPermissionController controller = new SharinPixPermissionController(stdController);
        Test.stopTest();

        system.assertEquals(controller.vfMode, 'View');
    }
}