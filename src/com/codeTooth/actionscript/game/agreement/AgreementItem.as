package com.codeTooth.actionscript.game.agreement
{
	import com.codeTooth.actionscript.lang.exceptions.NullPointerException;
	import com.codeTooth.actionscript.lang.exceptions.UnknownTypeException;
	import com.codeTooth.actionscript.lang.utils.Common;
	import com.codeTooth.actionscript.lang.utils.destroy.IDestroy;
	
	import flash.system.ApplicationDomain;

	/**
	 * 协议格式对象爱你个
	 */
	public class AgreementItem implements IDestroy
	{
		// 协议头
		private var _head:uint = 0;
		
		// 协议ID
		private var _id:uint = 0;
		
		// 协议触发的类
		private var _clazz:String = null;
		
		// 协议触发的方法
		private var _func:String = null;
		
		// 触发的方法是否是静态
		private var _isStatic:Boolean = false;
		
		// 如果触发的方法不是静态，是否创建单例触发对象
		private var _isSingle:Boolean = false;
		
		// 协议内容映射的类定义
		private var _definitionClazz:Class = null;
		
		// 协议内容映射的类名
		private var _definition:String = null;
		
		// 协议内容的格式描述
		private var _contentXMLList:XMLList = null;
		
		private var _agreementXML:XML = null;
		
		public function AgreementItem(head:uint, id:uint, clazz:String, func:String, isStatic:Boolean, isSingle:Boolean, definition:String, agreementXML:XML)
		{
			if(agreementXML == null)
			{
				throw new NullPointerException("Null agreementXML");
			}
			
			_head = head;
			_id = id;
			_clazz = clazz;
			_func = func;
			_isStatic = isStatic;
			_isSingle = isSingle;
			_definition = definition;
			_agreementXML = agreementXML;
			_contentXMLList = _agreementXML.value == undefined ? null : _agreementXML.value;
			checkContentXMLList();
		}
		
		public function get head():uint
		{
			return _head;
		}
		
		public function get id():uint
		{
			return _id;
		}
		
		public function get clazz():String
		{
			return _clazz;
		}
		
		public function get func():String
		{
			return _func;
		}
		
		public function get isStatic():Boolean
		{
			return _isStatic;
		}
		
		public function get isSingle():Boolean
		{
			return _isSingle;
		}
		
		public function get definition():String
		{
			return _definition;
		}
		
		internal function getAgreementXML():XML
		{
			return _agreementXML;
		}
		
		internal function getContentXMLList():XMLList
		{
			return _contentXMLList;
		}
		
		internal function createClazz(appDomain:ApplicationDomain, clazzCheck:Boolean):void
		{
			_definitionClazz = null;
			if(clazzCheck && !appDomain.hasDefinition(_clazz))
			{
				return;
			}
			
			_definitionClazz = Class(appDomain.getDefinition(_clazz));
		}
		
		internal function getClazz():Class
		{
			return _definitionClazz;
		}
		
		// 检查协议内容的格式描述是否合法
		// 只检查第一层的节点
		private function checkContentXMLList():void
		{
			var typeStr:String;
			if(_contentXMLList != null)
			{
				for each(var contentXML:XML in _contentXMLList)
				{
					// 必须有name属性
					if(contentXML.@name == undefined)
					{
						throw new UnknownTypeException(
							"Illegal value XML, has not \"name\"." + Common.NEW_LINE + contentXML.toXMLString()
						);
					}
					// 必须有type属性
					if(contentXML.@type == undefined)
					{
						throw new UnknownTypeException(
							"Illegal value XML, has not \"type\"." + Common.NEW_LINE + contentXML.toXMLString()
						);
					}
					
					typeStr = String(contentXML.@type);
					
					// 如果是vector类型，必须指定其中的每一个元素的类型
					if(typeStr == Agreement.VALUE_TYPE_VECTOR && contentXML.@definition == undefined)
					{
						throw new UnknownTypeException(
							"Illegal vector XML, has not \"definition\"." + Common.NEW_LINE + contentXML.toXMLString()
						);
					}
					// 如果是array类型，必须指定其中的每一个元素的类型
					if(typeStr == Agreement.VALUE_TYPE_ARRAY && contentXML.value == undefined)
					{
						throw new UnknownTypeException(
							"Illegal array xml, has not specified item type." + Common.NEW_LINE + contentXML.toXMLString()
						);
					}
					// 如果是vector类型，必须指定其中的每一个元素的类型
					if(typeStr == Agreement.VALUE_TYPE_VECTOR && contentXML.value == undefined)
					{
						throw new UnknownTypeException(
							"Illegal vector xml, has not specified item type." + Common.NEW_LINE + contentXML.toXMLString()
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
			_definitionClazz = null;
			_contentXMLList = null;
		}
		
		//----------------------------------------------------------------------------------------------------------------------------------
		// 重写 toString 方法
		//----------------------------------------------------------------------------------------------------------------------------------
		
		public function toString():String
		{
			return "[object AgreementItem(head:" + _head + ", id:" + _id + ", clazz:" + _clazz + ", func:" + _func + ", isStatic:" + _isStatic + ", isSingle:" + _isSingle + ", definition:" + _definition + ")]";
		}
	}
}