package com.codeTooth.actionscript.game.amfAgreement
{
	import com.adobe.utils.StringUtil;
	import com.codeTooth.actionscript.lang.exceptions.IllegalOperationException;
	import com.codeTooth.actionscript.lang.exceptions.IllegalParameterException;
	import com.codeTooth.actionscript.lang.exceptions.NoSuchObjectException;
	import com.codeTooth.actionscript.lang.exceptions.NullPointerException;
	import com.codeTooth.actionscript.lang.utils.Common;
	import com.codeTooth.actionscript.lang.utils.destroy.DestroyUtil;
	import com.codeTooth.actionscript.lang.utils.destroy.IDestroy;
	
	import flash.system.ApplicationDomain;

	/**
	 * 所有的AMF协议对象
	 */
	internal class AMFAgreements implements IDestroy
	{
		private var _agreements:Array = null;
		
		/**
		 * 构造函数
		 * 
		 * @param xml AMF协议XML
		 */
		public function AMFAgreements(xml:XML)
		{
			_agreements = new Array();
			validateXML(xml);
			createAgreements(xml);
		}
		
		/**
		 * 创建所有的模块
		 * 
		 * @param appDomain
		 * @param clazzCheck
		 */
		public function createModuleClazzes(appDomain:ApplicationDomain, clazzCheck:Boolean):void
		{
			for each(var agreement:AMFAgreementItem in _agreements)
			{
				if(agreement != null)
				{
					agreement.createModuleClazz(appDomain, clazzCheck);
				}
			}
		}
		
		public function containsAMFAgreement(agreementID:uint):Boolean
		{
			return _agreements[agreementID] != null;
		}
		
		public function getAMFAgreement(agreementID:uint):AMFAgreementItem
		{
			return _agreements[agreementID];
		}
		
		public function getAMFAgreements():Array
		{
			return _agreements;
		}
		
		// 创建所有的协议对象
		private function createAgreements(xml:XML):void
		{
			DestroyUtil.destroyArray(_agreements);
			
			// 遍历XML节点
			var agreementXMLList:XMLList = xml.amfAgreement;
			for each(var agreementXML:XML in agreementXMLList)
			{
				var agreement:AMFAgreementItem = new AMFAgreementItem(
					uint(agreementXML.@id), 
					String(agreementXML.@module), 
					String(agreementXML.@command), 
					agreementXML.@isStatic == undefined ? true : StringUtil.toBoolean(String(agreementXML.@isStatic)), 
					agreementXML.@isSingle == undefined ? true : StringUtil.toBoolean(String(agreementXML.@isSingle))
				);
				
				if(_agreements[agreement.id] != null)
				{
					throw new IllegalOperationException("Has contains the agreement \"" + agreement.id + "\"");
				}
				
				_agreements[agreement.id] = agreement;
			}
		}
		
		// 验证协议XML的结构是否符合要求
		private function validateXML(xml:XML):void
		{
			if(xml == null)
			{
				throw new NullPointerException("Null amfAgreementXML");
			}
			
			if(xml.amfAgreement != undefined)
			{
				var agreementXMLList:XMLList = xml.amfAgreement;
				for each(var agreementXML:XML in agreementXMLList)
				{
					// 必须有协议id属性
					if(agreementXML.@id == undefined)
					{
						throw new NoSuchObjectException("Has not the agreement id." + Common.NEW_LINE + agreementXML.toXMLString());
					}
					// 必须有模块属性
					if(agreementXML.@module == undefined)
					{
						throw new NoSuchObjectException("Has not the agreement module." + Common.NEW_LINE + agreementXML.toXMLString());
					}
					// 必须有命令属性
					if(agreementXML.@command == undefined)
					{
						throw new NoSuchObjectException("Has not the agreement command." + Common.NEW_LINE + agreementXML.toXMLString());
					}
					// 协议的id必须小于限定的值
					if(uint(agreementXML.@id) > AMFAgreement.AMF_AGREEMENT_ID_MAX)
					{
						throw new IllegalParameterException(
							"Illegal agreement id \"" + String(agreementXML.@id) + "\". " + 
							"Max id value \"" + AMFAgreement.AMF_AGREEMENT_ID_MAX + "\""
						);
					}
				}
			}
		}
		
		//----------------------------------------------------------------------------------------------------------------------------------
		// 实现 IDestroy 接口
		//----------------------------------------------------------------------------------------------------------------------------------
		
		public function destroy():void
		{
			DestroyUtil.destroyArray(_agreements);
			_agreements = null;
		}
	}
}