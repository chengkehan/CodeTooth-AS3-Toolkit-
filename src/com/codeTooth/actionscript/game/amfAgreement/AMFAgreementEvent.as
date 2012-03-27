package com.codeTooth.actionscript.game.amfAgreement
{
	import flash.events.Event;
	
	/**
	 * AMF协议事件
	 */
	public class AMFAgreementEvent extends Event
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
		 * 与事件相关的source对象 
		 */
		public var source:Object = null;

		public function AMFAgreementEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
		override public function clone():Event
		{
			var newEvent:AMFAgreementEvent = new AMFAgreementEvent(type, bubbles, cancelable);
			newEvent.source = source;
			return newEvent;
		}
	}
}