package com.codeTooth.actionscript.game.connection.local
{
	import flash.events.Event;
	
	public class LocalCommunicationEvent extends Event
	{
		public static const SECURITY_ERROR:String = "securityError";
		
		public static const ASYNC_ERROR:String = "asyncError";
		
		public static const SEND_FAILURE:String = "sendFailure";
		
		public var event:Event = null;
		
		public function LocalCommunicationEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
		override public function clone():Event
		{
			var newEvent:LocalCommunicationEvent = new LocalCommunicationEvent(type, bubbles, cancelable);
			newEvent.event = event;
			
			return newEvent;
		}
	}
}