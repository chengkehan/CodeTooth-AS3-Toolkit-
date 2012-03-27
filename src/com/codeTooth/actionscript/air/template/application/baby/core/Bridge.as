package com.codeTooth.actionscript.air.template.application.baby.core
{
	import com.codeTooth.actionscript.air.template.application.baby.util.exception.ExceptionHandlers;
	import com.codeTooth.actionscript.air.template.application.baby.util.exception.Exceptions;
	import com.codeTooth.actionscript.dependencyInjection.core.DiContainer;
	import com.codeTooth.actionscript.dependencyInjection.core.DiContainerEvent;
	import com.codeTooth.actionscript.dependencyInjection.core.DiURLLoader;
	import com.codeTooth.actionscript.dependencyInjection.core.DiXMLLoadedDataParser;
	import com.codeTooth.actionscript.lang.exceptions.GlobalExceptionEvent;
	import com.codeTooth.actionscript.lang.exceptions.GlobalExceptionHandler;
	import com.codeTooth.actionscript.patterns.observer.IObserver;
	import com.codeTooth.actionscript.patterns.observer.Subject;
	import flash.events.Event;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.Stage;
	import flash.filesystem.File;
	import flash.system.ApplicationDomain;

	/**
	 * 依赖对象。目的是把对象之间的依赖转移到这里，起到桥梁的作用。
	 */
	public class Bridge
	{
		//---------------------------------------------------------------------------------------------------------------------------------------------------
		// ExceptionContext
		//---------------------------------------------------------------------------------------------------------------------------------------------------
		
		/**
		 * 添加一个全局异常处理的上下文
		 * 
		 * @param	context
		 * 
		 * @return 返回成功添加的对象
		 */
		public static function addExceptionContext(context:Object):Object
		{
			return ExceptionHandlers.addContext(context);
		}
		
		/**
		 * 删除一个全局异常处理的上下文
		 * 
		 * @param	context
		 * 
		 * @return 返回被删除的对象
		 */
		public static function removeExceptionContext(context:Object):Object
		{
			return ExceptionHandlers.removeContext(context);
		}
		
		//---------------------------------------------------------------------------------------------------------------------------------------------------
		// Observer
		//---------------------------------------------------------------------------------------------------------------------------------------------------
		
		// 全局主题
		private static var _subject:Subject = new Subject();
		
		/**
		 * 添加观察者，订阅主题，观察者将收到主题的消息
		 * 
		 * @param	observer
		 * 
		 * @return 返回被添加的观察者
		 */
		public static function addObserver(observer:IObserver):IObserver
		{
			return _subject.addObserver(observer);
		}
		
		/**
		 * 删除一个观察者
		 * 
		 * @param	observer
		 * 
		 * @return 返回被删除的对象
		 */
		public static function removeObserver(observer:IObserver):IObserver
		{
			return _subject.removeObserver(observer);
		}
		
		/**
		 * 主题发送消息，所有订阅这个主题的观察者都将受到
		 * 
		 * @param	data 消息的内容
		 */
		public static function notify(data:Object = null):void
		{
			_subject.notify(data);
		}
		
		//---------------------------------------------------------------------------------------------------------------------------------------------------
		// 全局异常处理
		//---------------------------------------------------------------------------------------------------------------------------------------------------
	
		// 全局异常处理
		private static var _globalExceptionHandler:GlobalExceptionHandler = new GlobalExceptionHandler();
		
		// 全局异常以冒泡形式抛出
		private static var _container:DisplayObjectContainer = null;
		
		/**
		 * 初始化全局异常处理
		 * 
		 * @param	container 显示列表容器，用于冒泡抛出异常事件
		 * 
		 * @return 返回成功创建全局异常处理的容器，只能创建一次。null表示没有成功创建
		 */
		public static function initializeGlobalExceptionHandler(container:DisplayObjectContainer):DisplayObjectContainer
		{
			if(_container == null && container != null)
			{
				_container = container;
				_globalExceptionHandler.startBubbles(_container);
				_container.addEventListener(GlobalExceptionEvent.GLOBAL_EXCEPTION, ExceptionHandlers.exceptionHandler);
				
				return container;
			}
			else
			{
				return null;
			}
		}
		
		/**
		 * 添加一个对全局异常的侦听
		 * 
		 * @param	type 事件类型
		 * @param	handler 处理函数
		 */
		public static function addGlobalExceptionListener(type:String, handler:Function):void
		{
			_globalExceptionHandler.addEventListener(type, handler);
		}
		
		/**
		 * 移除一个对全局异常的侦听
		 * 
		 * @param	type 事件类型
		 * @param	handler 处理函数
		 */
		public static function removeGlobalExceptionListener(type:String, handler:Function):void
		{
			_globalExceptionHandler.removeEventListener(type, handler);
		}
		
		/**
		 * 抛出全局异常。
		 * 
		 * @param	text
		 * @param	data
		 */
		public static function throwGlobalException(text:String = "", data:Object = null):void
		{
			var exception:GlobalExceptionEvent = new GlobalExceptionEvent(GlobalExceptionEvent.GLOBAL_EXCEPTION, true, text);
			exception.data = data;
			_globalExceptionHandler.throwException(exception);
		}
		
		//---------------------------------------------------------------------------------------------------------------------------------------------------
		// 注入容器
		//---------------------------------------------------------------------------------------------------------------------------------------------------
		
		private static var _diContainer:DiContainer = null;
		
		private static var _loadDICompleteHandler:Function = null;
		
		private static var _loadDIIOErrorHandler:Function = null;
		
		private static var _loadDISecurityErrorHandler:Function = null;
		
		/**
		 * 加载注入数据
		 * 
		 * @param	url 路径
		 * 
		 * @return 返回是否开始加载。传入null时或者已经加载的时候，返回false
		 */
		public static function loadDI(url:String, diCompleteHandler:Function = null, diIOErrorHandler:Function = null, diDecurityErrorHandler:Function = null):Boolean
		{
			if(_diContainer == null && url != null)
			{
				_loadDICompleteHandler = diCompleteHandler;
				_loadDIIOErrorHandler = diIOErrorHandler;
				_loadDISecurityErrorHandler = diDecurityErrorHandler;
				
				_diContainer = new DiContainer();
				_diContainer.addLocal("relativePath", File.applicationDirectory.nativePath + "\\");
				_diContainer.addEventListener(DiContainerEvent.COMPLETE, completeHandler);
				_diContainer.addEventListener(DiContainerEvent.IO_ERROR, ioErrorHandler);
				_diContainer.addEventListener(DiContainerEvent.SECURITY_ERROR, securityErrorHandler);
				_diContainer.load(new DiURLLoader(new DiXMLLoadedDataParser()), url);
				
				return true;
			}
			else
			{
				return false;
			}
		}
		
		/**
		 * 向注入容器添加一个本地数据
		 * 
		 * @param	name 本地数据的名称
		 * @param	obj 本地数据的值
		 * 
		 * @return 返回是否成功添加了
		 */
		public static function addLocal(name:String, obj:Object):Object
		{
			if (_diContainer == null)
			{
				return null;
			}
			else
			{
				_diContainer.addLocal(name, obj);
				
				return obj;
			}
		}
		
		/**
		 * 移除一条本地数据
		 * 
		 * @param	name 本地数据的名称
		 */
		public static function removeLocal(name:String):void
		{
			_diContainer.removeLocal(name);
		}
		
		/**
		 * 判断是否存在指定的本地数据
		 * 
		 * @param	name 本地数据名称
		 * 
		 * @return
		 */
		public static function hasLocal(name:String):Boolean
		{
			return _diContainer.hasLocal(name);
		}
		
		/**
		 * 创建一个注入对象
		 * 
		 * @param	id 注入对象的ID
		 * 
		 * @return
		 */
		public static function createObject(id:String):*
		{
			return _diContainer.createObject(id);
		}
		
		/**
		 * 判断是否存在指定的命令
		 * 
		 * @param	commandName 命令的名称
		 * 
		 * @return
		 */
		public static function hasCommand(commandName:String):Boolean
		{
			return _diContainer == null ? false : _diContainer.hasObject(commandName);
		}
		
		/**
		 * 执行指定的命令。
		 * 如果执行命令的中存在异常信息，将被写入日志。
		 * 
		 * @param	commandName 命令的名称
		 * @param	data 执行命令所需的数据
		 * 
		 * @return 返回命令的返回值
		 */
		public static function exeucteCommand(commandName:String, data:Object = null):*
		{
			if(_diContainer == null)
			{
				return null;
			}
			else
			{
				var result:*;
				
				try
				{
					result = _diContainer.createObject(commandName).execute(data);
				}
				catch(error:Error)
				{
					throwGlobalException(Exceptions.EXECUTE_COMMAND_EXCEPTION, { error:error });
				}
				
				return result;
			}
		}
		
		private static function removeListeners():void
		{
			_diContainer.removeEventListener(DiContainerEvent.COMPLETE, completeHandler);
			_diContainer.removeEventListener(DiContainerEvent.IO_ERROR, ioErrorHandler);
			_diContainer.removeEventListener(DiContainerEvent.SECURITY_ERROR, securityErrorHandler);
		}
		
		private static function breakHandlers():void
		{
			_loadDICompleteHandler = null;
			_loadDIIOErrorHandler = null;
			_loadDISecurityErrorHandler = null;
		}
		
		private static function exeucteLoadDIHandler(handler:Function, event:DiContainerEvent):void
		{
			if (handler != null)
			{
				if (handler.length == 0)
				{
					handler();
				}
				else
				{
					handler(event);
				}
			}
		}
		
		private static function completeHandler(event:DiContainerEvent):void
		{
			exeucteLoadDIHandler(_loadDICompleteHandler, event);
			removeListeners();
			breakHandlers();
			
			trace("Load di Okey!");
		}
		
		private static function ioErrorHandler(event:DiContainerEvent):void
		{
			exeucteLoadDIHandler(_loadDIIOErrorHandler, event);
			removeListeners();
			breakHandlers();
			throwGlobalException(Exceptions.LOAD_DI_IO_EXCEPTION, { source:event.source });
		}
		
		private static function securityErrorHandler(event:DiContainerEvent):void
		{
			exeucteLoadDIHandler(_loadDISecurityErrorHandler, event);
			removeListeners();
			breakHandlers();
			throwGlobalException(Exceptions.LOAD_DI_SECURITY_EXCEPTION, { source:event.source });
		}
	}
}