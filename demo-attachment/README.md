# Move a Salesforce attachment into a SharinPix image

Having the ability to preview attachment of type image would be great but being able to move these attachments would be unbelievable. SharinPix has this functionality ready to configure.

## Implementation Steps

Apex controller (with API version 35) can be found [here](src/classes/SharinPixDemoAttachmentUpload.cls).

The Apex trigger to create is found [here](src/triggers/AttachmentAfterInsert.trigger).

The code snippet below does the magic.

```java
SharinPix.Client clientInstance = SharinPix.Client.getInstance();
clientInstance.upload_attachment(attachmentId, albumId);
```

“attachmentId” is the attachment you want to upload to SharinPix

“albumId” is the id of the record on which you want the image to be displayed