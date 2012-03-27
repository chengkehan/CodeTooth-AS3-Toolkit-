package
{
	import com.codeTooth.actionscript.game.agreement.Agreement;
	import com.codeTooth.actionscript.game.agreement.AgreementEvent;
	import com.codeTooth.actionscript.game.agreement.AgreementXMLLoader;
	import com.codeTooth.actionscript.game.agreement.AgreementXMLParser;
	
	import org.flexunit.async.Async;

	public class AgreementXMLLoaderTest
	{
		private static var _agreement:Agreement = null;
		
		[Embed(source="agreement.xml", mimeType="application/octet-stream")]
		private var agreementXMLBytes:Class;
		
		public function AgreementXMLLoaderTest()
		{
		}
		
		// 加载协议XML
		[Test(order=1, async)]
		public function loadAgreementTest():void
		{
			_agreement = new Agreement();
			Async.handleEvent(this, _agreement, AgreementEvent.COMPLETE, loadAgreementComplateHandler);
			_agreement.load(new AgreementXMLLoader(new AgreementXMLParser()), new XML(new agreementXMLBytes().toString()));
		}
		private function loadAgreementComplateHandler(...args):void
		{
			trace("Load agreement xmlLoader complete!");
		}
		
		// TestBody
		include "AgreementTestInclude.as"
	}
}