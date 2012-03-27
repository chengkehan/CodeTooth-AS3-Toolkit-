package
{
	import com.codeTooth.actionscript.game.agreement.Agreement;
	import com.codeTooth.actionscript.game.agreement.AgreementEvent;
	import com.codeTooth.actionscript.game.agreement.AgreementSocketInput;
	import com.codeTooth.actionscript.game.agreement.AgreementURLLoader;
	import com.codeTooth.actionscript.game.agreement.AgreementXMLParser;
	
	import flash.utils.ByteArray;
	
	import org.flexunit.async.Async;

	public class AgreementSocketInputTest
	{
		private static var _agreement:Agreement = null;
		
		private static var _socketInput:AgreementSocketInput = null;
		
		public function AgreementSocketInputTest()
		{
		}
		
		[Test(order=1)]
		public function initializeTest():void
		{
			_agreement = new Agreement();
			_socketInput = new AgreementSocketInput(_agreement.executeAgreement);
		}
		
		[Test(order=2, async)]
		public function loadAgreementTest():void
		{
			Async.handleEvent(this, _agreement, AgreementEvent.COMPLETE, loadAgreementCompleteHandler);
			_agreement.load(new AgreementURLLoader(new AgreementXMLParser()), "agreement.xml");
		}
		
		private function loadAgreementCompleteHandler(...args):void
		{
			trace("Load agreement socketInput complete");
		}
		
		[Test(order=3)]
		public function testSocketInput1():void
		{
			var role:RoleData = AgreementDataCommon.getRoleData();
			var buffer:ByteArray = new ByteArray();
			_agreement.packAgreement(buffer, 1, role);
			_agreement.packAgreement(buffer, 1, role);
			
			buffer.position = 0;
			_socketInput.input(buffer);
		}
	}
}