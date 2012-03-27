package
{
	import com.codeTooth.actionscript.game.amfAgreement.AMFAgreement;
	import com.codeTooth.actionscript.game.amfAgreement.AMFAgreementEvent;
	import com.codeTooth.actionscript.game.amfAgreement.AMFAgreementURLQueueLoader;
	import com.codeTooth.actionscript.game.amfAgreement.AMFAgreementXMLQueueParser;
	
	import org.flexunit.asserts.assertTrue;
	import org.flexunit.async.Async;

	public class AMFAgreementURLQueueLoaderTest
	{
		private static var _amfAgreement:AMFAgreement = null;
		
		public function AMFAgreementURLQueueLoaderTest()
		{
		}
		
		// 加载协议队列
		[Test(order=1, async)]
		public function loadAMFAgreement():void
		{
			_amfAgreement = new AMFAgreement();
			Async.handleEvent(this, _amfAgreement, AMFAgreementEvent.COMPLETE, loadAMFAgreementCompleteHandler);
			_amfAgreement.load(
				new AMFAgreementURLQueueLoader(new AMFAgreementXMLQueueParser()), 
				Vector.<String>(["amfAgreement1.xml", "amfAgreement2.xml", "amfAgreement3.xml"]));
		}
		private function loadAMFAgreementCompleteHandler(...args):void
		{
			trace("Load amf xml queue complete!");
		}
		
		// 判断加载到的协议是否正确
		[Test(order=2)]
		public function printAgreements():void
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