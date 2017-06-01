public with sharing class SharinPixLightningController {
  @AuraEnabled
  public static String getToken(String albumId, string permissionId) {
    Id id = albumId;
    Map<String, Boolean> access = new Map<String, Boolean>();
    Map<String, Object> album_abilities = new Map<String, Object>();
    Map<String, Object> abilities = new Map<String, Object>();
    Map<String, Object> params = new Map<String, Object>();
    params.put('user_id', UserInfo.getUserId());
    params.put('email', UserInfo.getUserEmail());

    SharinPixPermission__c permission;
    if (string.isNotBlank(permissionId)){
      permission = [select Id, Json__c from SharinPixPermission__c where Id = :permissionId Limit 1];
      album_abilities = (map<string, object>) Json.deserializeUntyped(permission.Json__c);
    }
    else {
      List<UserRecordAccess> userRecordAccessList = [SELECT RecordId, HasEditAccess, HasReadAccess
                                                   FROM UserRecordAccess
                                                   WHERE UserId = :UserInfo.getUserId()
                                                     AND RecordId = :id];
      if (!userRecordAccessList.isEmpty()) {
        UserRecordAccess userRecordAccess = userRecordAccessList[0];
        if (userRecordAccess.hasReadAccess){
          access.put('see', true);
          access.put('image_list', true);
        }
        if (userRecordAccess.HasEditAccess) {
          access.put('image_upload', true);
          access.put('image_delete', true);
          access.put('image_crop', true);
          access.put('image_rotate', true);
        }
      }
      album_abilities.put('Access', access);
    }

    abilities.put(id, album_abilities);
    params.put('abilities', abilities);
    params.put('Id', id);

    if (Test.isRunningTest()) {
      return JSON.serialize(params);
    } else {
      Client clientInstance = client.getInstance();
      return 'https://app.sharinpix.com/pagelayout/' + id + '?token=' + clientInstance.token(params);
    }
  }

  /**
   * [executeCommandLightning Executing tag action]
   * @param  albumId [albumId]
   * @param  jsonfile [Tag payload]
   * @return          [description]
   */
  @AuraEnabled
  public static object executeCommandLightning(Id albumId, string jsonfile) {
    SObjectWrapper sobjwrapper = new SObjectWrapper(albumId, jsonfile);
    Database.SaveResult result = sobjwrapper.executeAction();
    if (result == null){
      return false;
    }
    return result.isSuccess();
  }
}