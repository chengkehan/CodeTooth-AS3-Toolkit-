package
{
	import com.codeTooth.actionscript.lang.utils.Debug;
	
	import org.flexunit.asserts.assertTrue;

	public class TestModule
	{
		public static function execute(role:Object):void
		{
			Debug.printDynamicObject(role);
			assertTrue(role != null && role.name == "jim" && role.age == 24);
		}
	}
}