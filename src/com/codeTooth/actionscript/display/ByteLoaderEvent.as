package com.codeTooth.actionscript.display
{
	import flash.events.Event;
	
	public class ByteLoaderEvent extends Event
	{
		public static const URL_LOADER_COMPLETE:String = "urlLoaderComplete";
		
		public static const URL_LOADER_IO_ERROR:String = "urlLoaderIOError";
		
		public static const URL_LOADER_SECURITY_ERROR:String = "urlLoaderSecurityError";
		
		public static const LOADER_COMPLETE:String = "loaderComplete";
		
		public static const LOADER_IO_ERROR:String = "loaderIOError";
		
		public static const PROGRESS:String = "progress";
		
		public var url:String = null;
		
		public var bytesLoaded:uint = 0;
		
		public var bytesTotal:uint = 0;
		
		public function ByteLoaderEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
		override public function clone():Event
		{
			var newEvent:ByteLoaderEvent = new ByteLoaderEvent(type, bubbles, cancelable);
			newEvent.url = url;
			newEvent.bytesLoaded = bytesLoaded;
			newEvent.bytesTotal = bytesTotal;
			return newEvent;
		}
	}
}