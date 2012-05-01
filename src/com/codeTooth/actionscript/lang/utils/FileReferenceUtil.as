package com.codeTooth.actionscript.lang.utils
{
	import flash.events.Event;
	import flash.net.FileReference;

	public class FileReferenceUtil
	{
		private static var _file:FileReference = null;
		
		private static var _completeCallback:Function = null;
		
		public static function browse(completeCallback:Function/*func(bytes:ByteArray):void*/ = null, typeFilter:Array = null):Boolean
		{
			if(_file == null)
			{
				_completeCallback = completeCallback;
				_file = new FileReference();
				_file.addEventListener(Event.SELECT, selectHandler);
				_file.addEventListener(Event.CANCEL, cancelHandler);
				_file.addEventListener(Event.COMPLETE, completeHandler);
				_file.browse(typeFilter);
				return true;
			}
			else
			{
				return false;
			}
		}
		
		public static function save(data:Object, defaultFileName:String = null):void
		{
			var file:FileReference = new FileReference();
			file.save(data, defaultFileName);
		}
		
		private static function completeHandler(event:Event):void
		{
			if(_completeCallback != null)
			{
				_completeCallback(_file.data);
				_completeCallback = null;
			}
			destroyFile();
		}
		
		private static function cancelHandler(event:Event):void
		{
			destroyFile();
		}
		
		private static function selectHandler(event:Event):void
		{
			_file.load();
		}
		
		private static function destroyFile():void
		{
			if(_file != null)
			{
				_file.cancel();
				_file.removeEventListener(Event.SELECT, selectHandler);
				_file.removeEventListener(Event.CANCEL, cancelHandler);
				_file.removeEventListener(Event.COMPLETE, completeHandler);
				_file = null;
			}
		}
	}
}