package com.codeTooth.actionscript.game.connection.socket
{
	import flash.events.Event;
	
	/**
	 * 客户端Socket事件
	 */
	public class ClientSocketEvent extends Event
	{
		/**
		 * 成功的连接到一台主机
		 */
		public static const CONNECT:String = "connect";
		
		/**
		 * Socket发生IOError
		 */
		public static const IO_ERROR:String = "ioError";
		
		/**
		 * Socket发生SecurityError
		 */
		public static const SECURITY_ERROR:String = "securityError";
		
		/**
		 * 主机主动的关闭了连接
		 */
		public static const CLOSE:String = "close";
		
		/**
		 * Socket接受和发送数据时发生了错误
		 */
		public static const SOCKET_DATA_ERROR:String = "socketDataError";
		
		
		/**
		 * 接受和发送数据时发生错误的具体错误对象
		 */
		public var error:Error = null;
		
		public function ClientSocketEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
		override public function clone():Event
		{
			var newEvent:ClientSocketEvent = new ClientSocketEvent(type, bubbles, cancelable);
			newEvent.error = error;
			
			return newEvent;
		}
	}
}