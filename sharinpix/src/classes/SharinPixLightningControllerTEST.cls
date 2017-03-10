@isTest
private class SharinPixLightningControllerTEST {
  static Profile adminProfile;
  static User adminUser;
  static Profile ROProfile;
  static User ROUser;
  static Account sampleAccount;
  static Contact sampleContact;

  static {
    adminProfile = [SELECT Id, Name FROM Profile WHERE Name = 'System Administrator']; //'Administrateur système'
    adminUser = new User(
      UserName = 'admin@sharinpixlightning1.com',
      FirstName = 'Test-FName',
      LastName = 'Test-LName',
      Alias = 'test',
      Email = 'admin@sharinpixlightning1.com',
      EmailEncodingKey = 'UTF-8',
      LanguageLocaleKey = 'en_US',
      LocalesIdKey = 'en_US',
      TimezonesIdKey = 'America/Los_Angeles',
      ProfileId = adminProfile.Id
    );
    insert adminUser;
    ROProfile = [SELECT Id, Name FROM Profile WHERE Name = 'Read Only']; // 'Lecture Seule'
    ROUser = new User(
      UserName = 'ro@sharinpixlightning1.com',
      FirstName = 'Test-FName',
      LastName = 'Test-LName',
      Alias = 'test',
      Email = 'ro@sharinpixlightning1.com',
      EmailEncodingKey = 'UTF-8',
      LanguageLocaleKey = 'en_US',
      LocalesIdKey = 'en_US',
      TimezonesIdKey = 'America/Los_Angeles',
      ProfileId = ROProfile.Id
    );
    insert ROUser;
    sampleAccount = new Account(Name = 'TestAccount');
    insert sampleAccount;
    sampleContact = new Contact(LastName = 'TestContact', AccountId = sampleAccount.Id);
    insert sampleContact;
  }

  static testMethod void testGetToken_UserWithReadAccess() {
    System.runAs(ROUser) {
      Id id = sampleContact.Id;
      Map<String, Boolean> access = new Map<String, Boolean>();
      access.put('see', true);
      access.put('image_list', true);
      Map<String, Object> album_abilities = new Map<String, Object>();
      album_abilities.put('Access', access);
      Map<String, Object> abilities = new Map<String, Object>();
      abilities.put(id, album_abilities);
      Map<String, Object> params = new Map<String, Object>();
      params.put('user_id', UserInfo.getUserId());
      params.put('email', UserInfo.getUserEmail());
      params.put('abilities', abilities);
      params.put('Id', id);

      Test.startTest();
      String result = SharinPixLightningController.getToken(id, null);
      Test.stopTest();
      System.assertEquals(JSON.serialize(params), result);
    }
  }

  static testMethod void testGetToken_UserWithEditAccess() {
    System.runAs(adminUser) {
      Id id = sampleContact.Id;
      Map<String, Boolean> access = new Map<String, Boolean>();
      access.put('see', true);
      access.put('image_list', true);
      access.put('image_upload', true);
      access.put('image_delete', true);
      access.put('image_crop', true);
      access.put('image_rotate', true);
      Map<String, Object> album_abilities = new Map<String, Object>();
      album_abilities.put('Access', access);
      Map<String, Object> abilities = new Map<String, Object>();
      abilities.put(id, album_abilities);
      Map<String, Object> params = new Map<String, Object>();
      params.put('user_id', UserInfo.getUserId());
      params.put('email', UserInfo.getUserEmail());
      params.put('abilities', abilities);
      params.put('Id', id);

      Test.startTest();
      String result = SharinPixLightningController.getToken(id, null);
      Test.stopTest();
      System.assertEquals(JSON.serialize(params), result);
    }
  }

  static testMethod void testGetTokenCustomPermission() {
    System.runAs(adminUser) {
      Id id = sampleContact.Id;

      SharinPixPermission__c token = new SharinPixPermission__c(Name='Contact', Description__c='Available for contact', Json__c='{"Access": {"see": true}}');
      insert token;

      Map<String, Object> album_abilities = new Map<String, Object>();
      album_abilities = (map<string, object>) Json.deserializeUntyped(token.Json__c);
      Map<String, Object> abilities = new Map<String, Object>();
      abilities.put(id, album_abilities);
      Map<String, Object> params = new Map<String, Object>();
      params.put('user_id', UserInfo.getUserId());
      params.put('email', UserInfo.getUserEmail());
      params.put('abilities', abilities);
      params.put('Id', id);


      Test.startTest();
      String result = SharinPixLightningController.getToken(id, token.Id);
      Test.stopTest();
      System.assertEquals(JSON.serialize(params), result);
    }
  }
}