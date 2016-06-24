public with sharing class SharinPixSampleController {
    public String parameters { get; set; }

    public SharinPixSampleController(ApexPages.standardController controller) {
        Id id = controller.getId();

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
        params.put('abilities', abilities);

        params.put('Id', id);
        parameters = JSON.serialize(params);
    }
}