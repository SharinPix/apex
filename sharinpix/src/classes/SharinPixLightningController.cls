public with sharing class SharinPixLightningController {
  @AuraEnabled
  public static String getToken(String albumId) {
    Id id = albumId;
    Map<String, Boolean> access = new Map<String, Boolean>();
    Map<String, Object> album_abilities = new Map<String, Object>();
    Map<String, Object> abilities = new Map<String, Object>();
    Map<String, Object> params = new Map<String, Object>();
    params.put('user_id', UserInfo.getUserId());

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
    abilities.put(id, album_abilities);
    params.put('abilities', abilities);
    params.put('Id', id);

    if (Test.isRunningTest()) {
      return JSON.serialize(params);
    } else {
      return 'https://app.sharinpix.com/pagelayout/' + id + '?token=' + SharinPix.Client.getInstance().token(params);
    }
  }
}