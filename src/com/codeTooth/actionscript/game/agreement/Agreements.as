package com.codeTooth.actionscript.game.agreement
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
	import flash.utils.Dictionary;

	internal class Agreements implements IDestroy
	{
		
		public function Agreements()
		{
			_agreements = new Array();
		}
		
		//----------------------------------------------------------------------------------------------------------------------------------
		// 协议
		//----------------------------------------------------------------------------------------------------------------------------------
		
		private var _agreements:Array/*index id of agreement(uint), value AgreementItem*/ = null;
		
		public function createAgreements(xml:XML):void
		{
			if(xml == null)
			{
				throw new NullPointerException("Null xml");
			}
			
			// 清空集合
			DestroyUtil.destroyVector(_agreements);
			
			var agreementsXMLList:XMLList = xml.agreement;
			for each(var agreementXML:XML in agreementsXMLList)
			{
				if(agreementXML == null)
				{
					throw new NullPointerException("Null agreementXML");
				}
				
				// 判断 agreement.@head
				// 存在
				if(agreementXML.@head == undefined)
				{
					throw new NoSuchObjectException("Agreement" + Common.NEW_LINE + 
						agreementXML.toXMLString() + Common.NEW_LINE + 
						"has not head."
					);
				}
				// 是正整数
				// 在0到255范围内
				if(!StringUtil.mayBeUnsignedInteger(String(agreementXML.@head)) || 
					uint(String(agreementXML.@head)) > Agreement.AGREEMENT_HEAD_MAX_VALUE)
				{
					throw new IllegalParameterException(
						"Illegal agreement head \"" + String(agreementXML.@head) + "\", from 0 to " + Agreement.AGREEMENT_HEAD_MAX_VALUE
					);
				}
				
				// 判断 agreement.@id
				// 存在
				if(agreementXML.@id == undefined)
				{
					throw new NoSuchObjectException("Agreement" + Common.NEW_LINE + 
						agreementXML.toXMLString() + Common.NEW_LINE + 
						"has not id."
					);
				}
				// 在0到65535范围内
				if(!StringUtil.mayBeUnsignedInteger(String(agreementXML.@id)) || 
					uint(String(agreementXML.@id)) > Agreement.AGREEMENT_ID_MAX_VALUE)
				{
					throw new IllegalParameterException(
						"Illegal agreement id \"" + String(agreementXML.@id) + "\", from 0 to " + Agreement.AGREEMENT_ID_MAX_VALUE
					);
				}
				// 没有重复的id存在
				if(_agreements[uint(String(agreementXML.@id))] != undefined)
				{
					throw new IllegalParameterException("Has duplicate id \"" + String(agreementXML.@id) + "\"");
				}
				
				// 判断 agreement.@clazz
				// 存在
				if(agreementXML.@clazz == undefined)
				{
					throw new NoSuchObjectException("Agreement" + Common.NEW_LINE + 
						agreementXML.toXMLString() + Common.NEW_LINE + 
						"has not clazz."
					);
				}
				
				// 判断 agreement.@func
				// 存在
				if(agreementXML.@func == undefined)
				{
					throw new NoSuchObjectException("Agreement" + Common.NEW_LINE + 
						agreementXML.toXMLString() + Common.NEW_LINE + 
						"has not func."
					);
				}
				
				// 判断 agreement.@isStatic
				if(agreementXML.@isStatic != undefined && !StringUtil.mayBeBoolean(String(agreementXML.@isStatic)))
				{
					throw new IllegalParameterException("Illegal agreement isStatic \"" + String(agreementXML.@isStatic) + "\"");
				}
				
				// 判断 agreement.@isSingle
				if(agreementXML.@isSingle != undefined && !StringUtil.mayBeBoolean(String(agreementXML.@isSingle)))
				{
					throw new IllegalParameterException("Illegal agreement isSingle \"" + String(agreementXML.@isSingle) + "\"");
				}
				
				var agreementItem:AgreementItem = new AgreementItem(
					uint(String(agreementXML.@head)), uint(String(agreementXML.@id)), String(agreementXML.@clazz), 
					String(agreementXML.@func), 
					agreementXML.@isStatic == undefined ? true : StringUtil.toBoolean(String(agreementXML.@isStatic)), 
					agreementXML.@isSingle == undefined ? true : StringUtil.toBoolean(String(agreementXML.@isSingle)), 
					agreementXML.@definition == undefined || StringUtil.isEmpty(String(agreementXML.@definition)) ? null : String(agreementXML.@definition), 
					agreementXML
				);
				
				if(_agreements[agreementItem.id] != null)
				{
					throw new IllegalOperationException("Has contains the agreement \"" + agreementItem.id + "\"");
				}
				
				_agreements[agreementItem.id] = agreementItem;
			}
		}
		
		public function createDefinitions(appDomain:ApplicationDomain, clazzCheck:Boolean):void
		{
			for each(var agreemenetItem:AgreementItem in _agreements)
			{
				agreemenetItem.createClazz(appDomain, clazzCheck);
			}
		}
		
		public function containsAgreementItem(id:uint):Boolean
		{
			return _agreements[id] != null;
		}
		
		public function getAgreementItem(id:uint):AgreementItem
		{
			return _agreements[id];
		}
		
		public function getAgreementItems():Array
		{
			return _agreements;
		}
		
		//----------------------------------------------------------------------------------------------------------------------------------
		// 实现 IDestroy 方法
		//----------------------------------------------------------------------------------------------------------------------------------
		
		public function destroy():void
		{
			DestroyUtil.destroyArray(_agreements);
			_agreements = null;
		}
	}
}