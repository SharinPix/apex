@isTest
private class TagActionController_TEST {
	//SharinPix 20161213


	static map<string, string> responseMap;
	static Account account;
	static Opportunity opportunity;
	static Contact contact;
	static {
		responseMap = new map<string, string>{
			'imageUrl' => '{"id":"f89231e9-d767-49ac-8b6c-77f0247dfc03","created_at":"2016-12-13T07:57:40.018+01:00","user":"644f9574-2ffa-40db-bace-fba46ed0ac46","image":{"public_id":"51432d68-7aea-435e-b1fa-728962e7ea7b","gps":[-20.43166666666667,57.51583333333333],"gps_exifs":[-20.43166666666667,57.51583333333333],"gps_html":null,"created_at":"2016-12-12T11:37:57.798+01:00","width":3024,"height":4032,"rotation":0,"crop_x":0,"crop_y":0,"crop_w":0,"crop_h":0,"metadatas":{},"original_url":"https://res.cloudinary.com/hcdh57m0l/image/authenticated/s--ySnj1lDv--/fl_attachment/v1481539072/lw3mee7ynxbjemwqb85s.jpg","album_id":"0030Y000007yGaxQAE","thumbnails":{"full":"https://res.cloudinary.com/hcdh57m0l/image/authenticated/s--ppRMlHMf--/c_fi…/fl_attachment/dpr_auto,q_auto,f_auto/v1481539072/lw3mee7ynxbjemwqb85s.jpg","large":"https://res.cloudinary.com/hcdh57m0l/image/authenticated/s--vy4-AMc7--/c_fi…/fl_attachment/dpr_auto,q_auto,f_auto/v1481539072/lw3mee7ynxbjemwqb85s.jpg","mini":"https://res.cloudinary.com/hcdh57m0l/image/authenticated/s--AdrsvVHz--/c_fi…/fl_attachment/dpr_auto,q_auto,f_auto/v1481539072/lw3mee7ynxbjemwqb85s.jpg"},"external_urls":{"fill100":"https://res.cloudinary.com/kevan1881/image/authenticated/s--V_8qK17G--/c_fill,h_100,w_100/v1484299303/qjpbaammu9y9qs2pmosi.jpg","fit2000":"https://res.cloudinary.com/kevan1881/image/authenticated/s--dI1tWZLt--/c_fit,h_2000,w_2000/v1484299303/qjpbaammu9y9qs2pmosi.jpg"}},"tag":{"id":"63439302-04da-41ae-bce6-7ad243433b99","created_at":"2016-12-12T11:32:22.941+01:00","name":"main_picture","label":"{}","url":"https://scpix-pr-773.herokuapp.com/public_tags/63439302-04da-41ae-bce6-7ad243433b99","public":false,"listed":true,"action":{"actions":[{"value":"full_url","field_name":"Website","custom_value":""}]}}}',
			'boolean' => '{"id":"f89231e9-d767-49ac-8b6c-77f0247dfc03","created_at":"2016-12-13T07:57:40.018+01:00","user":"644f9574-2ffa-40db-bace-fba46ed0ac46","image":{"public_id":"51432d68-7aea-435e-b1fa-728962e7ea7b","gps":[-20.43166666666667,57.51583333333333],"gps_exifs":[-20.43166666666667,57.51583333333333],"gps_html":null,"created_at":"2016-12-12T11:37:57.798+01:00","width":3024,"height":4032,"rotation":0,"crop_x":0,"crop_y":0,"crop_w":0,"crop_h":0,"metadatas":{},"original_url":"https://res.cloudinary.com/hcdh57m0l/image/authenticated/s--ySnj1lDv--/fl_attachment/v1481539072/lw3mee7ynxbjemwqb85s.jpg","album_id":"0030Y000007yGaxQAE","thumbnails":{"full":"https://res.cloudinary.com/hcdh57m0l/image/authenticated/s--ppRMlHMf--/c_fi…/fl_attachment/dpr_auto,q_auto,f_auto/v1481539072/lw3mee7ynxbjemwqb85s.jpg","large":"https://res.cloudinary.com/hcdh57m0l/image/authenticated/s--vy4-AMc7--/c_fi…/fl_attachment/dpr_auto,q_auto,f_auto/v1481539072/lw3mee7ynxbjemwqb85s.jpg","mini":"https://res.cloudinary.com/hcdh57m0l/image/authenticated/s--AdrsvVHz--/c_fi…/fl_attachment/dpr_auto,q_auto,f_auto/v1481539072/lw3mee7ynxbjemwqb85s.jpg"},"external_urls":{"fill100":"https://res.cloudinary.com/kevan1881/image/authenticated/s--V_8qK17G--/c_fill,h_100,w_100/v1484299303/qjpbaammu9y9qs2pmosi.jpg","fit2000":"https://res.cloudinary.com/kevan1881/image/authenticated/s--dI1tWZLt--/c_fit,h_2000,w_2000/v1484299303/qjpbaammu9y9qs2pmosi.jpg"}},"tag":{"id":"63439302-04da-41ae-bce6-7ad243433b99","created_at":"2016-12-12T11:32:22.941+01:00","name":"main_picture","label":"{}","url":"https://scpix-pr-773.herokuapp.com/public_tags/63439302-04da-41ae-bce6-7ad243433b99","public":false,"listed":true,"action":{"actions":[{"value":"custom","field_name":"IsPrivate","custom_value":"true"}]}}}',
			'textarea' => '{"id":"f89231e9-d767-49ac-8b6c-77f0247dfc03","created_at":"2016-12-13T07:57:40.018+01:00","user":"644f9574-2ffa-40db-bace-fba46ed0ac46","image":{"public_id":"51432d68-7aea-435e-b1fa-728962e7ea7b","gps":[-20.43166666666667,57.51583333333333],"gps_exifs":[-20.43166666666667,57.51583333333333],"gps_html":null,"created_at":"2016-12-12T11:37:57.798+01:00","width":3024,"height":4032,"rotation":0,"crop_x":0,"crop_y":0,"crop_w":0,"crop_h":0,"metadatas":{},"original_url":"https://res.cloudinary.com/hcdh57m0l/image/authenticated/s--ySnj1lDv--/fl_attachment/v1481539072/lw3mee7ynxbjemwqb85s.jpg","album_id":"0030Y000007yGaxQAE","thumbnails":{"full":"https://res.cloudinary.com/hcdh57m0l/image/authenticated/s--ppRMlHMf--/c_fi…/fl_attachment/dpr_auto,q_auto,f_auto/v1481539072/lw3mee7ynxbjemwqb85s.jpg","large":"https://res.cloudinary.com/hcdh57m0l/image/authenticated/s--vy4-AMc7--/c_fi…/fl_attachment/dpr_auto,q_auto,f_auto/v1481539072/lw3mee7ynxbjemwqb85s.jpg","mini":"https://res.cloudinary.com/hcdh57m0l/image/authenticated/s--AdrsvVHz--/c_fi…/fl_attachment/dpr_auto,q_auto,f_auto/v1481539072/lw3mee7ynxbjemwqb85s.jpg"},"external_urls":{"fill100":"https://res.cloudinary.com/kevan1881/image/authenticated/s--V_8qK17G--/c_fill,h_100,w_100/v1484299303/qjpbaammu9y9qs2pmosi.jpg","fit2000":"https://res.cloudinary.com/kevan1881/image/authenticated/s--dI1tWZLt--/c_fit,h_2000,w_2000/v1484299303/qjpbaammu9y9qs2pmosi.jpg"}},"tag":{"id":"63439302-04da-41ae-bce6-7ad243433b99","created_at":"2016-12-12T11:32:22.941+01:00","name":"main_picture","label":"{}","url":"https://scpix-pr-773.herokuapp.com/public_tags/63439302-04da-41ae-bce6-7ad243433b99","public":false,"listed":true,"action":{"actions":[{"value":"custom","field_name":"Description","custom_value":"This is a test"}]}}}',
			'currency' => '{"id":"f89231e9-d767-49ac-8b6c-77f0247dfc03","created_at":"2016-12-13T07:57:40.018+01:00","user":"644f9574-2ffa-40db-bace-fba46ed0ac46","image":{"public_id":"51432d68-7aea-435e-b1fa-728962e7ea7b","gps":[-20.43166666666667,57.51583333333333],"gps_exifs":[-20.43166666666667,57.51583333333333],"gps_html":null,"created_at":"2016-12-12T11:37:57.798+01:00","width":3024,"height":4032,"rotation":0,"crop_x":0,"crop_y":0,"crop_w":0,"crop_h":0,"metadatas":{},"original_url":"https://res.cloudinary.com/hcdh57m0l/image/authenticated/s--ySnj1lDv--/fl_attachment/v1481539072/lw3mee7ynxbjemwqb85s.jpg","album_id":"0030Y000007yGaxQAE","thumbnails":{"full":"https://res.cloudinary.com/hcdh57m0l/image/authenticated/s--ppRMlHMf--/c_fi…/fl_attachment/dpr_auto,q_auto,f_auto/v1481539072/lw3mee7ynxbjemwqb85s.jpg","large":"https://res.cloudinary.com/hcdh57m0l/image/authenticated/s--vy4-AMc7--/c_fi…/fl_attachment/dpr_auto,q_auto,f_auto/v1481539072/lw3mee7ynxbjemwqb85s.jpg","mini":"https://res.cloudinary.com/hcdh57m0l/image/authenticated/s--AdrsvVHz--/c_fi…/fl_attachment/dpr_auto,q_auto,f_auto/v1481539072/lw3mee7ynxbjemwqb85s.jpg"},"external_urls":{"fill100":"https://res.cloudinary.com/kevan1881/image/authenticated/s--V_8qK17G--/c_fill,h_100,w_100/v1484299303/qjpbaammu9y9qs2pmosi.jpg","fit2000":"https://res.cloudinary.com/kevan1881/image/authenticated/s--dI1tWZLt--/c_fit,h_2000,w_2000/v1484299303/qjpbaammu9y9qs2pmosi.jpg"}},"tag":{"id":"63439302-04da-41ae-bce6-7ad243433b99","created_at":"2016-12-12T11:32:22.941+01:00","name":"main_picture","label":"{}","url":"https://scpix-pr-773.herokuapp.com/public_tags/63439302-04da-41ae-bce6-7ad243433b99","public":false,"listed":true,"action":{"actions":[{"value":"custom","field_name":"AnnualRevenue","custom_value":"1000"}]}}}',
			'percent' => '{"id":"f89231e9-d767-49ac-8b6c-77f0247dfc03","created_at":"2016-12-13T07:57:40.018+01:00","user":"644f9574-2ffa-40db-bace-fba46ed0ac46","image":{"public_id":"51432d68-7aea-435e-b1fa-728962e7ea7b","gps":[-20.43166666666667,57.51583333333333],"gps_exifs":[-20.43166666666667,57.51583333333333],"gps_html":null,"created_at":"2016-12-12T11:37:57.798+01:00","width":3024,"height":4032,"rotation":0,"crop_x":0,"crop_y":0,"crop_w":0,"crop_h":0,"metadatas":{},"original_url":"https://res.cloudinary.com/hcdh57m0l/image/authenticated/s--ySnj1lDv--/fl_attachment/v1481539072/lw3mee7ynxbjemwqb85s.jpg","album_id":"0030Y000007yGaxQAE","thumbnails":{"full":"https://res.cloudinary.com/hcdh57m0l/image/authenticated/s--ppRMlHMf--/c_fi…/fl_attachment/dpr_auto,q_auto,f_auto/v1481539072/lw3mee7ynxbjemwqb85s.jpg","large":"https://res.cloudinary.com/hcdh57m0l/image/authenticated/s--vy4-AMc7--/c_fi…/fl_attachment/dpr_auto,q_auto,f_auto/v1481539072/lw3mee7ynxbjemwqb85s.jpg","mini":"https://res.cloudinary.com/hcdh57m0l/image/authenticated/s--AdrsvVHz--/c_fi…/fl_attachment/dpr_auto,q_auto,f_auto/v1481539072/lw3mee7ynxbjemwqb85s.jpg"},"external_urls":{"fill100":"https://res.cloudinary.com/kevan1881/image/authenticated/s--V_8qK17G--/c_fill,h_100,w_100/v1484299303/qjpbaammu9y9qs2pmosi.jpg","fit2000":"https://res.cloudinary.com/kevan1881/image/authenticated/s--dI1tWZLt--/c_fit,h_2000,w_2000/v1484299303/qjpbaammu9y9qs2pmosi.jpg"}},"tag":{"id":"63439302-04da-41ae-bce6-7ad243433b99","created_at":"2016-12-12T11:32:22.941+01:00","name":"main_picture","label":"{}","url":"https://scpix-pr-773.herokuapp.com/public_tags/63439302-04da-41ae-bce6-7ad243433b99","public":false,"listed":true,"action":{"actions":[{"value":"custom","field_name":"Probability","custom_value":"1"}]}}}',
			'integer' => '{"id":"f89231e9-d767-49ac-8b6c-77f0247dfc03","created_at":"2016-12-13T07:57:40.018+01:00","user":"644f9574-2ffa-40db-bace-fba46ed0ac46","image":{"public_id":"51432d68-7aea-435e-b1fa-728962e7ea7b","gps":[-20.43166666666667,57.51583333333333],"gps_exifs":[-20.43166666666667,57.51583333333333],"gps_html":null,"created_at":"2016-12-12T11:37:57.798+01:00","width":300,"height":400,"rotation":0,"crop_x":0,"crop_y":0,"crop_w":0,"crop_h":0,"metadatas":{},"original_url":"https://res.cloudinary.com/hcdh57m0l/image/authenticated/s--ySnj1lDv--/fl_attachment/v1481539072/lw3mee7ynxbjemwqb85s.jpg","album_id":"0030Y000007yGaxQAE","thumbnails":{"full":"https://res.cloudinary.com/hcdh57m0l/image/authenticated/s--ppRMlHMf--/c_fi…/fl_attachment/dpr_auto,q_auto,f_auto/v1481539072/lw3mee7ynxbjemwqb85s.jpg","large":"https://res.cloudinary.com/hcdh57m0l/image/authenticated/s--vy4-AMc7--/c_fi…/fl_attachment/dpr_auto,q_auto,f_auto/v1481539072/lw3mee7ynxbjemwqb85s.jpg","mini":"https://res.cloudinary.com/hcdh57m0l/image/authenticated/s--AdrsvVHz--/c_fi…/fl_attachment/dpr_auto,q_auto,f_auto/v1481539072/lw3mee7ynxbjemwqb85s.jpg"},"external_urls":{"fill100":"https://res.cloudinary.com/kevan1881/image/authenticated/s--V_8qK17G--/c_fill,h_100,w_100/v1484299303/qjpbaammu9y9qs2pmosi.jpg","fit2000":"https://res.cloudinary.com/kevan1881/image/authenticated/s--dI1tWZLt--/c_fit,h_2000,w_2000/v1484299303/qjpbaammu9y9qs2pmosi.jpg"}},"tag":{"id":"63439302-04da-41ae-bce6-7ad243433b99","created_at":"2016-12-12T11:32:22.941+01:00","name":"main_picture","label":"{}","url":"https://scpix-pr-773.herokuapp.com/public_tags/63439302-04da-41ae-bce6-7ad243433b99","public":false,"listed":true,"action":{"actions":[{"value":"width","field_name":"NumberOfEmployees","custom_value":""}]}}}',
			'geolocation' => '{"id":"f89231e9-d767-49ac-8b6c-77f0247dfc03","created_at":"2016-12-13T07:57:40.018+01:00","user":"644f9574-2ffa-40db-bace-fba46ed0ac46","image":{"public_id":"51432d68-7aea-435e-b1fa-728962e7ea7b","gps":[-20.43166666666667,57.51583333333333],"gps_exifs":[-20.43166666666667,57.51583333333333],"gps_html":null,"created_at":"2016-12-12T11:37:57.798+01:00","width":300,"height":400,"rotation":0,"crop_x":0,"crop_y":0,"crop_w":0,"crop_h":0,"metadatas":{},"original_url":"https://res.cloudinary.com/hcdh57m0l/image/authenticated/s--ySnj1lDv--/fl_attachment/v1481539072/lw3mee7ynxbjemwqb85s.jpg","album_id":"0030Y000007yGaxQAE","thumbnails":{"full":"https://res.cloudinary.com/hcdh57m0l/image/authenticated/s--ppRMlHMf--/c_fi…/fl_attachment/dpr_auto,q_auto,f_auto/v1481539072/lw3mee7ynxbjemwqb85s.jpg","large":"https://res.cloudinary.com/hcdh57m0l/image/authenticated/s--vy4-AMc7--/c_fi…/fl_attachment/dpr_auto,q_auto,f_auto/v1481539072/lw3mee7ynxbjemwqb85s.jpg","mini":"https://res.cloudinary.com/hcdh57m0l/image/authenticated/s--AdrsvVHz--/c_fi…/fl_attachment/dpr_auto,q_auto,f_auto/v1481539072/lw3mee7ynxbjemwqb85s.jpg"},"external_urls":{"fill100":"https://res.cloudinary.com/kevan1881/image/authenticated/s--V_8qK17G--/c_fill,h_100,w_100/v1484299303/qjpbaammu9y9qs2pmosi.jpg","fit2000":"https://res.cloudinary.com/kevan1881/image/authenticated/s--dI1tWZLt--/c_fit,h_2000,w_2000/v1484299303/qjpbaammu9y9qs2pmosi.jpg"}},"tag":{"id":"63439302-04da-41ae-bce6-7ad243433b99","created_at":"2016-12-12T11:32:22.941+01:00","name":"main_picture","label":"{}","url":"https://scpix-pr-773.herokuapp.com/public_tags/63439302-04da-41ae-bce6-7ad243433b99","public":false,"listed":true,"action":{"actions":[{"value":"gps","field_name":"MailingAddress","custom_value":""}]}}}'
		};



		account = new Account(Name='Sharinpix');
		insert account;

		opportunity = new Opportunity(Name='SharinPix', stageName='Qualification', closeDate=Date.today().addDays(10));
		insert opportunity;

		contact = new Contact(Lastname='SharinPix', Email='test@sharinpix.test');
		insert contact;
	}

	@isTest static void testImageurl() {
		Test.startTest();
		TagActionController.executeCommand(account.Id, responseMap.get('imageUrl'));
		Test.stopTest();

		system.assertEquals([select website from account where id = :account.id].website, 'https://res.cloudinary.com/kevan1881/image/authenticated/s--dI1tWZLt--/c_fit,h_2000,w_2000/v1484299303/qjpbaammu9y9qs2pmosi.jpg');
	}

	//@isTest static void testBoolean() {
	//	Test.startTest();
	//	TagActionController.executeCommand(opportunity.Id, responseMap.get('boolean'));
	//	Test.stopTest();

	//	system.assert([select IsPrivate from opportunity where id = :opportunity.id].IsPrivate);
	//}

	@isTest static void testTextarea() {
		Test.startTest();
		TagActionController.executeCommand(contact.Id, responseMap.get('textarea'));
		Test.stopTest();

		system.assertEquals([select description from contact where Id = :contact.id].description, 'This is a test');
	}

	@isTest static void testCurrency() {
		Test.startTest();
		TagActionController.executeCommand(account.Id, responseMap.get('currency'));
		Test.stopTest();

		System.assertEquals([select AnnualRevenue from Account where Id = :account.id].AnnualRevenue, 1000);
	}

	@isTest static void testPercent() {
		Test.startTest();
		TagActionController.executeCommand(opportunity.Id, responseMap.get('percent'));
		Test.stopTest();

		system.assertEquals([select Probability from opportunity where id = :opportunity.id].Probability, 1);
	}

	@isTest static void testNumber() {
		Test.startTest();
		TagActionController.executeCommand(account.Id, responseMap.get('integer'));
		Test.stopTest();

		System.assertEquals([select NumberOfEmployees from Account where Id = :account.id].NumberOfEmployees, 300);
	}

	@isTest static void testGeolocation() {
		Test.startTest();
		TagActionController.executeCommand(contact.Id, responseMap.get('geolocation'));
		Test.stopTest();

		Contact cont = [Select MailingLatitude, MailingLongitude from Contact where Id = :contact.id];

		system.assertEquals(cont.MailingLatitude, -20.43166666666667);
		system.assertEquals(cont.MailingLongitude, 57.51583333333333);
	}

	@isTest static void testLightning_number() {
		Test.startTest();
		SharinPixLightningController.executeCommandLightning(account.Id, responseMap.get('integer'));
		Test.stopTest();

		System.assertEquals([select NumberOfEmployees from Account where Id = :account.id].NumberOfEmployees, 300);
	}
}