package
{
	import com.codeTooth.actionscript.game.amfAgreement.AMFAgreement;
	import com.codeTooth.actionscript.game.amfAgreement.AMFAgreementEvent;
	import com.codeTooth.actionscript.game.amfAgreement.AMFAgreementURLLoader;
	import com.codeTooth.actionscript.game.amfAgreement.AMFAgreementXMLParser;
	
	import org.flexunit.asserts.assertTrue;
	import org.flexunit.async.Async;

	public class AMFAgreementURLLoaderTest
	{
		private static var _amfAgreement:AMFAgreement = null;
		
		public function AMFAgreementURLLoaderTest()
		{
		}
		
		// 通过url加载协议
		[Test(order=1, async)]
		public function loadAMFAgreementByURLTest():void
		{
			_amfAgreement = new AMFAgreement();
			Async.handleEvent(this, _amfAgreement, AMFAgreementEvent.COMPLETE, loadAMFAgreementCompleteHandler);
			_amfAgreement.load(new AMFAgreementURLLoader(new AMFAgreementXMLParser()), "amfAgreement.xml");
		}
		private function loadAMFAgreementCompleteHandler(...args):void
		{
			trace("Load amf agreement complete!");
		}
		
		// 判断加载的协议是否正确
		[Test(order=2)]
		public function printAgreements():void
		{
			var items:Array = _amfAgreement.getAMFAgreements();
			assertTrue(
				items.length == 2 && items[0] == null && items[1] != null &&  
				items[1].id == 1 && items[1].module == "TestModule" && items[1].command == "execute" && items[1].isStatic && !items[1].isSingle
			);
		}
	}
}