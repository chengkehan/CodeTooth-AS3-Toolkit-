package com.codeTooth.actionscript.lang.utils.newLoop
{
	import flash.events.Event;
	
	public class MainLoopEvent extends Event
	{
		public static const FPS_CHANGED:String = "fpsChanged";
		
		public var prevFPS:int = 0;
		
		public var currFPS:int = 0;
		
		public function MainLoopEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
		override public function clone():Event
		{
			var newEvent:MainLoopEvent = new MainLoopEvent(type, bubbles, cancelable);
			newEvent.prevFPS = prevFPS;
			newEvent.currFPS = currFPS;
			
			return newEvent;
		}

	}
}