package com.codeTooth.actionscript.game.amfAgreement
{
	/**
	 * 加载协议完成
	 * 
	 * @eventType com.codeTooth.actionscript.game.amfAgreement.AMFAgreementEvent.COMPLETE 
	 */
	[Event(name="complete", type="com.codeTooth.actionscript.game.amfAgreement.AMFAgreementEvent")]
	
	/**
	 * 加载协议发生IOError
	 * 
	 * @eventType com.codeTooth.actionscript.game.amfAgreement.AMFAgreementEvent.IO_ERROR
	 */
	[Event(name="ioError", type="com.codeTooth.actionscript.game.amfAgreement.AMFAgreementEvent")]
	
	/**
	 * 加载协议发生SecurityError
	 * 
	 * @eventType com.codeTooth.actionscript.game.amfAgreement.AMFAgreementEvent.SECURITY_ERROR
	 */
	[Event(name="securityErrot", type="com.codeTooth.actionscript.game.amfAgreement.AMFAgreementEvent")]
	
	import com.codeTooth.actionscript.game.connection.amf.AMFEncoder;
	import com.codeTooth.actionscript.lang.exceptions.IllegalParameterException;
	import com.codeTooth.actionscript.lang.exceptions.NoSuchObjectException;
	import com.codeTooth.actionscript.lang.exceptions.NullPointerException;
	import com.codeTooth.actionscript.lang.utils.Common;
	import com.codeTooth.actionscript.lang.utils.destroy.IDestroy;
	
	import flash.events.EventDispatcher;
	import flash.system.ApplicationDomain;
	import flash.utils.ByteArray;
	
	/**
	 * <p>
	 * AMF协议。通过XML文档来描述AMF协议的配置文件。自动进行AMF协议的封包、解包以及执行。
	 * </p>
	 * 
	 * <p>
	 * <pre>
	 * XML的具体格式如下：
	 * &lt; amfAgreements &gt;
	 * 	&lt; amfAgreement id="1" module="Login" command="login" isStatic="true" isSingle="false" description="描述文字" /&gt;
	 * &lt;/ amfAgreements &gt;
	 * 
	 * id：协议的id号，最大不超过65535。
	 * module：执行协议是调用的类名，类型需要有包路径。
	 * command：执行协议是调用的类中的方法名。
	 * isStatic：调用的方法是否是静态的。
	 * isSingle：调用的类是否使用单例，如果为true，当执行协议时，只会创建一个module指定的类的对象，否则每次执行协议时，都会创建新的类的对象。
	 * desription：文字性的卖描述。相当于注释。
	 * </pre>
	 * </p>
	 * 
	 * <p>
	 * <pre>
	 * 使用方法简介：（以上面的XML为例）
	 * var amfAgreement:AMFAgreement = new AMFAgreement();
	 * amfAgreement.addEventListener(AMFAgreementEvent.COMPLETE, completeHandler);
	 * amfAgreement.addEventListener(AMFAgreementEvent.IO_ERROR, ioErrorHandler);
	 * amfAgreement.addEventListener(AMFAgreementEvent.SECURITY_ERROR, securityErrorHandler);
	 * // 从xml文件加载
	 * amfAgreement.load(new AMFAgreementURLLoader(new AMFAgreementXMLParser()), "amfAgreement.xml");
	 * // 或从xml对象加载
	 * amfAgreement.load(new AMFAgreementXMLLoader(new AMFAgreementXMlParser()), xmlObject);
	 * 
	 * private function completeHandler(event:AMFAgreementEvent):void
	 * {
	 * 	// 加载完成
	 * 	var role:Object = new Object();
	 * 	role.name = "jim";
	 * 	role.name = 24;
	 *	
	 * 	// 封包
	 * 	var buffer:ByteArray = new ByteArray();
	 * 	amfAgreement.packAMFAgreement(1, buffer, role);
	 * 	
	 * 	// 封包完成后，可以对buffer进行字节处理，然后通过IO传输，在IO的另一端解包或者直接执行协议
	 * 
	 * 	// 解包
	 * 	buffer.position = 0;
	 * 	var amfRole:Object = amfAgreement.unpackAMFAgreement(buffer);
	 * 	// Output ("jim", 24)
	 * 	trace(amfRole.name, amfRole.age);
	 * 
	 * 	// 执行协议
	 * 	buffer.position = 0;
	 * 	amfAgreement.executeAMFAgreement(buffer);
	 * }
	 * private function ioErrorHandler(event:AMFAgreementEvent):void
	 * {
	 * 	// IOError
	 * }
	 * private function securityErrorHandler(event:AMFAgreementEvent):void
	 * {
	 * 	// SecurityError
	 * }
	 * </pre>
	 * </p>
	 * 
	 * <p>
	 * 协议的二进制结构示意图：|0xFF(head)|0xFFFF(id)|0xFFFF(length)|......(amfData)|。
	 * </p>
	 */
	public class AMFAgreement extends EventDispatcher implements IDestroy
	{
		/**
		 * AMF协议的头数据
		 */
		public static const AMF_HEAD:uint = AMFEncoder.AMF_HEAD;
		
		/**
		 * AMF协议的ID最大值
		 */
		public static const AMF_AGREEMENT_ID_MAX:uint = Common.SHORT_MAX;
		
		/**
		 * AMF协议数据部分最多包含的字节数
		 */
		public static const AMF_LENGTH_MAX_VALUE:uint = AMFEncoder.AMF_LENGTH_MAX_VALUE;
		
		public static const AMF_AGREEMENT_HEAD_END_INDEX:uint = 1;
		
		public static const AMF_AGREEMENT_ID_END_INDEX:uint = 3;
		
		public static const AMF_AGREEMENT_LENGTH_END_INDEX:uint = 5;
		
		/**
		 * 构造函数
		 * 
		 * @param applicationDomain 协议运行所在的应用程序域，如果指定默认的null，则使用当前域。
		 * @param clazzCheck 是否进行类检查。如果为true，则进行类检查，那么初始化时，如果遇到不存在的module时将会跳过，否则将会抛出异常。
		 */
		public function AMFAgreement(applicationDomain:ApplicationDomain = null, clazzCheck:Boolean = true)
		{
			_applicationDomain = applicationDomain == null ? ApplicationDomain.currentDomain : applicationDomain;;
			_clazzCheck = clazzCheck;
		}
		
		//----------------------------------------------------------------------------------------------------------------------------------
		// ApplicationDomain
		//----------------------------------------------------------------------------------------------------------------------------------
		
		// 协议运行所在的应用程序域
		private var _applicationDomain:ApplicationDomain = null;
		
		// 是否进行类检查
		private var _clazzCheck:Boolean = true;
		
		/**
		 * 设定协议运行所在的应用程序域。调用此方法后会重新创建并检查所有的module
		 * 
		 * @param appDomain 如果指定默认的null，则使用当前域。
		 */
		public function setApplicationDomain(appDomain:ApplicationDomain = null):void
		{
			_applicationDomain = appDomain == null ? ApplicationDomain.currentDomain : appDomain;
			_amfAgreements.createModuleClazzes(_applicationDomain, _clazzCheck);
		}
		
		/**
		 * 获得协议运行所在的应用程序域
		 * 
		 * @return 
		 */
		public function getApplicationDomain():ApplicationDomain
		{
			return _applicationDomain;
		}
		
		//----------------------------------------------------------------------------------------------------------------------------------
		// Agreements
		//----------------------------------------------------------------------------------------------------------------------------------
		
		// 所有的AMF协议对象
		private var _amfAgreements:AMFAgreements = null;
		
		// AMF协议的执行器
		private var _amfAgreementExecutor:AMFAgreementExecutor = null;
		
		/**
		 * 获得指定ID的AMF协议对象
		 * 
		 * @param agreementID
		 * 
		 * @return 
		 */
		public function getAMFAgreement(agreementID:uint):AMFAgreementItem
		{
			return _amfAgreements.getAMFAgreement(agreementID);
		}
		
		/**
		 * 判断是否包含指定ID的AMF协议对象
		 * 
		 * @param agreementID
		 * 
		 * @return 
		 */
		public function containsAMFAgreement(agreementID:uint):Boolean
		{
			return _amfAgreements.containsAMFAgreement(agreementID);
		}
		
		/**
		 * 获得所有的AMF协议对象
		 * 
		 * @return 
		 */
		public function getAMFAgreements():Array
		{
			return _amfAgreements.getAMFAgreements();
		}
		
		/**
		 * 封装一条AMF协议数据
		 * 
		 * @param agreementID 协议的ID
		 * @param buffer 为写入协议数据提供的缓冲区
		 * @param data AMF数据对象
		 * 
		 * @return 返回传入的缓冲区
		 * 
		 * @throws com.codeTooth.actionscript.lang.exceptions.IllegalParameterException 
		 * 不存在指定ID的AMF协议
		 */
		public function packAMFAgreement(agreementID:uint, buffer:ByteArray, data:Object):ByteArray
		{
			if(!_amfAgreements.containsAMFAgreement(agreementID))
			{
				throw new IllegalParameterException("Has not the agreement \"" + agreementID + "\"");
			}
			
			return AMFAgreementWriter.write(agreementID, buffer, data);
		}
		
		/**
		 * 解包一条AMF协议数据
		 * 
		 * @param buffer 存有协议数据的缓冲区
		 * 
		 * @return 返回解包的AMF数据对象
		 */
		public function unpackAMFAgreement(buffer:ByteArray):Object
		{
			return AMFAgreementReader.read(buffer);
		}
		
		/**
		 * 执行一条协议
		 * 
		 * @param buffer 存有AMF协议数据的缓冲区
		 * 
		 * @throws com.codeTooth.actionscript.lang.exceptions.NullPointerException 
		 * 提供的缓冲区是null
		 * @throws com.codeTooth.actionscript.lang.exceptions.NoSuchObjectException 
		 * 不存在指定ID的协议
		 */
		public function executeAMFAgreement(buffer:ByteArray):void
		{
			if(buffer == null)
			{
				throw new NullPointerException("Null buffer");
			}
			
			var bufferOrigPosition:uint = buffer.position;
			AMFAgreementReader.readHead(buffer);
			
			var id:uint = AMFAgreementReader.readAgreementID(buffer);
			var agreementItem:AMFAgreementItem = _amfAgreements.getAMFAgreement(id);
			if(agreementItem == null)
			{
				throw new NoSuchObjectException("Has not the amf agreement \"" + id + "\"");
			}
			
			buffer.position = bufferOrigPosition;
			_amfAgreementExecutor.execute(agreementItem, buffer);
		}
		
		// 销毁
		private function destroyAMFAgreements():void
		{
			if(_amfAgreements != null)
			{
				_amfAgreements.destroy();
				_amfAgreements = null;
			}
			if(_amfAgreementExecutor != null)
			{
				_amfAgreementExecutor.destroy();
				_amfAgreementExecutor = null;
			}
		}
		
		//----------------------------------------------------------------------------------------------------------------------------------
		// 加载
		//----------------------------------------------------------------------------------------------------------------------------------
		
		// 协议加载器
		private var _loader:IAMFAgreementLoader = null;
		
		/**
		 * 加载AMF协议
		 * 
		 * @param loader 指定的协议加载器
		 * @param source 加载的协议内容，根据指定的不同加载器，可以传入字符串或XML等不同的source
		 * 
		 * @throws com.codeTooth.actionscript.lang.exceptions.NullPointerException 
		 * 指定的协议加载器或source是null
		 */
		public function load(loader:IAMFAgreementLoader, source:Object):void
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
		
		private function addLoaderListeners():void
		{
			_loader.addEventListener(AMFAgreementEvent.COMPLETE, completeHandler);
			_loader.addEventListener(AMFAgreementEvent.IO_ERROR, ioErrorHandler);
			_loader.addEventListener(AMFAgreementEvent.SECURITY_ERROR, securityErrorHandler);
		}
		
		private function removeLoaderListeners():void
		{
			_loader.removeEventListener(AMFAgreementEvent.COMPLETE, completeHandler);
			_loader.removeEventListener(AMFAgreementEvent.IO_ERROR, ioErrorHandler);
			_loader.removeEventListener(AMFAgreementEvent.SECURITY_ERROR, securityErrorHandler);
		}
		
		// 加载协议完成时触发
		private function completeHandler(event:AMFAgreementEvent):void
		{
			var agreementXML:XML = _loader.getAMFAgreementXML();
			_amfAgreements = new AMFAgreements(agreementXML);
			_amfAgreements.createModuleClazzes(_applicationDomain, _clazzCheck);
			_amfAgreementExecutor = new AMFAgreementExecutor();
			dispatchEvent(event);
		}
		
		private function ioErrorHandler(event:AMFAgreementEvent):void
		{
			destroyLoader();
			dispatchEvent(event);
		}
		
		private function securityErrorHandler(event:AMFAgreementEvent):void
		{
			destroyLoader();
			dispatchEvent(event);
		}
		
		// 销毁
		private function destroyLoader():void
		{
			if(_loader != null)
			{
				removeLoaderListeners();
				_loader.destroy();
				_loader = null;
			}
		}
		
		//----------------------------------------------------------------------------------------------------------------------------------
		// 实现 IDestroy 接口
		//----------------------------------------------------------------------------------------------------------------------------------
		
		public function destroy():void
		{
			destroyLoader();
			destroyAMFAgreements();
		}
	}
}