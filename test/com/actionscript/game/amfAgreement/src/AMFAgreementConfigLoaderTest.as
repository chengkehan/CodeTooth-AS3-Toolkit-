package
{
	import com.codeTooth.actionscript.game.amfAgreement.AMFAgreement;
	import com.codeTooth.actionscript.game.amfAgreement.AMFAgreementConfigParser;
	import com.codeTooth.actionscript.game.amfAgreement.AMFAgreementEvent;
	import com.codeTooth.actionscript.game.amfAgreement.AMFAgreementURLConfigLoader;
	import com.codeTooth.actionscript.lang.utils.Common;
	
	import flashx.textLayout.debug.assert;
	
	import org.flexunit.asserts.assertTrue;
	import org.flexunit.async.Async;

	public class AMFAgreementConfigLoaderTest
	{
		private static var _amfAgreement:AMFAgreement = null;
		
		public function AMFAgreementConfigLoaderTest()
		{
		}
		
		// 通过配置文件加载协议
		[Test(order=1, async)]
		public function loadAMFAgreementTest():void
		{
			_amfAgreement = new AMFAgreement();
			Async.handleEvent(this, _amfAgreement, AMFAgreementEvent.COMPLETE, loadAMFAgreementCompleteHandler);
			_amfAgreement.load(new AMFAgreementURLConfigLoader(new AMFAgreementConfigParser(), Common.NEW_LINE), "amfAgreementConfig.txt");
		}
		private function loadAMFAgreementCompleteHandler(...args):void
		{
			trace("Load amf agreement config complete!");
		}
		
		// 判断加载到的协议是否正确
		[Test(order=2)]
		public function printAMFAgreements():void
		{
			var items:Array = _amfAgreement.getAMFAgreements();
			assertTrue(
				items.length == 4 && items[0] == null && items[1] != null && items[2] != null && items[3] != null, 
				items[1].id == "Module1" && items[1].command == "command1" && items[1].isStatic && !items[1].isSingle, 
				items[2].id == "Module2" && items[2].command == "command2" && items[2].isStatic && !items[2].isSingle, 
				items[3].id == "Module3" && items[3].command == "command3" && items[3].isStatic && !items[3].isSingle
			);
		}
	}
}