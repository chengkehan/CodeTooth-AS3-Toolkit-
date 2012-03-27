package com.codeTooth.actionscript.dependencyInjection.core 
{		
	[Event(name="complete", type="com.codeTooth.actionscript.dependencyInjection.core.DiContainerEvent")]
	
	[Event(name="ioError", type="com.codeTooth.actionscript.dependencyInjection.core.DiContainerEvent")]
	
	[Event(name="securityError", type="com.codeTooth.actionscript.dependencyInjection.core.DiContainerEvent")]
	
	import com.codeTooth.actionscript.lang.exceptions.NullPointerException;
	import com.codeTooth.actionscript.lang.utils.destroy.IDestroy;
	
	import flash.events.EventDispatcher;
	import flash.system.ApplicationDomain;
	 
	//BUG Reinject\null	
	//FIXME has not progress event
	/**
	 * 注入容器
	 * 
	 * @example
	 * <listing>
	 *	注入的XML格式
	 * 	&lt;data&gt;
	 * 		&lt;insert source="data/di/commands.xml" relativePath="relativePath"/&gt;
	 * 		&lt;item id="ID1" type="com.xxx.ClassA" isSingle="true"&gt;
	 * 			&lt;!-- 设置id2Object属性，ID2是另一个注入的对象 --&gt;
	 * 			&lt;content property1="this.id2Object" property2="ID2"/&gt;
	 * 			&lt;!-- 设置value属性为10 --&gt;
	 * 			&lt;content property1="this.value" number="10"/&gt;
	 * 			&lt;!-- 设置str属性为10 --&gt;
	 * 			&lt;content property1="this.str" string="abc"/&gt;
	 * 			&lt;!-- 设置prop2属性，是一个方法的返回值调用方法 --&gt;
	 * 			&lt;content property1="this.prop2" method="ID2.getPopUpIDByDIID"&gt;
	 * 				&lt;!-- 这里是方法的入参，没有入参就不需要了，当然入参也可以是另一个方法的返回值 --&gt;
	 *				&lt;parameter string="str1"/&gt;
	 * 				&lt;parameter value="10"/&gt;
	 *			&lt;/content&gt;
	 * 			&lt;!-- 直接调用方法 --&gt;
	 * 			&lt;content method="this.methodA"&gt;
	 * 				&lt;parameter property1="ID1.value"/&gt;
	 * 			&lt;/content&gt;
	 * 		&lt;item&gt;
	 * 		&lt;item id="ID2" type="com.xxx.ClassA" isSingle="true"&gt;
	 * 			&lt;!-- 构造函数 --&gt;
	 * 			&lt;constructorArgument string="ABC"/&gt;
	 *			&lt;constructorArgument property1="ID1.str"/&gt;
	 * 		&lt;/item&gt;
	 * 	&lt;/data&gt;
	 * 	
	 * 	insert表示包含另一个需要注入的XML文件。一般web中都使用相对路径，所以不需要relativePath这个参数。
	 * 	而在AIR应用中都需要使用绝对路径，relativePath引号中指的是一个字符串变量，可以通过addLocal("relativePath", "C:\")来指定，
	 * 	在这个实例中，就形成了C:/data/di/commands.xml的绝对路径。
	 * 
	 * 	isSingle表示是否是容器内单例，单例只会创建一次。	
	 * 
	 * 	使用方法
	 * 	var diContainer:DIContainer = new DIContainer();
	 * 	// 完成事件
	 * 	diContainer.addEventListener(DiContainerEvent.COMPLETE, completeHandler);
	 * 	// IOError事件
	 *	diContainer.addEventListener(DiContainerEvent.IO_ERROR, ioErrorHandler);
	 * 	// SecurityError事件
	 *	diContainer.addEventListener(DiContainerEvent.SECURITY_ERROR, securityErrorHandler);
	 * 
	 * 	// 开始加载
	 * 	// 通过IO加载
	 * 	diContainer.load(new DiURLLoader(new DiXMLLoadedDataParser()), url);
	 * 	// 加载潜入在AS中的XML
	 *  // _objectsDIContainer.load(new DiXMLLoader(), new XML(&lt;data/&gt;));
	 * 
	 * 	// 加载完成了
	 *  function completeHandler(event:DiContainerEvent):void
	 * 	{
	 * 		var obj:ClassA = diContainer.createObject("ID1");
	 * 	}
	 * </listing>
	 */
	public class DiContainer extends EventDispatcher 
																	implements IDestroy
	{
		//加载器		
		private var _loader:IDiLoader = null;
		
		//注入对象创建器 
		private var _objectCreator:ObjectCreator = null;
		
		public function DiContainer()
		{
			_objectCreator = new ObjectCreator();
		}
		
		/**
		 * 注入容器的应用程序域
		 */		
		public function set applicationDomain(applicationDomain:ApplicationDomain):void
		{
			_objectCreator.applicationDomain = applicationDomain;
		}
		
		/**
		 * @private
		 */		
		public function get applicationDomain():ApplicationDomain
		{
			return _objectCreator.applicationDomain;
		}
		
		/**
		 * 开始加载注入
		 * 
		 * @param loader 指定的加载器
		 * @param source 指定的加载源
		 * 
		 * @throws com.codeTooth.actionscript.lang.exceptions.NullPointerException 
		 * 指定的加载器或加载源是null
		 */		
		public function load(loader:IDiLoader, source:Object):void
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
			addListeners();
			_loader.setGetLocalFunction(getLocal);
			_loader.load(source);
		}
		
		/**
		 * 添加一条本地数据
		 * 
		 * @param name 本地数据的名称
		 * @param object 本地数据的值
		 */			
		public function addLocal(name:String, object:Object):void
		{
			_objectCreator.addLocal(name, object);
		}
		
		/**
		 * 移除一条本地数据
		 * 
		 * @param name
		 */		
		public function removeLocal(name:String):void
		{
			_objectCreator.removeLocal(name);
		}
		
		/**
		 * 获得一条本地数据
		 * 
		 * @param name
		 * 
		 * @return
		 */		
		public function getLocal(name:String):*
		{
			return _objectCreator.getLocal(name);
		}
		
		/**
		 * 判断是否存在指定的本地数据
		 * 
		 * @param name
		 * 
		 * @return
		 */		
		public function hasLocal(name:String):Boolean
		{
			return _objectCreator.hasLocal(name);
		}
		
		/**
		 * 创建注入对象
		 * 
		 * @param id 要创建对象的id
		 * 
		 * @return
		 */		
		public function createObject(id:String):*
		{
			return _objectCreator.createObject(id);
		}
		
		/**
		 * 判断是否存在一个注入对象
		 * 
		 * @param id 注入对象的id
		 * 
		 * @return
		 */		
		public function hasObject(id:String):Boolean
		{
			return _objectCreator.hasObject(id);
		}
		
		/**
		 * 销毁所有已经存在的单例对象
		 */		
		public function destroySingletons():void
		{
			_objectCreator.destroySingletons();
		}
		
		/**
		 * @inheritDoc
		 */		
		public function destroy():void
		{
			destroyLoader();
			_objectCreator.destroy();
			_objectCreator = null;
		}
		
		//销毁加载器
		private function destroyLoader():void
		{
			if(_loader != null)
			{
				removeListeners();
				_loader.destroy();
				_loader = null;
			}
		}
		
		//发出事件
		private function dispatchEventInternal(type:String, source:Object):void
		{
			// FIXME do not new a event to propagate the event, the clone method is overrided
			var newEvent:DiContainerEvent = new DiContainerEvent(type);
			newEvent.source = source;
			dispatchEvent(newEvent);
		}
		
		//为加载器添加帧听
		private function addListeners():void
		{
			_loader.addEventListener(DiContainerEvent.COMPLETE, completeHandler);
			_loader.addEventListener(DiContainerEvent.IO_ERROR, ioErrorHandler);
			_loader.addEventListener(DiContainerEvent.SECURITY_ERROR, securityErrorHandler);
		}
		
		//移除加载器帧听
		private function removeListeners():void
		{
			_loader.removeEventListener(DiContainerEvent.COMPLETE, completeHandler);
			_loader.removeEventListener(DiContainerEvent.IO_ERROR, ioErrorHandler);
			_loader.removeEventListener(DiContainerEvent.SECURITY_ERROR, securityErrorHandler);
		}
		
		//加载结束
		private function completeHandler(event:DiContainerEvent):void
		{
			_objectCreator.setItems(new Parser().parse(_loader.getLoadedData()));
			dispatchEventInternal(event.type, event.source);
		}
		
		//加载发生IOError
		private function ioErrorHandler(event:DiContainerEvent):void
		{
			destroyLoader();
			dispatchEventInternal(event.type, event.source);
		}
		
		//加载发生SecurityError
		private function securityErrorHandler(event:DiContainerEvent):void
		{
			destroyLoader();
			dispatchEventInternal(event.type, event.source);
		}
	}
}