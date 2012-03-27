package com.codeTooth.actionscript.air.template.application.baby.util.exception
{
	import com.codeTooth.actionscript.air.template.application.baby.util.log.Log;
	import com.codeTooth.actionscript.air.template.application.baby.util.string.LogMessage;
	import com.codeTooth.actionscript.lang.exceptions.GlobalExceptionEvent;
	import com.codeTooth.actionscript.lang.utils.Common;
	import flash.events.ErrorEvent;
	
	import flash.utils.Dictionary;
	
	/**
	 * @private
	 * 
	 * 异常处理
	 */
	public class ExceptionHandlers
	{
		{
			_contexts[ExceptionHandlers] = ExceptionHandlers;
		}
		private static var _contexts:Dictionary = new Dictionary();
		
		public static function addContext(context:Object):Object
		{
			_contexts[context] = context;
			
			return context;
		}
		
		public static function removeContext(context:Object):Object
		{
			var context:Object = _contexts[context];
			delete _contexts[context];
			
			return context;
		}
		
		public static function exceptionHandler(event:GlobalExceptionEvent):void
		{
			for each(var context:Object in _contexts)
			{
				if(event.text in context)
				{
					context[event.text](event.data);
				}
			}
		}
		
		public static function loadAppInitDataException(data:Object):void
		{
			Log.writeError(LogMessage.LOAD_APP_INIT_DATA_EXCEPTION, data.error);
		}
		
		public static function createMenuException(data:Object):void
		{
			Log.writeError(LogMessage.CREATE_MENU_EXCEPTION, data.error);
		}
		
		public static function loadDIIOException(data:Object):void
		{
			Log.write(LogMessage.LOAD_DI_IO_EXCEPTION + Common.NEW_LINE + data.source);
		}
		
		public static function loadDISecurityException(data:Object):void
		{
			Log.write(LogMessage.LOAD_DI_SECURITY_EXCEPTION + Common.NEW_LINE + data.source);
		}
		
		public static function loadCommandsIOException(data:Object):void
		{
			Log.writeErrorEvent(LogMessage.LOAD_COMMANDS_IO_EXCEPTION, data.event);
		}
		
		public static function loadCommandsSecurityException(data:Object):void
		{
			Log.writeErrorEvent(LogMessage.LOAD_COMMANDS_SECURITY_EXCEPTION, data.event);
		}
		
		public static function loadSkinIOException(data:Object):void
		{
			Log.writeErrorEvent(LogMessage.LOAD_SKIN_IO_EXCEPTION, data.event);
		}
		
		public static function loadSkinSecurityException(data:Object):void
		{
			Log.writeErrorEvent(LogMessage.LOAD_SKIN_SECURITY_EXCEPTION, data.event);
		}
		
		public static function loadStyleIOException(data:Object):void
		{
			Log.writeErrorEvent(LogMessage.LOAD_STYLE_IO_EXCEPTION, data.event);
		}
		
		public static function loadStyleSecurityException(data:Object):void
		{
			Log.writeErrorEvent(LogMessage.LOAD_STYLE_SECURITY_EXCEPTION, data.event);
		}
		
		public static function saveAppInitDataException(data:Object):void
		{
			Log.writeError(LogMessage.SAVE_APP_INIT_DATA_EXCEPTION, data.error);
		}
		
		public static function executeCommandException(data:Object):void
		{
			Log.writeError(LogMessage.EXECUTE_COMMAND_EXCEPTION, data.error);
		}
		
		public static function uncaughtException(data:Object):void
		{
			if (data.error == null)
			{
				Log.write(LogMessage.UNCAUGHT_EXCEPTION);
			}
			else if (data.error is Error)
			{
				Log.writeError(LogMessage.UNCAUGHT_EXCEPTION, data.error);
			}
			else if (data.error is ErrorEvent)
			{
				Log.writeErrorEvent(LogMessage.UNCAUGHT_EXCEPTION, data.error);
			}
			else
			{
				Log.write(LogMessage.UNCAUGHT_EXCEPTION + Common.NEW_LINE + data.error.toString());
			}
		}
	}
}