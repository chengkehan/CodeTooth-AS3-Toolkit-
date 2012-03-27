package
{
	public class RoleData
	{
		public var name:String = null;
		
		public var age:uint = 0;
		
		public var speed:int = 0;
		
		public var num1:Number = 0;
		
		public var num2:Number = 0;
		
		public var value:RoleDataObject = null;
		
		public var friends:Array = null;
		
		public var friends2:Vector.<FriendData> = null;
		
		public function RoleData(name:String = null, age:uint = 0, speed:int = 0, num1:Number = 0, num2:Number = 0)
		{
			this.name = name;
			this.age = age;
			this.speed = speed;
			this.num1 = num1;
			this.num2 = num2;
			value = new RoleDataObject();
			friends = new Array();
			friends2 = new Vector.<FriendData>();
		}
		
		public function toString():String
		{
			return "[object RoleData(name:" + name + ", age:" + age + ", speed:" + speed + ", num1:" + num1 + ", num2:" + num2 + 
				", value.attack:" + value.attack + ", value.defence:" + value.defence + 
				", friends:" + friends + ", friends2:" + friends2 + ")]";
		}
	}
}