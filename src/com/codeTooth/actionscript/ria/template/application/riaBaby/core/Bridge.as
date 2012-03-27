package com.codeTooth.actionscript.ria.template.application.riaBaby.core
{
	import com.codeTooth.actionscript.dependencyInjection.core.DiContainer;
	import com.codeTooth.actionscript.dependencyInjection.core.DiContainerEvent;
	import com.codeTooth.actionscript.dependencyInjection.core.DiURLLoader;
	import com.codeTooth.actionscript.dependencyInjection.core.DiXMLLoadedDataParser;
	import com.codeTooth.actionscript.dependencyInjection.core.DiXMLLoader;
	import com.codeTooth.actionscript.lang.exceptions.AdvancedGlobalExceptionEvent;
	import com.codeTooth.actionscript.lang.exceptions.AdvancedGlobalExceptionHandler;
	import com.codeTooth.actionscript.lang.exceptions.IllegalParameterException;
	import com.codeTooth.actionscript.lang.utils.destroy.IDestroy;
	import com.codeTooth.actionscript.lang.utils.Messager;
	import com.codeTooth.actionscript.patterns.observer.IObserver;
	import com.codeTooth.actionscript.patterns.observer.Subject;
	import com.codeTooth.actionscript.ria.template.application.riaBaby.command.ICommand;
	import com.codeTooth.actionscript.ria.template.application.riaBaby.exception.ExceptionDataBase;
	import com.codeTooth.actionscript.ria.template.application.riaBaby.message.MessageDataBase;
	import flash.display.Stage;
	import flash.system.ApplicationDomain;
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;
	
	/**
	 * 将开发中的对象依赖转移到此，起到桥梁的作用
	 */
	public class Bridge implements IDestroy
	{
		/**
		 * 构造函数
		 * 
		 * @param	stage	舞台对象。该参数将关联到创建异常处理对象
		 * @param	exceptionHandlerFunc	异常处理函数。原型func(data:ExceptionDataBase):void，入参也可以用任何ExceptionDataBase的子类
		 * @param	diData	注入的数据。可以是xml或者url。该参数将关联到创建注入容器对象
		 * @param	relativePath	注入数据中指定的相对路径。没有就是传null
		 * @param	diCompleteHandler	完成注入处理函数，原型func(event:DiContainerEvent):void或func(void):void
		 * @param	diIOErrorHandler	加载注入发生I/O异常的处理函数，原型func(event:DiContainerEvent):void或func(void):void
		 * @param	diSecurityErrorHandler	加载注入发生安全沙箱异常的处理函数，原型func(event:DiContainerEvent):void或func(void):void
		 */
		public function Bridge(stage:Stage = null, exceptionHandlerFunc:Function = null, 
			diData:Object = null, relativePath:String = null, diCompleteHandler:Function = null, diIOErrorHandler:Function = null, diSecurityErrorHandler:Function = null) 
		{
			initializeGlobalExceptionHandler(stage, exceptionHandlerFunc);
			initializeDIContainer(diData, relativePath, diCompleteHandler, diIOErrorHandler, diSecurityErrorHandler);
			_messager = new Messager();
		}
		
		//------------------------------------------------------------------------------------------------------------------------------------------------------
		// Messager
		//------------------------------------------------------------------------------------------------------------------------------------------------------
		
		/**
		 * 默认的信息ID
		 */
		public var defaultMessageID:Object = null;
		
		private var _messager:Messager = null;
		
		/**
		 * 如果消息ID是默认的null，则表示使用defaultMessageID
		 * 
		 * @copy com.codeTooth.actionscript.lang.utils.Messager#notifyMessage()
		 */
		public function notifyMessage(data:MessageDataBase = null, messageID:Object = null):Subject
		{
			return _messager.notifyMessage(messageID == null ? defaultMessageID : messageID, data);
		}
		
		/**
		 * @copy com.codeTooth.actionscript.lang.utils.Messager#notifyMessages()
		 */
		public function notifyMessages(data:MessageDataBase):void
		{
			return _messager.notifyMessages(data);
		}
		
		/**
		 * @copy com.codeTooth.actionscript.lang.utils.Messager#addMessage()
		 */
		public function addMessage(id:Object, message:Subject = null):Subject
		{
			return _messager.addMessage(id, message);
		}
		
		/**
		 * @copy com.codeTooth.actionscript.lang.utils.Messager#removeMessage()
		 */
		public function removeMessage(id:Object):Subject
		{
			return _messager.removeMessage(id);
		}
		
		/**
		 * @copy com.codeTooth.actionscript.lang.utils.Messager#removeMessages()
		 */
		public function removeMessages():void
		{
			return _messager.removeMessages();
		}
		
		/**
		 * @copy com.codeTooth.actionscript.lang.utils.Messager#getMessage()
		 */
		public function getMessage(id:Object):Subject
		{
			return _messager.getMessage(id);
		}
		
		/**
		 * @copy com.codeTooth.actionscript.lang.utils.Messager#getMessages()
		 */
		public function getMessages():Dictionary
		{
			return _messager.getMessages();
		}
		
		/**
		 * @copy com.codeTooth.actionscript.lang.utils.Messager#containsMessage()
		 */
		public function containsMessage(id:Object):Boolean
		{
			return _messager.containsMessage(id);
		}
		
		/**
		 * 如果消息ID是默认的null，则表示使用defaultMessageID
		 * 
		 * @copy com.codeTooth.actionscript.lang.utils.Messager#followMessage()
		 */
		public function followMessage(target:IObserver, messageID:Object = null):IObserver
		{
			return _messager.followMessage(messageID == null ? defaultMessageID : messageID, target);
		}
		
		/**
		 * 如果消息ID是默认的null，则表示使用defaultMessageID
		 * 
		 * @copy com.codeTooth.actionscript.lang.utils.Messager#unfollowMessage()
		 */
		public function unfollowMessage(target:IObserver, messageID:Object = null):IObserver
		{
			return _messager.unfollowMessage(messageID == null ? defaultMessageID : messageID, target);
		}
		
		/**
		 * @copy com.codeTooth.actionscript.lang.utils.Messager#unfollowMessages()
		 */
		public function unfollowMessages(target:IObserver):void
		{
			_messager.unfollowMessages(target);
		}
		
		/**
		 * @copy com.codeTooth.actionscript.lang.utils.Messager#getFollowingMessages()
		 */
		public function getFollowingMessages(target:IObserver):Vector.<Subject>
		{
			return _messager.getFollowingMessages(target);
		}
		
		private function destroyMessager():void
		{
			if (_messager != null)
			{
				_messager.destroy();
				_messager = null;
			}
		}
		
		//------------------------------------------------------------------------------------------------------------------------------------------------------
		// GlobalExceptionHandler
		//------------------------------------------------------------------------------------------------------------------------------------------------------
		
		private var _globalExceptionHandler:AdvancedGlobalExceptionHandler = null;
		
		/**
		 * @copy com.codeTooth.actionscript.lang.exceptions.AdvancedGlobalExceptionHandler#throwGlobalException()
		 */
		public function throwGlobalException(data:ExceptionDataBase):void
		{	
			_globalExceptionHandler.throwGlobalException(new AdvancedGlobalExceptionEvent(data));
		}
		
		private function initializeGlobalExceptionHandler(stage:Stage, exceptionHandlerFunc:Function):void
		{
			if (stage != null && exceptionHandlerFunc != null)
			{
				_globalExceptionHandler = new AdvancedGlobalExceptionHandler(stage, exceptionHandlerFunc);
			}
		}
		
		private function destroyGlobalExceptionHandler():void
		{
			if (_globalExceptionHandler != null)
			{
				_globalExceptionHandler.destroy();
				_globalExceptionHandler = null;
			}
		}
		
		//------------------------------------------------------------------------------------------------------------------------------------------------------
		// DiContainer
		//------------------------------------------------------------------------------------------------------------------------------------------------------
		
		private var _diContainer:DiContainer = null;
		
		private var _diCompleteHandler:Function = null;
		
		private var _diIOErrorHandler:Function = null;
		
		private var _diSecurityErrorHandler:Function = null;
		
		/**
		 * @copy com.codeTooth.actionscript.dependencyInjection.core.DiContainer#applicationDomain
		 */
		public function setApplicationDomain(appDomain:ApplicationDomain):ApplicationDomain
		{
			if (appDomain == null)
			{
				return null;
			}
			else
			{
				_diContainer.applicationDomain = appDomain;
				
				return appDomain;
			}
		}
		
		/**
		 * @copy com.codeTooth.actionscript.dependencyInjection.core.DiContainer#applicationDomain
		 */
		public function getApplicationDomain():ApplicationDomain
		{
			return _diContainer.applicationDomain;
		}
		
		/**
		 * @copy com.codeTooth.actionscript.dependencyInjection.core.DiContainer#addLocal()
		 */
		public function addLocal(name:String, data:Object):void
		{
			_diContainer.addLocal(name, data);
		}
		
		/**
		 * @copy com.codeTooth.actionscript.dependencyInjection.core.DiContainer#removeLocal()
		 */
		public function removeLocal(name:String):void
		{
			_diContainer.removeLocal(name);
		}
		
		/**
		 * @copy com.codeTooth.actionscript.dependencyInjection.core.DiContainer#getLocal()
		 */
		public function getLocal(name:String):*
		{
			return _diContainer.getLocal(name);
		}
		
		/**
		 * @copy com.codeTooth.actionscript.dependencyInjection.core.DiContainer#hasLocal()
		 */
		public function hasLocal(name:String):Boolean
		{
			return _diContainer.hasLocal(name);
		}
		
		/**
		 * @copy com.codeTooth.actionscript.dependencyInjection.core.DiContainer#createObject()
		 */
		public function createObject(id:*):*
		{
			return _diContainer.createObject(id);
		}
		
		/**
		 * @copy com.codeTooth.actionscript.dependencyInjection.core.DiContainer#hasObject()
		 */
		public function hasObject(id:String):Boolean
		{
			return _diContainer.hasObject(id);
		}
		
		/**
		 * 创建一个命令
		 * 
		 * @param	id
		 * 
		 * @return
		 */
		public function createCommand(id:*):ICommand
		{
			return _diContainer.createObject(id);
		}
		
		/**
		 * 执行一个命令
		 * 
		 * @param	id
		 * @param	data
		 * 
		 * @return
		 */
		public function executeCommand(id:*, data:Object = null):*
		{
			return _diContainer.createObject(id).execute(data);
		}
		
		private function initializeDIContainer(diData:Object = null, relativePath:String = null, pDICompleteHandler:Function = null, pDIIOErrorHandler:Function = null, pDISecurityErrorHandler:Function = null):void
		{
			if (diData != null)
			{
				_diContainer = new DiContainer();
				_diCompleteHandler = pDICompleteHandler;
				_diIOErrorHandler = pDIIOErrorHandler;
				_diSecurityErrorHandler = pDISecurityErrorHandler;
				_diContainer.addEventListener(DiContainerEvent.COMPLETE, diCompleteHandler);
				_diContainer.addEventListener(DiContainerEvent.IO_ERROR, diIOErrorHandler);
				_diContainer.addEventListener(DiContainerEvent.SECURITY_ERROR, diSecurityErrorHandler);
				
				if (relativePath != null)
				{
					_diContainer.addLocal("relativePath", relativePath);
				}
				
				if (diData is String)
				{
					_diContainer.load(new DiURLLoader(new DiXMLLoadedDataParser()), diData);
				}
				else if (diData is XML)
				{
					_diContainer.load(new DiXMLLoader(), diData);
				}
				else
				{
					throw new IllegalParameterException("Error diData type \"" + getQualifiedClassName(diData) + "\"");
				}
			}
		}
		
		private function executeDIHandler(handler:Function, event:DiContainerEvent):void
		{
			if (handler != null)
			{
				handler.length == 0 ? handler() : handler(event);
			}
		}
		
		private function diCompleteHandler(event:DiContainerEvent):void 
		{
			executeDIHandler(_diCompleteHandler, event);
		}
		
		private function diIOErrorHandler(event:DiContainerEvent):void 
		{
			executeDIHandler(_diIOErrorHandler, event)
		}
		
		private function diSecurityErrorHandler(event:DiContainerEvent):void 
		{
			executeDIHandler(_diSecurityErrorHandler, event)
		}
		
		private function destroyDiContainer():void
		{
			if (_diContainer != null)
			{
				_diContainer.destroy();
				_diContainer.removeEventListener(DiContainerEvent.COMPLETE, diCompleteHandler);
				_diContainer.removeEventListener(DiContainerEvent.IO_ERROR, diIOErrorHandler);
				_diContainer.removeEventListener(DiContainerEvent.SECURITY_ERROR, diSecurityErrorHandler);
				_diCompleteHandler = null;
				_diIOErrorHandler = null;
				_diSecurityErrorHandler = null;
				_diContainer = null;
			}
		}
		
		//------------------------------------------------------------------------------------------------------------------------------------------------------
		// 实现 IDestroy 接口
		//------------------------------------------------------------------------------------------------------------------------------------------------------
		
		public function destroy():void
		{
			destroyDiContainer();
			destroyGlobalExceptionHandler();
			destroyMessager();
		}
	}

}