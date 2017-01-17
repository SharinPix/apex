global with sharing class Image {
    public String album_id;
    public Integer width;
    public Integer height;
    public String original_url;
    public String full_url;
    public String mini_url;
    public String public_id;
    public List<Double> gps;
    public Double latitude;
    public Double longitude;
    public map<string, string> external_urls;

    public void populate(){
        full_url = external_urls.get('fit2000');
        mini_url = external_urls.get('fill100');
        if (gps != null){
            latitude = gps[0];
            longitude = gps[1];
        }
    }

    public Object getX(String param_name) {
        String json_instance = JSON.serialize(this);
        Map<String, Object> untyped_instance;
        untyped_instance = (Map<String, Object>)JSON.deserializeUntyped(json_instance);
        return untyped_instance.get(param_name);
    }
}