# Abstract

Being able to view an image is fascinating but having the possibility to use its metadatas is awesomeness.

SharinPix gives you the possibility to have webhooks setup for several events available from which you can enrich the information on your system.

Such events are:
+ “new image”
+ “new publication”
+ “new provider reply”
+ “new tag image” and
+ “delete image”.

## Implementation Steps

The Apex controller (with API version 36) can be found [here](src/classes/SharinPixDemoWebhook.cls).

The corresponding VisualForce page is found [here](src/pages/SharinPixDemoWebhook.page).

Next, create a Site and give permission to the VisualForce that has been created.  
Ask your SharinPix Administrator to configure the webhook on the Admin interface of SharinPix.