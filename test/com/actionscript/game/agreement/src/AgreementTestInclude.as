import flash.system.ApplicationDomain;
import flash.utils.ByteArray;

import org.flexunit.asserts.assertNotNull;
import org.flexunit.asserts.assertTrue;

// 测试是否包含指定ID的协议
[Test(order=2)]
public function containsAgreementTest():void
{
	assertTrue(_agreement.containsAgreementItem(1));
}
[Test(order=2)]
public function getAgreementTest():void
{
	assertTrue(_agreement.getAgreementItem(1) != null);
}
[Test(order=2)]
public function getAgreementTest2():void
{
	assertTrue(_agreement.getAgreementItem(2) == null);
}

// 获得所有的协议对象
[Test(order=3)]
public function getAgreementsTest():void
{
	var items:Array = _agreement.getAgreementItems();
	AgreementDataCommon.checkAgreementItems(items);
}

// ApplicationDomain
[Test(order=4)]
public function applicationDomainTest():void
{
	var appDomain:ApplicationDomain = _agreement.getApplicationDomain();
	assertNotNull(appDomain);
}
[Test(order=4)]
public function applicationDomainTest2():void
{
	_agreement.setApplicationDomain(null);
}
[Test(order=4)]
public function applicationDomainTest3():void
{
	_agreement.setApplicationDomain(ApplicationDomain.currentDomain);
}

// 封包、解包
[Test(order=5)]
public function packUnpackAgreementTest():void
{
	var role:RoleData = AgreementDataCommon.getRoleData();
	
	var buffer:ByteArray = new ByteArray();
	_agreement.packAgreement(buffer, 1, role);
	
	buffer.position = 0;
	var newRole:RoleData = _agreement.unpackAgreement(buffer);
	AgreementDataCommon.checkRole(newRole);
}

// 执行协议
[Test(order=6)]
public function executeAgreement():void
{
	AgreementExecute;
	
	var role:RoleData = AgreementDataCommon.getRoleData();
	
	var buffer:ByteArray = new ByteArray();
	_agreement.packAgreement(buffer, 1, role);
	
	buffer.position = 0;
	_agreement.executeAgreement(buffer);
}

// 销毁
[Test(order=7)]
public function destroyTest():void
{
	_agreement.destroy();
}