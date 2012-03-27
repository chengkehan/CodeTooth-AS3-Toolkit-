package com.codeTooth.actionscript.lang.exceptions
{
	import flash.events.ErrorEvent;
	import flash.events.Event;
	
	/**
	 * 全局异常事件
	 */
	public class GlobalExceptionEvent extends ErrorEvent
	{
		/**
		 * 全局异常事件类型
		 */
		public static const GLOBAL_EXCEPTION:String = "globalException";
		
		public var data:Object = null;
		
		public function GlobalExceptionEvent(type:String, bubbles:Boolean = false, text:String="")
		{
			super(type, bubbles, false, text);
		}
		
		override public function clone():Event
		{
			var newEvent:GlobalExceptionEvent = new GlobalExceptionEvent(type, bubbles, text);
			newEvent.data = data;
			
			return newEvent;
		}
		
		override public function toString():String
		{
			return formatToString("GlobalExceptionEvent", "type", "bubbles", "text", "data");
		}
	}
}