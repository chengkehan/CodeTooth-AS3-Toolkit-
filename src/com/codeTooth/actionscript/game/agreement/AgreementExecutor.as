package com.codeTooth.actionscript.game.agreement
{
	import com.codeTooth.actionscript.lang.exceptions.IllegalParameterException;
	import com.codeTooth.actionscript.lang.exceptions.NullPointerException;
	import com.codeTooth.actionscript.lang.utils.destroy.DestroyUtil;
	import com.codeTooth.actionscript.lang.utils.destroy.IDestroy;
	
	import flash.system.ApplicationDomain;
	import flash.utils.ByteArray;

	/**
	 * @private
	 * 
	 * 协议执行器
	 */
	internal class AgreementExecutor implements IDestroy
	{
		
		public function AgreementExecutor(executeAgreement:Function = null)
		{
			_agreemenetItemInstances = new Array();
			_executeAgreement = executeAgreement;
		}
		
		// 自定义的函数执行器
		private var _executeAgreement:Function = null;
		
		public function getExecuteAgreement():Function
		{
			return _executeAgreement;
		}
		
		// 存储所有单例的协议对象
		private var _agreemenetItemInstances:Array = null;
		
		/**
		 * 执行一条协议
		 * 
		 * @param agreementItem 协议格式对象
		 * @param data 协议的内容
		 * @param appDomain 当前所使用的应用程序域
		 * @param ignoreDefinition 忽略对象的类型
		 * 
		 * @throws com.codeTooth.actionscript.lang.exceptions.NullPointerException 
		 * 传入的agreementItem是null
		 */
		public function execute(agreementItem:AgreementItem, data:ByteArray, appDomain:ApplicationDomain, ignoreDefinition:Boolean):void
		{
			if(agreementItem == null)
			{
				throw new NullPointerException("Null agreementItem");
			}
			
			if(_executeAgreement != null)
			{
				_executeAgreement(agreementItem.id, AgreementReader.read(data, agreementItem, appDomain, ignoreDefinition));
				return;
			}
			
			// 直接调用静态方法
			if(agreementItem.isStatic)
			{
				agreementItem.getClazz()[agreementItem.func](AgreementReader.read(data, agreementItem, appDomain, ignoreDefinition));
			}
			else
			{
				var agreementItemInstance:Object;
				// 如果是单例，就创建一个缓存起来
				if(agreementItem.isSingle)
				{
					if(_agreemenetItemInstances[agreementItem.id] == undefined)
					{
						agreementItemInstance = new (agreementItem.getClazz())();
						_agreemenetItemInstances[agreementItem.id] = agreementItemInstance;
					}
					else
					{
						agreementItemInstance = _agreemenetItemInstances[agreementItem.id];
					}
				}
				// 不是单例每次都创建一个
				else
				{
					agreementItemInstance = new (agreementItem.getClazz())();
				}
				
				// 开始执行协议
				agreementItemInstance[agreementItem.func](AgreementReader.read(data, agreementItem, appDomain, ignoreDefinition));
			}
		}
		
		//----------------------------------------------------------------------------------------------------------------------------------
		// 实现 IDestroy 接口
		//----------------------------------------------------------------------------------------------------------------------------------
		
		public function destroy():void
		{
			DestroyUtil.destroyArray(_agreemenetItemInstances);
			_agreemenetItemInstances = null;
		}
	}
}