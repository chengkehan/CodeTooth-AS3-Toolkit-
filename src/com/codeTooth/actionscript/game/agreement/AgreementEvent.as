package com.codeTooth.actionscript.game.agreement
{
	import flash.events.Event;
	
	/**
	 * 协议事件
	 */
	public class AgreementEvent extends Event
	{
		/**
		 * 加载协议完成
		 */
		public static const COMPLETE:String = "complete";
		
		/**
		 * 加载协议发生IOError
		 */
		public static const IO_ERROR:String = "ioError";
		
		/**
		 * 加载协议发生SecurityError
		 */
		public static const SECURITY_ERROR:String = "securityError";
		
		/**
		 * 加载协议时传入的source
		 */
		public var source:Object = null;
		
		public function AgreementEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
		override public function clone():Event
		{
			var newEvent:AgreementEvent = new AgreementEvent(type, bubbles, cancelable);
			newEvent.source = source;
			
			return newEvent;
		}
	}
}