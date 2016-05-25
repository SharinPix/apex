@isTest
public with sharing class SharinPixSampleControllerTest {
    static testMethod void testContactConstructor() {
        Contact cnt = new Contact(LastName = 'Test Name');
        insert cnt;
        ApexPages.StandardController stdController;
        PageReference pageRefCase = Page.SharinPixSampleContact;
        
        Test.startTest();
        stdController = new ApexPages.StandardController(cnt);
        pageRefCase.getParameters().put('id', String.valueOf(cnt.Id));
        Test.setCurrentPage(pageRefCase);
        SharinPixSampleController sampleContact = new SharinPixSampleController(stdController);
        Test.stopTest();
        
        String id = String.valueOf(cnt.Id);
        // Parameters as defined by SharinPixSampleContact controller
        String expectedParams = '{"Id":"' + id + '","abilities":{"' + id + '":{"Access":{"image_rotate":true,"image_crop":true,"image_delete":true,"image_upload":true,"image_list":true,"see":true}}}}';
        System.assertEquals(expectedParams, sampleContact.parameters);
    }
    
    static testMethod void testCaseConstructor() {
        Case cs = new Case(Status='New', Origin='Email');
        insert cs;
        ApexPages.StandardController stdController;
        PageReference pageRefCase = Page.SharinPixSampleCase;
        
        Test.startTest();
        stdController = new ApexPages.StandardController(cs);
        pageRefCase.getParameters().put('id', String.valueOf(cs.Id));
        Test.setCurrentPage(pageRefCase);
        SharinPixSampleController sampleCase = new SharinPixSampleController(stdController);
        Test.stopTest();
        
        String id = String.valueOf(cs.Id);
        // Parameters as defined by SharinPixSampleCase controller
        String expectedParams = '{"Id":"' + id + '","abilities":{"' + id + '":{"Access":{"image_rotate":true,"image_crop":true,"image_delete":true,"image_upload":true,"image_list":true,"see":true}}}}';
        System.assertEquals(expectedParams, sampleCase.parameters);
    }
}