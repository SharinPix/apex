public with sharing class Image {
	public string album_id;
	public integer width;
	public integer height;
	public string original_url;
	public string full_url;
	public string large_url;
	public string mini_url;
	public string public_id;
	public list<double> gps;
	public double latitude;
	public double longitude;
	public map<string, string> thumbnails;

	public void populate(){
		full_url = thumbnails.get('full');
		large_url = thumbnails.get('large');
		mini_url = thumbnails.get('mini');
		if (gps != null){
			latitude = gps[0];
			longitude = gps[1];
		}

	}

	public Object getX(string param_name){
		String json_instance = Json.serialize(this);
		Map<String, Object> untyped_instance;
		untyped_instance= (Map<String, Object>)JSON.deserializeUntyped(json_instance);
		return untyped_instance.get(param_name);
	}
}