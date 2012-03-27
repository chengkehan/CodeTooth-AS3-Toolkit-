package
{
	import com.codeTooth.actionscript.game.agreement.Agreement;
	import com.codeTooth.actionscript.game.agreement.AgreementEvent;
	import com.codeTooth.actionscript.game.agreement.AgreementURLConfigLoader;
	import com.codeTooth.actionscript.game.agreement.AgreementXMLConfigParser;
	import com.codeTooth.actionscript.lang.utils.Common;
	
	import org.flexunit.async.Async;

	public class AgreementConfigLoaderTest
	{
		private static var _agreement:Agreement = null;
		
		public function AgreementConfigLoaderTest()
		{
		}
		
		// 加载协议
		[Test(order=1, async)]
		public function loadAgreementTest():void
		{
			_agreement = new Agreement();
			Async.handleEvent(this, _agreement, AgreementEvent.COMPLETE, loadAgreementCompleteHandler);
			_agreement.load(new AgreementURLConfigLoader(new AgreementXMLConfigParser(), Common.NEW_LINE), "agreementConfig.txt");
		}
		private function loadAgreementCompleteHandler(...args):void
		{
			trace("Load agreement configLoader complete!");
		}
		
		// TestBody
		include "AgreementTestInclude.as"
	}
}