package
{
	import org.flexunit.asserts.assertTrue;

	public class AgreementDataCommon
	{
		public function AgreementDataCommon()
		{
		}
		
		public static function getRoleData():RoleData
		{
			FriendData;
			
			var role:RoleData = new RoleData("jim", 24, 100, 200, 300);
			role.value.attack = 400;
			role.value.defence = 500;
			role.friends.push(new FriendData("coco", 24));
			role.friends.push(new FriendData("li", 25));
			role.friends2.push(new FriendData("coco2", 24));
			role.friends2.push(new FriendData("li2", 25));
			
			return role;
		}
		
		public static function checkRole(role:RoleData):void
		{
			assertTrue(
				role.name == "jim" && role.age == 24 && role.speed == 100 && 
				(role.num1 > 199 && role.num1 < 201) && (role.num2 > 299 && role.num2 < 301) && 
				role.value.attack == 400 && role.value.defence == 500 && 
				role.friends != null && role.friends.length == 2 && role.friends[0] != null && role.friends[1] != null && 
				role.friends[0].name == "coco" && role.friends[0].age == 24 && role.friends[1].name == "li" && role.friends[1].age == 25, 
				role.friends2[0].name == "coco2" && role.friends2[0].age == 24 && role.friends2[1].name == "li2" && role.friends2[1].age == 25 
			);
		}
		
		public static function checkAgreementItems(items:Array):void
		{
			assertTrue(
				items != null && items.length == 2 && items[0] == null && items[1] != null && 
				items[1].head == 0xFF && items[1].id == 1 && items[1].clazz == "AgreementExecute" && items[1].func == "execute" && 
				items[1].isStatic && !items[1].isSingle && items[1].definition == "RoleData"
			);
		}
	}
}