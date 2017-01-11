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
		img.thumbnails = new map<string, string>{'mini'=>'mini_url', 'large'=>'large_url', 'full'=>'full_large'};
		img.gps = new list<double>{-20.22, 50.1234};
		img.populate();

		tagImg.image = img;

		object full_url = img.getX('full_url');

		system.assertEquals(string.valueof('full_url'), 'full_url');
	}
}