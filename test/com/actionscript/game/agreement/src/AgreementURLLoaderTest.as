package
{
	import com.codeTooth.actionscript.game.agreement.Agreement;
	import com.codeTooth.actionscript.game.agreement.AgreementEvent;
	import com.codeTooth.actionscript.game.agreement.AgreementURLLoader;
	import com.codeTooth.actionscript.game.agreement.AgreementXMLParser;
	
	import org.flexunit.async.Async;

	public class AgreementURLLoaderTest
	{
		private static var _agreement:Agreement = null;
		
		public function AgreementURLLoaderTest()
		{
		}
		
		// 加载协议XML
		[Test(order=1, async)]
		public function loadAgreementTest():void
		{
			_agreement = new Agreement();
			Async.handleEvent(this, _agreement, AgreementEvent.COMPLETE, loadAgreementCompleteHandler);
			_agreement.load(new AgreementURLLoader(new AgreementXMLParser()), "agreement.xml");
		}
		private function loadAgreementCompleteHandler(...args):void
		{
			trace("Load agreement urlLLoader complete!");
		}
		
		// TestBody
		include "AgreementTestInclude.as"
	}
}