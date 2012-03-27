package com.codeTooth.actionscript.lang.exceptions 
{
	import flash.events.ErrorEvent;
	import flash.events.Event;
	
	public class AdvancedGlobalExceptionEvent extends ErrorEvent 
	{
		public static const GLOBAL_EXCEPTION:String = "globalException";
		
		public var data:Object = null;
		
		public function AdvancedGlobalExceptionEvent(data:Object = null) 
		{ 
			super(GLOBAL_EXCEPTION, true, false);
			this.data = data;
		} 
		
		public override function clone():Event 
		{ 
			return new AdvancedGlobalExceptionEvent(data);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("AdvancedGlobalExceptionEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}