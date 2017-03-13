@isTest
private class TagImageTEST {
	
	@isTest static void testTagImageWrapper() {
		TagImage tagImg = new TagImage();
		tagImg.id = 'tagimageid';
		tagImg.user = 'userid';

		Tag tag = new Tag();
		tag.id = 'tagid';
		tag.label = 'customlabel';
		tag.name = 'tagname';
		Command command = new Command();
		list<Action> actions = new list<Action>();

		Action ac = new Action();
		ac.custom_value = 'custom_value';
		ac.field_name = 'field_name';
		ac.value = 'value';

		actions.add(ac);
		command.actions = actions;
		tag.action = command;

		tagImg.tag = tag;

		Image img = new Image();
		img.external_urls = new map<string, string>{'fill100'=>'mini_url', 'fit2000'=>'large_url'};
		img.gps = new list<double>{-20.22, 50.1234};
		img.populate();

		tagImg.image = img;

		object large_url = img.getX('large_url');

		system.assertEquals(string.valueof('large_url'), 'large_url');
	}
}