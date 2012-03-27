package com.codeTooth.actionscript.localize.language
{
	import flash.events.Event;
	
	public class LanguageEvent extends Event
	{
		public static const COMPLETE:String = "complete";
		
		public static const IO_ERROR:String = "ioError";
		
		public static const SECURITY_ERROR:String = "securityError";
		
		public var source:Object = null;
		
		public function LanguageEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
		override public function clone():Event
		{
			var newEvent:LanguageEvent = new LanguageEvent(type, bubbles, cancelable);
			newEvent.source = source;
			return newEvent;
		}
	}
}