package
{
	import com.codeTooth.actionscript.game.amfAgreement.AMFAgreement;
	import com.codeTooth.actionscript.game.amfAgreement.AMFAgreementEvent;
	import com.codeTooth.actionscript.game.amfAgreement.AMFAgreementXMLQueueLoader;
	import com.codeTooth.actionscript.game.amfAgreement.AMFAgreementXMLQueueParser;
	
	import org.flexunit.asserts.assertTrue;
	import org.flexunit.async.Async;

	public class AMFAgreementXMLQueueLoaderTest
	{
		private static var _amfAgreement:AMFAgreement = null;
		
		public function AMFAgreementXMLQueueLoaderTest()
		{
		}
		
		// 通过XML队列来加载协议
		[Test(order=1, async)]
		public function loadAMFAgreementTest():void
		{
			_amfAgreement = new AMFAgreement();
			Async.handleEvent(this, _amfAgreement, AMFAgreementEvent.COMPLETE, loadAMFAgreementCompleteHandler);
			_amfAgreement.load(
				new AMFAgreementXMLQueueLoader(new AMFAgreementXMLQueueParser()), 
				Vector.<XML>
				([
					new XML
					(
						<amfAgreements>
							<amfAgreement id="1" module="Module1" command="command1" isStatic="true" isSingle="false" description="备注"/>
						</amfAgreements>
					), 
					new XML
					(
						<amfAgreements>
							<amfAgreement id="2" module="Module2" command="command2" isStatic="true" isSingle="false" description="备注"/>
						</amfAgreements>
					), 
					new XML
					(
						<amfAgreements>
							<amfAgreement id="3" module="Module3" command="command3" isStatic="true" isSingle="false" description="备注"/>
						</amfAgreements>
					)
				])
			);
		}
		private function loadAMFAgreementCompleteHandler(...args):void
		{
			trace("Load amf agreement xml queue complete!");
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