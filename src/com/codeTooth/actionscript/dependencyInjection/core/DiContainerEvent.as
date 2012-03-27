package com.codeTooth.actionscript.dependencyInjection.core 
{	
	import flash.events.Event;
	
	/**
	 * 加载注入内容的事件
	 */
	public class DiContainerEvent extends Event
	{
		/**
		 * 加载完成 
		 */		
		public static const COMPLETE:String = "complete";
		
		/**
		 * 加载发生IOError
		 */		
		public static const IO_ERROR:String = "ioError";
		
		/**
		 * 加载发生SecurityError
		 */		
		public static const SECURITY_ERROR:String = "securityError";
		
		/**
		 * 当前加载源
		 */		
		public var source:Object = null;
		
		/**
		 * @inheritDoc
		 */		
		public function DiContainerEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
		/**
		 * @inheritDoc
		 */
		override public function clone():Event
		{
			var newEvent:DiContainerEvent = new DiContainerEvent(type, bubbles, cancelable);
			newEvent.source = source;
			
			return newEvent;
		}
		
		/**
		 * @inheritDoc
		 */		
		override public function toString():String
		{
			return formatToString("DiContainerEvent", "type", "bubbles", "cancelable", "eventPhase", "source");
		}
	}
}