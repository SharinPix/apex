public class SharinPixDemoTags {
    public String parameters { get; set; }
    
    public SharinPixDemoTags(ApexPages.StandardController controller) {
        Id contactId = controller.getId();
        
        Map<String, Boolean> access = new Map<String, Boolean>();
        access.put('see', true);
        access.put('image_list', true);
        access.put('image_upload', true);
        access.put('image_tag', true);
        access.put('image_delete', true);
        
        Map<String, String> cartoon = new Map<String, String>();
        cartoon.put('en', 'Cartoon');
        cartoon.put('fr', 'Déssin Animés');
        
        Map<String, String> building = new Map<String, String>();
        building.put('en', 'Building');
        building.put('fr', 'Bâtiment');
        
        Map<String, Object> tags = new Map<String, Object>();
        tags.put('Cartoon', cartoon);
        tags.put('Building', building);
        
        Map<String, Object> album_abilities = new Map<String, Object>();
        album_abilities.put('Access', access);
        album_abilities.put('Tags', tags);
        
        Map<String, Object> abilities = new Map<String, Object>();
        abilities.put(contactId, album_abilities);
        
        Map<String, Object> params = new Map<String, Object>();
        params.put('abilities', abilities);
  
        parameters = JSON.serialize(params);
    }
}