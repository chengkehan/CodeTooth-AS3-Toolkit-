package
{
	import com.codeTooth.actionscript.game.amfAgreement.AMFAgreement;
	import com.codeTooth.actionscript.game.amfAgreement.AMFAgreementEvent;
	import com.codeTooth.actionscript.game.amfAgreement.AMFAgreementItem;
	import com.codeTooth.actionscript.game.amfAgreement.AMFAgreementXMLLoader;
	import com.codeTooth.actionscript.game.amfAgreement.AMFAgreementXMLParser;
	
	import flash.system.ApplicationDomain;
	import flash.utils.ByteArray;
	
	import org.flexunit.asserts.assertFalse;
	import org.flexunit.asserts.assertTrue;
	import org.flexunit.async.Async;

	public class AMFAgreementMainTest
	{
		private static var _amfAgreement:AMFAgreement = null;
		
		public function AMFAgreementMainTest()
		{
		}
		
		// 加载协议
		[Test(order=1, async)]
		public function loadAMFAgreementTest():void
		{
			_amfAgreement = new AMFAgreement();
			Async.handleEvent(this, _amfAgreement, AMFAgreementEvent.COMPLETE, loadAMfAgreementCompleteHandler);
			_amfAgreement.load(new AMFAgreementXMLLoader(new AMFAgreementXMLParser()), new XML(
				<amfAgreements>
					<amfAgreement id="1" module="AMFAgreementMainTest" command="agreementExecute" isStatic="true" isSingle="false" description="备注"/>
				</amfAgreements>
			));
		}
		private function loadAMfAgreementCompleteHandler(...args):void
		{
			trace("Initialize amf agreement complete!");
		}
		
		// 判断是否存在指定的协议
		[Test(order=2)]
		public function containsAMFAgreementTest():void
		{
			assertTrue(_amfAgreement.containsAMFAgreement(1));
		}
		[Test(order=2)]
		public function notContainsAMFAgreementTest():void
		{
			assertFalse(_amfAgreement.containsAMFAgreement(2));
		}
		[Test(order=2)]
		public function containsAMFAgreementTest2():void
		{
			assertTrue(_amfAgreement.getAMFAgreement(1) != null);
		}
		[Test(order=2)]
		public function notContainsAMFAgreementTest2():void
		{
			assertTrue(_amfAgreement.getAMFAgreement(2) == null);
		}
		
		// 设定协议运行所在的应用程序域
		[Test(order=3)]
		public function setApplicationDomainTest():void
		{
			_amfAgreement.setApplicationDomain(ApplicationDomain.currentDomain);
		}
		
		// 获得协议
		[Test(order=4)]
		public function getAMFAgreementTest():void
		{
			var item:AMFAgreementItem = _amfAgreement.getAMFAgreement(1);
			assertTrue(
				item.id == 1 && item.module == "AMFAgreementMainTest" && item.command == "agreementExecute" && 
				item.isStatic && !item.isSingle
			);
		}
		[Test(order=4)]
		public function getAMFAgreementsTest():void
		{
			var items:Array = _amfAgreement.getAMFAgreements();
			assertTrue(
				items != null && items.length == 2 && items[0] == null && items[1] != null && 
				items[1].id == 1 && items[1].module == "AMFAgreementMainTest" && items[1].command == "agreementExecute" && 
				items[1].isStatic && !items[1].isSingle
			);
		}
		
		// 封包、解包协议
		[Test(order=5)]
		public function packUnpackAgreementTest():void
		{
			var role:Object = new Object();
			role.name = "jim";
			role.age = 24;
			
			var buffer:ByteArray = new ByteArray();
			_amfAgreement.packAMFAgreement(1, buffer, role);
			
			buffer.position = 0;
			var amfRole:Object = _amfAgreement.unpackAMFAgreement(buffer);
			assertTrue(amfRole.name == "jim" && amfRole.age == 24);
		}
		
		// 执行协议
		[Test(order=6)]
		public function executeAgreementTest():void
		{
			var role:Object = new Object();
			role.name = "coco";
			role.age = 25;
			
			var buffer:ByteArray = new ByteArray();
			_amfAgreement.packAMFAgreement(1, buffer, role);
			
			buffer.position = 0;
			_amfAgreement.executeAMFAgreement(buffer);
		}
		public static function agreementExecute(role:Object):void
		{
			assertTrue(role.name == "coco" && role.age == 25);
		}
		
		// 销毁
		[Test(order=7)]
		public function destroyTest():void
		{
			_amfAgreement.destroy();
			_amfAgreement = null;
		}
	}
}