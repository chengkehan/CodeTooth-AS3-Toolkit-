package com.codeTooth.actionscript.game.agreement
{
	[Event(type="com.codeTooth.actionscript.game.agreement.AgreementEvent", name="complete")]
	
	[Event(type="com.codeTooth.actionscript.game.agreement.AgreementEvent", name="ioError")]
	
	[Event(type="com.codeTooth.actionscript.game.agreement.AgreementEvent", name="securityError")]
	
	import com.codeTooth.actionscript.lang.exceptions.NoSuchObjectException;
	import com.codeTooth.actionscript.lang.exceptions.NullPointerException;
	import com.codeTooth.actionscript.lang.exceptions.UnknownTypeException;
	import com.codeTooth.actionscript.lang.utils.Common;
	import com.codeTooth.actionscript.lang.utils.destroy.IDestroy;
	
	import flash.events.EventDispatcher;
	import flash.system.ApplicationDomain;
	import flash.utils.ByteArray;

	/**
	 * 协议。
	 * 
	 * 协议的XML结构。
	 * head 是协议头，数值范围在0到255之间。
	 * id 是协议的唯一标识，范围在0到65535之间。
	 * clazz 是调用方法的类。
	 * func 是调用的方法名。
	 * isStatic 表示方法是否是静态。
	 * isSingle 表示类是否是单例。
	 * definition 可选。协议对象的类定义，如果没有该属性或者属性值为空，协议对象将使用默认的Object类型。该类必须实现IAgreementObject接口。
	 * 
	 * 协议的内容是由value节点组成的，每一个value节点表示一个对象。
	 * name表示对象的名称，type表示对象的类型，节点中的值表示对象的值，definition表示对象的实际类型。
	 * 
	 * 所有可用的type值为：
	 * int：整形。4Byte。
	 * uint：无符号整形。4Byte。
	 * double：IEEE 754 双精度浮点。8Byte。
	 * float：IEEE 754 单精度浮点。4Byte。
	 * string：字符串。使用2Byte的无符号整形表示字符串的长度，后接UTF-8字符串。所以字符串最长是65535。
	 * object：对象。
	 * array：数组。
	 * T：泛型数组。
	 * 
	 * 数组中元素的name属性是不可自定义的，会使用默认的0、1、2、3...这样的索引形式。
	 * 只有对象才能自定义definition属性，其他类型的value的definition将和type相同。
	 * 
	 * <agreements>
	 * 		<agreement head="0xFF" id="1" clazz="ClassA" func="functionA" isStatic="true" isSingle="false" definition="ClassB" description="协议的描述文字">
	 * 			<value name="" type="int"/>
	 * 			<value name="" type="uint"/>
	 * 			<value name="" type="double"/>
	 * 			<value name="" type="float"/>
	 * 			<value name="" type="string"/>
	 * 			<value name="" type="object" definition="">
	 * 				<value name="" type="int"/>
	 * 			</value>
	 * 			<value name="" type="array">
	 * 				<value type="int"/>
	 * 			</value>
	 * 			<value name="" type="vector" definition="ClassA">
	 * 				<value type="ClassA"/>
	 * 			</value>
	 * 		</agreement>
	 * </agreements>
	 * 
	 * 二进制协议结构示例
	 * |head(0xFF)|id(0xFFFF)|length(0xFFFF)|......|
	 */
	public class Agreement extends EventDispatcher implements IDestroy
	{	
		/**
		 * 协议头的最大值
		 */
		public static const AGREEMENT_HEAD_MAX_VALUE:uint = Common.BYTE_MAX;
		
		/**
		 * 最大的协议ID值
		 */
		public static const AGREEMENT_ID_MAX_VALUE:uint = Common.SHORT_MAX;
		
		/**
		 * 协议限制的最长字节数
		 */
		public static const AGREEMENT_LENGTH_MAX_BYTE:uint = Common.SHORT_MAX;
		
		/**
		 * 数组限制的长度
		 */
		public static const ARRAY_LENGTH_MAX_VALUE:uint = uint.MAX_VALUE;
		
		/**
		 * Vector限制的长度
		 */
		public static const VECTOR_LENGTH_MAX_VALUE:uint = uint.MAX_VALUE;
		
		/**
		 * 协议头的下一位索引
		 */
		public static const AGREEMENT_HEAD_END_INDEX:uint = 1;
		
		/**
		 * 协议ID的下一位索引
		 */
		public static const AGREEMENT_ID_END_INDEX:uint = 3;
		
		/**
		 * 协议长度的下一位索引
		 */
		public static const AGREEMENT_LENGTH_END_INDEX:uint = 5;
		
		/**
		 * 整型
		 */
		public static const VALUE_TYPE_INT:String = "int";
		
		/**
		 * 无符号整型
		 */
		public static const VALUE_TYPE_UINT:String = "uint";
		
		/**
		 * 双精度浮点
		 */
		public static const VALUE_TYPE_DOUBLE:String = "double";
		
		/**
		 * 单精度浮点
		 */
		public static const VALUE_TYPE_FLOAT:String = "float";
		
		/**
		 * 字符串
		 */
		public static const VALUE_TYPE_STRING:String = "string";
		
		/**
		 * 对象
		 */
		public static const VALUE_TYPE_OBJECT:String = "object";
		
		/**
		 * 数组 
		 */
		public static const VALUE_TYPE_ARRAY:String = "array";
		
		/**
		 * 泛型数组（Vector）
		 */
		public static const VALUE_TYPE_VECTOR:String = "vector";
		
		/**
		 * 构造函数
		 * 
		 * @param applicationDomain 协议所使用的应用程序域，如果没有指定的话，使用默认的当前域
		 * @param ignoreDefinition 忽视协议XML的definition节点，所有有类型的数据都将使用Object类型代替
		 * @param executeAgreement 使用传入的函数作为协议的执行器0。如果指定了此参数，将不会对clazz进行类型检查。原型func(agreementID:uint, data:Object):void
		 * @param clazzCheck 对clazz是否存在进行类型检查，如果不存在就不会去试图创建它
		 */
		public function Agreement(applicationDomain:ApplicationDomain = null, ignoreDefinition:Boolean = false, executeAgreement:Function = null, clazzCheck:Boolean = true)
		{
			_appDomain = applicationDomain == null ? ApplicationDomain.currentDomain : applicationDomain;
			_agreements = new Agreements();
			_agreementExecutor = new AgreementExecutor(executeAgreement);
			_ignoreDefinition = ignoreDefinition;
			_clazzCheck = clazzCheck;
		}
		
		//----------------------------------------------------------------------------------------------------------------------------------
		// 忽略协议XML中的类型数据
		//----------------------------------------------------------------------------------------------------------------------------------
		
		// 忽视协议XML的definition节点，所有有类型的数据都将使用Object类型代替
		private var _ignoreDefinition:Boolean = false;
		
		public function set ignoreDefinition(bool:Boolean):void
		{
			_ignoreDefinition = bool;
		}
		
		public function get ignoreDefinition():Boolean
		{
			return _ignoreDefinition;
		}
		
		//----------------------------------------------------------------------------------------------------------------------------------
		// 应用程序域
		//----------------------------------------------------------------------------------------------------------------------------------
		
		// 协议当前所使用的应用程序域
		private var _appDomain:ApplicationDomain = null;
		
		public function setApplicationDomain(appDomain:ApplicationDomain):void
		{
			_appDomain = appDomain == null ? ApplicationDomain.currentDomain : appDomain;
			if(_agreementExecutor.getExecuteAgreement() == null)
			{
				_agreements.createDefinitions(_appDomain, _clazzCheck);
			}
		}
		
		public function getApplicationDomain():ApplicationDomain
		{
			return _appDomain;
		}
		
		//----------------------------------------------------------------------------------------------------------------------------------
		// 加载
		//----------------------------------------------------------------------------------------------------------------------------------
		
		// 协议加载器
		private var _loader:IAgreementSourceLoader = null;
		
		private var _loaderListenersAdded:Boolean = false;
		
		/**
		 * 加载协议
		 * 
		 * @param loader 指定协议加载器
		 * @param source 加载的协议内容，根据指定的加载器的不同，可以传入协议文件的路径或者直接传入协议数据
		 * 
		 * @throws com.codeTooth.actionscript.lang.exceptions.NullPointerException 
		 * 指定的加载器或者指定的协议是null
		 */
		public function load(loader:IAgreementSourceLoader, source:Object):void
		{
			if(loader == null)
			{
				throw new NullPointerException("Null loader");
			}
			if(source == null)
			{
				throw new NullPointerException("Null source");
			}
			
			destroyLoader();
			_loader = loader;
			addLoaderListeners();
			_loader.load(source);
		}
		
		// 销毁协议加载器
		private function destroyLoader():void
		{
			if(_loader != null)
			{
				_loader.close();
				removeLoaderListeners();
				_loader = null;
			}
		}
		
		// 添加协议加载的侦听
		private function addLoaderListeners():void
		{
			if(_loader != null && !_loaderListenersAdded)
			{
				_loaderListenersAdded = true;
				_loader.addEventListener(AgreementEvent.COMPLETE, completeHandler);
				_loader.addEventListener(AgreementEvent.IO_ERROR, ioErrorHandler);
				_loader.addEventListener(AgreementEvent.SECURITY_ERROR, securityErrorHandler);
			}
		}
		
		// 移除协议加载的侦听
		private function removeLoaderListeners():void
		{
			if(_loader != null && _loaderListenersAdded)
			{
				_loaderListenersAdded = false;
				_loader.removeEventListener(AgreementEvent.COMPLETE, completeHandler);
				_loader.removeEventListener(AgreementEvent.IO_ERROR, ioErrorHandler);
				_loader.removeEventListener(AgreementEvent.SECURITY_ERROR, securityErrorHandler);
			}
		}
		
		// 协议加载完成
		private function completeHandler(event:AgreementEvent):void
		{
			_agreements.createAgreements(_loader.getAgreementXML());
			if(_agreementExecutor.getExecuteAgreement() == null)
			{
				_agreements.createDefinitions(_appDomain, _clazzCheck);
			}
			destroyLoader();
			dispatchEvent(event);
		}
		
		// 协议加载发生IOError
		private function ioErrorHandler(event:AgreementEvent):void
		{
			destroyLoader();
			dispatchEvent(event);
		}
		
		// 协议加载发生SecurityError
		private function securityErrorHandler(event:AgreementEvent):void
		{
			destroyLoader();
			dispatchEvent(event);
		}
		
		//----------------------------------------------------------------------------------------------------------------------------------
		// 协议
		//----------------------------------------------------------------------------------------------------------------------------------
		
		// 所有的协议
		private var _agreements:Agreements = null;
		
		// 协议执行器
		private var _agreementExecutor:AgreementExecutor = null; 
		
		private var _clazzCheck:Boolean = false;
		
		/**
		 * 执行一条协议
		 * 
		 * @param data 协议的二进制数据
		 * 
		 * @throws com.codeTooth.actionscript.lang.exceptions.NullPointerException 
		 * 指定的协议数据时null
		 * @throws com.codeTooth.actionscript.lang.exceptions.NoSuchObjectException 
		 * 没有找到指定ID的协议格式对象
		 * @throws com.codeTooth.actionscript.lang.exceptions.UnknownTypeException 
		 * 未知的协议头
		 */
		public function executeAgreement(data:ByteArray):void
		{
			if(data == null)
			{
				throw new NullPointerException("Null data");
			}
			
			var dataOrigPosition:uint = data.position;
			
			// 读取协议头
			var head:uint = AgreementReader.readHead(data);
			// 读取协议ID
			var id:uint = AgreementReader.readID(data);
			// 获得协议对象
			var agreementItem:AgreementItem = _agreements.getAgreementItem(id);
			if(agreementItem == null)
			{
				// 不存在指定ID的协议格式对象
				throw new NoSuchObjectException("Has not the agreement \"" + id + "\"");
			}
			else
			{
				if (head != agreementItem.head)
				{
					// 协议头部匹配
					throw new UnknownTypeException("Illegal agreement head \"" + head + "\".Agreement id is \"" + id + "\"");
				}
				else
				{
					// 开始执行协议
					data.position = dataOrigPosition;
					_agreementExecutor.execute(agreementItem, data, _appDomain, _ignoreDefinition);
				}
			}
		}
		
		/**
		 * 对一条协议的二进制数据，进行解包操作，返回协议的数据对象
		 * 
		 * @param data
		 * 
		 * @return 
		 */
		public function unpackAgreement(data:ByteArray):*
		{
			if(data == null)
			{
				throw new NullPointerException("Null data");
			}
			
			var origPosition:uint = data.position;
			var head:uint = AgreementReader.readHead(data);
			var id:uint = AgreementReader.readID(data);
			var agreementItem:AgreementItem = _agreements.getAgreementItem(id);
			if(agreementItem == null)
			{
				throw new NoSuchObjectException("Has not the agreement \"" + id + "\"");
				return null;
			}
			else
			{
				data.position = origPosition;
				return AgreementReader.read(data, agreementItem, _appDomain, _ignoreDefinition);
			}
		}
		
		/**
		 * 将一条协议封装成二进制数据
		 * 
		 * @param cache 二进制数据写入到的缓冲区
		 * @param agreementID 协议的ID号
		 * @param agreementObject 协议对象
		 * 
		 * @return 返回写入协议后的二进制缓冲区
		 * 
		 * @throws throws com.codeTooth.actionscript.lang.exceptions.NullPointerException 
		 * 指定的二进制缓冲区或者协议对象是null
		 * @throws com.codeTooth.actionscript.lang.exceptions.NoSuchObjectException 
		 * 没有找到指定ID的协议格式对象
		 */
		public function packAgreement(cache:ByteArray, agreementID:uint, agreementObject:Object):ByteArray
		{
			if(cache == null)
			{
				throw new NullPointerException("Null cache");
			}
			if(agreementObject == null)
			{
				throw new NullPointerException("Null agreementObject");
			}
			
			var agreementItem:AgreementItem = _agreements.getAgreementItem(agreementID);
			if(agreementItem == null)
			{
				// 没有找到指定ID的协议格式对象
				throw new NoSuchObjectException("Has not the agreement \"" + agreementID + "\"");
			}
			
			// 将协议数据写于缓冲，并返回二进制缓冲区
			return AgreementWriter.write(cache, agreementItem, agreementObject);
		}
		
		/**
		 * 通过协议的XML对象来封装成二进制数据
		 * 
		 * @param cache  二进制数据写入到的缓冲区
		 * @param agreementXML 协议XML对象
		 * 
		 * @return 返回写入协议后的二进制缓冲区
		 * 
		 * @throws throws com.codeTooth.actionscript.lang.exceptions.NullPointerException 
		 * 指定的二进制缓冲区或者协议XML对象是null
		 * @throws com.codeTooth.actionscript.lang.exceptions.NoSuchObjectException 
		 * 没有找到指定ID的协议格式对象
		 */
		public function packAgreementByXML(cache:ByteArray, agreementXML:XML):ByteArray
		{
			if(cache == null)
			{
				throw new NullPointerException("Null cache");
			}
			if(agreementXML == null)
			{
				throw new NullPointerException("Null agreementXML");
			}
			
			var agreementItem:AgreementItem = _agreements.getAgreementItem(uint(agreementXML.@id));
			if(agreementItem == null)
			{
				throw new NoSuchObjectException("Has not the agreement \"" + String(agreementXML.@id) + "\"");
			}
			
			return AgreementXMLWriter.write(cache, agreementItem, agreementXML);
		}
		
		/**
		 * 获得所有的协议格式对象
		 * 
		 * @return 
		 */
		public function getAgreementItems():Array
		{
			return _agreements.getAgreementItems();
		}
		
		/**
		 * 获得指定ID的协议对象
		 * 
		 * @param id
		 * 
		 * @return 
		 */
		public function getAgreementItem(id:uint):AgreementItem
		{
			return _agreements.getAgreementItem(id);
		}
		
		/**
		 * 判断是否包含指定ID的协议
		 * 
		 * @param id
		 * 
		 * @return 
		 */
		public function containsAgreementItem(id:uint):Boolean
		{
			return _agreements.containsAgreementItem(id);
		}
		
		private function destroyAgreemenets():void
		{
			if(_agreements != null)
			{
				_agreements.destroy();
				_agreements = null;
			}
			if(_agreementExecutor != null)
			{
				_agreementExecutor.destroy();
				_agreementExecutor = null;
			}
		}
		
		//----------------------------------------------------------------------------------------------------------------------------------
		// 实现 IDestoy 接口
		//----------------------------------------------------------------------------------------------------------------------------------
		
		public function destroy():void
		{
			destroyLoader();
			destroyAgreemenets();
			_appDomain = null;
		}
	}
}