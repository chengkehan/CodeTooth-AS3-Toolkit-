package
{
	import com.codeTooth.actionscript.game.agreement.Agreement;
	import com.codeTooth.actionscript.game.agreement.AgreementEvent;
	import com.codeTooth.actionscript.game.agreement.AgreementURLQueueLoader;
	import com.codeTooth.actionscript.game.agreement.AgreementXMLQueueParser;
	
	import org.flexunit.async.Async;

	public class AgreementURLQueueLoaderTest
	{
		private static var _agreement:Agreement = null;
		
		public function AgreementURLQueueLoaderTest()
		{
		}
		
		// 加载协议
		[Test(roder=1, async)]
		public function loadAgreementTest():void
		{
			_agreement = new Agreement();
			Async.handleEvent(this, _agreement, AgreementEvent.COMPLETE, loadAgreementCompleteHandler);
			_agreement.load(new AgreementURLQueueLoader(new AgreementXMLQueueParser()), Vector.<String>(["agreement.xml"]));
		}
		private function loadAgreementCompleteHandler(...args):void
		{
			trace("Load agreement queueLoader complete!");
		}
		
		// TestBody
		include "AgreementTestInclude.as"
	}
}