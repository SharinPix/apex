# Abstract

## Move a Salesforce attachment into a SharinPix image

Having the ability to preview attachment of type image would be great but being able to move these attachments would be unbelievable. SharinPix has this functionality ready to configure.

## Implementation Steps

Apex controller (with API version 35)

```java
public class SharinPixDemoAttachmentUpload {

    public static void uploadAttachment(list<Attachment> attachmentList, set<id> emailMsgIdSet){
        map<Id, Id> caseIdMap = new map<Id, Id>();
        for(EmailMessage email: [select id, parentId from EmailMessage where Id in :emailMsgIdSet]){
            caseIdMap.put(email.id, email.parentId);
        }

        for(Attachment att: attachmentList){
            upload_photo(att.id, caseIdMap.get(att.parentId));
        }
    }

    @future (callout=true)
    public static void upload_photo(string attachmentId, string caseId){
        SharinPix.Client clientInstance = SharinPix.Client.getInstance();
        if (clientInstance!=null){
            clientInstance.upload_attachment(attachmentId, caseId);
        }
        else {
            system.debug('### Error occurred');
        }
    }
}
```


Apex Trigger:

```java
trigger AttachmentAfterInsert on Attachment (after insert) {

    list<Attachment> attachmentList = new list<Attachment>();
    set<id> emailMsgIdSet = new set<id>();

    for(Attachment att: trigger.new){
        if (string.valueof(att.parentId).startsWith('02s') && att.contentType == 'image/jpeg'){
            attachmentList.add(att);
            emailMsgIdSet.add(att.parentId);
        }
    }

    if (!attachmentList.isEmpty()){
        SharinPixDemoAttachmentUpload.uploadAttachment(attachmentList, emailMsgIdSet);
    }
}
```


The code snippet below does the magic.

```java
SharinPix.Client clientInstance = SharinPix.Client.getInstance();
clientInstance.upload_attachment(attachmentId, albumId);
```

“attachmentId” is the attachment you want to upload to SharinPix

“albumId” is the id of the record on which you want the image to be displayed
