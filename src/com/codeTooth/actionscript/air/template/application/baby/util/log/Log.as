package com.codeTooth.actionscript.air.template.application.baby.util.log
{	
	import com.codeTooth.actionscript.lang.utils.Common;
	import flash.events.ErrorEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	
	/**
	 * @private
	 * 
	 * 日志
	 */
	public class Log
	{
		private static var _path:String = null;
		
		public static function set path(path:String):void
		{
			_path = path;
		}
		
		public static function get path():String
		{
			return _path;
		}
		
		public static function getFile():File
		{
			return _path == null ? null : new File(File.applicationDirectory.resolvePath(_path).nativePath);
		}
		
		public static function write(str:String):Boolean
		{
			if(_path != null && str != null)
			{
				try
				{
					var file:File = getFile();
					var exists:Boolean = file.exists;
					var fileStream:FileStream = new FileStream();
					fileStream.open(file, FileMode.APPEND);
					
					var date:Date = new Date();
					var message:String = (exists ? Common.NEW_LINE + Common.NEW_LINE + "// " : "// ") + date + Common.LINE_SEPARATOR + "\r\n" + str;
					
					CONFIG::DEBUG
					{
						trace("// Log print message" + Common.LINE_SEPARATOR);
						trace(message);
						trace(Common.LINE_SEPARATOR);
					}
					
					fileStream.writeUTFBytes(message);
					fileStream.close();
				}
				catch(error:Error)
				{
					// LogError
					// Do nothing
					trace("// Log error" + Common.LINE_SEPARATOR);
					trace(error.getStackTrace());
					return false;
				}
				
				return true;
			}
			else
			{
				return false;
			}
		}
		
		public static function writeErrorEvent(str:String, errorEvent:ErrorEvent):Boolean
		{
			if (str == null && errorEvent == null)
			{
				return false;
			}
			else
			{
				return write((str == null ? "" : str) + 
					(errorEvent == null ? "" : Common.NEW_LINE + "type:" + errorEvent.type + Common.NEW_LINE + "id:" + errorEvent.errorID + Common.NEW_LINE + errorEvent.text));
			}
		}
		
		public static function writeError(str:String, error:Error):Boolean
		{
			if (str == null && error == null)
			{
				return false;
			}
			else
			{
				return write((str == null ? "" : str) + 
					(error == null ? "" : Common.NEW_LINE + error.message + Common.NEW_LINE + error.getStackTrace()));
			}
		}
	}
}