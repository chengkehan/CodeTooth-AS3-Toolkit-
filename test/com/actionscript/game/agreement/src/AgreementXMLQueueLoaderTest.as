package
{
	import com.codeTooth.actionscript.game.agreement.Agreement;
	import com.codeTooth.actionscript.game.agreement.AgreementEvent;
	import com.codeTooth.actionscript.game.agreement.AgreementXMLQueueLoader;
	import com.codeTooth.actionscript.game.agreement.AgreementXMLQueueParser;
	
	import org.flexunit.async.Async;

	public class AgreementXMLQueueLoaderTest
	{
		private static var _agreement:Agreement = null;
		
		[Embed(source="agreement.xml", mimeType="application/octet-stream")]
		private var agreementXMLBytes:Class;
		
		public function AgreementXMLQueueLoaderTest()
		{
		}
		
		// 加载协议
		[Test(order=1, async)]
		public function loadAgreementTest():void
		{
			_agreement = new Agreement();
			Async.handleEvent(this, _agreement, AgreementEvent.COMPLETE, loadAgreementCompleteHandler);
			_agreement.load(new AgreementXMLQueueLoader(new AgreementXMLQueueParser()), Vector.<XML>([new XML(new agreementXMLBytes().toString())]));
		}
		
		private function loadAgreementCompleteHandler(...args):void
		{
			trace("Load agreement xmlQueueLoader complete");
		}
		
		// TestBody
		include "AgreementTestInclude.as"
	}
}