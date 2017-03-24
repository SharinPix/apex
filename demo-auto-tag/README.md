# Adding tags to your uploaded images automatically (auto-tag)

SharinPix allows you to add tags to your images as they are uploaded. These can be configured from the admin dashboard under organization settings.
To reach the administration dashboard, go to the SharinPix Settings tab and click on the “Go to administration dashboard” button. You will be taken to the SharinPix website; log in with your Salesforce account if you are not already. Head to the “Settings” page (select it from the top bar). Click the “Edit Organization” button on the top-right. 
Under the Tags section, for “Auto-tag” select the tag to be applied by default on all newly uploaded images.
Finally, click on Update Organization to save your changes.

## Implementation Steps

Alternatively, you can also implement the auto-tag feature for selected albums instead of adding it to your whole organization’s albums. The following code adds the “Sea” tag to all images uploaded using this component.
If any tag specified in the “auto_tag” parameter is not already present on SharinPix, the user will get an “Access Denied” message if he does not have the rights to create tags. To give a user the ability to create new tags, uncomment the ```/*'create' => true,*/``` line. Note that it is better to create the tag yourself first and then add it to auto_tag instead of giving all users the ability to create tags.
Using Apex code, you can also specify multiple tags to be added on new images. This is done by passing a list of string to the parameter. An example of this method is commented.

Apex controller (with API version 38) can be found [here](src/classes/SharinPixDemoAutoTagCtrl.cls).

The Visualforce page (with API version 38) to create is found [here](src/pages/SharinPixDemoAutoTag.page).
