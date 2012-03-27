package
{
	public class FriendData
	{
		public var name:String = null;
		
		public var age:uint = 0;
		
		public function FriendData(name:String = null, age:uint = 0)
		{
			this.name = name;
			this.age = age;
		}
		
		public function toString():String
		{
			return "[object FriendData(name:" + name + ", age:" + age + ")]";
		}
	}
}