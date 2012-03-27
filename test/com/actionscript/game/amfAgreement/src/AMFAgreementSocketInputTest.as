package
{
	import com.codeTooth.actionscript.game.amfAgreement.AMFAgreement;
	import com.codeTooth.actionscript.game.amfAgreement.AMFAgreementEvent;
	import com.codeTooth.actionscript.game.amfAgreement.AMFAgreementSocketInput;
	import com.codeTooth.actionscript.game.amfAgreement.AMFAgreementURLLoader;
	import com.codeTooth.actionscript.game.amfAgreement.AMFAgreementXMLParser;
	
	import flash.utils.ByteArray;
	
	import org.flexunit.async.Async;

	public class AMFAgreementSocketInputTest
	{
		private static var _amfAgreement:AMFAgreement = null;
		
		private static var _socketInput:AMFAgreementSocketInput = null;
		
		public function AMFAgreementSocketInputTest()
		{
		}
		
		[Test(order=1, async)]
		public function loadAMFAgreement():void
		{
			_amfAgreement = new AMFAgreement();
			_socketInput = new AMFAgreementSocketInput(_amfAgreement.executeAMFAgreement);
			
			Async.handleEvent(this, _amfAgreement, AMFAgreementEvent.COMPLETE, loadAMFAgreementCompleteHandler);
			_amfAgreement.load(new AMFAgreementURLLoader(new AMFAgreementXMLParser()), "amfAgreement.xml");
		}
		
		private function loadAMFAgreementCompleteHandler(...args):void
		{
			trace("loadAMFAgreementCompleteHandler");
		}
		
		[Test(order=2)]
		public function executeAMFAgreement():void
		{
			TestModule;
			
			var role:Object = new Object();
			role.name = "jim";
			role.age = 24;
			
			var buffer:ByteArray = _amfAgreement.packAMFAgreement(1, new ByteArray(), role);
			_amfAgreement.packAMFAgreement(1, buffer, role);
			
			buffer.position = 0;
			_socketInput.input(buffer);
			trace("buffer length: " + buffer.length);
		}
	}
}