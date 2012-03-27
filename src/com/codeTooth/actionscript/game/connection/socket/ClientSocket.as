package com.codeTooth.actionscript.game.connection.socket
{
	[Event(type="com.codeTooth.actionscript.game.connection.socket.ClientSocketEvent", name="connect")]
	
	[Event(type="com.codeTooth.actionscript.game.connection.socket.ClientSocketEvent", name="ioError")]
	
	[Event(type="com.codeTooth.actionscript.game.connection.socket.ClientSocketEvent", name="securityError")]
	
	[Event(type="com.codeTooth.actionscript.game.connection.socket.ClientSocketEvent", name="close")]
	
	[Event(type="com.codeTooth.actionscript.game.connection.socket.ClientSocketEvent", name="socketDataError")]
	
	import com.codeTooth.actionscript.lang.exceptions.IllegalOperationException;
	import com.codeTooth.actionscript.lang.exceptions.NullPointerException;
	import com.codeTooth.actionscript.lang.utils.destroy.IDestroy;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.Socket;
	import flash.utils.ByteArray;
	
	/**
	 * 客户端Socket
	 */
	public class ClientSocket extends EventDispatcher implements IDestroy
	{
		/**
		 * 构造函数
		 * 
		 * @param socketDataCallback 当socket接受到数据时，读入到缓冲去，把缓冲区交给这个函数处理。原型func(cache:ByteArray):void
		 * @param socket 指定的客户端socket对象。如果没有指定，使用默认的null，则会在内部创建一个socket对象，可以调用方法，控制连接到主机。
		 * 但是，如果指定了一个socket，那么视为这个socket已经连接上主机。
		 * 
		 * @throws com.codeTooth.actionscript.lang.exceptions.NullPointerException 
		 * 指定的socketDataCallback是null
		 */
		public function ClientSocket(socketDataCallback:Function, socket:Socket = null)
		{
			if(socketDataCallback == null)
			{
				throw new NullPointerException("Null socketDataCallback");
			}
			_socketDataCallback = socketDataCallback;
			
			initializeSocket(socket);
		}
		
		//----------------------------------------------------------------------------------------------------------------------------------
		// Socket
		//----------------------------------------------------------------------------------------------------------------------------------
		
		// Socket对象
		private var _socket:Socket = null;
		
		// 处于连接中
		private var _connecting:Boolean = false;
		
		// 已经连接上
		private var _connected:Boolean = false;
		
		// Socket接收到数据是回调
		private var _socketDataCallback:Function/*func(cache:ByteArray):void*/ = null;
		
		// socket输出缓冲
		private var _outputCache:ByteArray = null;
		
		// socket输入缓冲
		private var _inputCache:ByteArray= null;
		
		private var _localAddress:String = null;
		private var _localPort:int = 0;
		private var _remoteAddress:String = null;
		private var _remotePort:int = 0;
		
		public function get localAddress():String
		{
			return _localAddress;
		}
		
		public function get localPort():int
		{
			return _localPort;
		}
		
		public function get remoteAddress():String
		{
			return _remoteAddress;
		}
		
		public function get remotePort():int
		{
			return _remotePort;
		}
		
		public function get connecting():Boolean
		{
			return _connecting;
		}
		
		public function get connected():Boolean
		{
			return _connected;
		}
		
		/**
		 * 获得Socket对象
		 * 
		 * @return 
		 */
		public function getSocket():Socket
		{
			return _socket;
		}
		
		/**
		 * 获得Socket对象的输出缓冲，可以向这个缓冲中写入数据
		 * 
		 * @return 
		 */
		public function getEmptyOutputCache():ByteArray
		{
			_outputCache.clear();
			return _outputCache;
		}
		
		/**
		 * 把输出缓冲中的数据通过Socket发送出去
		 */
		public function sendOutputCache():void
		{
			try
			{
				_socket.writeBytes(_outputCache, 0, _outputCache.length);
				_socket.flush();
			}
			catch(error:Error)
			{
				close();
				dispatchSocketErrorEvent(error);
			}
		}
		
		public function getSocketDataCallback():Function
		{
			return _socketDataCallback;
		}
		
		/**
		 * 连接到指定的主句
		 * 
		 * @param host
		 * @param port
		 * 
		 * @return 返回是否成功连接
		 * 
		 * @throws com.codeTooth.actionscript.lang.exceptions.IllegalOperationException 
		 * 已经连接到了另一个主机上
		 */
		public function connect(host:String, port:uint):Boolean
		{
			if(_connecting)
			{
				return false;
			}
			if(_connected)
			{
				throw new IllegalOperationException(
					"Already connected to host : " + _socket.remoteAddress + ", port : " + _socket.remotePort
				);
				return false;
			}
			
			_outputCache.clear();
			_inputCache.clear();
			
			close();
			_connecting = true;
			_socket = new Socket();
			addSocketListeners();
			
			_socket.connect(host, port);
			
			return true;
		}
		
		/**
		 * 关闭socket的连接
		 */
		public function close():void
		{
			removeSocketListeners();
			try
			{
				if(_socket != null)
				{
					_socket.close();
				}
			}
			catch(error:Error)
			{
				// Do nothing
			}
			_connected = false;
			_connecting = false;
			_socket = null;
		}
		
		private function initializeSocket(socket:Socket):void
		{
			_socket = socket == null ? null : socket;
			addSocketListeners();
			
			_outputCache = new ByteArray();
			_inputCache = new ByteArray();
			
			if(socket != null)
			{
				_connecting = false;
				_connected = true;
				_localAddress = _socket.localAddress;
				_localPort = _socket.localPort;
				_remoteAddress = _socket.remoteAddress;
				_remotePort = _socket.remotePort;
			}
		}
		
		private function addSocketListeners():void
		{
			if(_socket != null)
			{
				_socket.addEventListener(Event.CONNECT, connectHandler);
				_socket.addEventListener(Event.CLOSE, closeHandler);
				_socket.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
				_socket.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
				_socket.addEventListener(ProgressEvent.SOCKET_DATA, socketDataHandler);
			}
		}
		
		private function removeSocketListeners():void
		{
			if(_socket != null)
			{
				_socket.removeEventListener(Event.CONNECT, connectHandler);
				_socket.removeEventListener(Event.CLOSE, closeHandler);
				_socket.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
				_socket.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
				_socket.removeEventListener(ProgressEvent.SOCKET_DATA, socketDataHandler);
			}
		}
		
		private function dispatchSocketErrorEvent(error:Error):void
		{
			var newEvent:ClientSocketEvent = new ClientSocketEvent(ClientSocketEvent.SOCKET_DATA_ERROR);
			newEvent.error = error;
			dispatchEvent(newEvent);
		}
		
		// 成功连接到主机上
		private function connectHandler(event:Event):void
		{
			_connecting = false;
			_connected = true;
			_localAddress = _socket.localAddress;
			_localPort = _socket.localPort;
			_remoteAddress = _socket.remoteAddress;
			_remotePort = _socket.remotePort;
			dispatchEvent(new ClientSocketEvent(ClientSocketEvent.CONNECT));
		}
		
		// 主机主动的关闭了连接
		private function closeHandler(event:Event):void
		{
			close();
			dispatchEvent(new ClientSocketEvent(ClientSocketEvent.CLOSE));
		}
		
		// socket发生IOError
		private function ioErrorHandler(event:IOErrorEvent):void
		{
			close();
			dispatchEvent(new ClientSocketEvent(ClientSocketEvent.IO_ERROR));
		}
		
		// socket发生SecurityError
		private function securityErrorHandler(event:SecurityErrorEvent):void
		{
			close();
			dispatchEvent(new ClientSocketEvent(ClientSocketEvent.SECURITY_ERROR));
		}
		
		// socket接受到来自主机的数据
		private function socketDataHandler(event:ProgressEvent):void
		{
			try
			{
				if(_socket.bytesAvailable)
				{
					_socket.readBytes(_inputCache, _inputCache.length, _socket.bytesAvailable);
					_socketDataCallback(_inputCache);
				}	
			}
			catch(error:Error)
			{
				close();
				dispatchSocketErrorEvent(error);
			}
		}
		
		//----------------------------------------------------------------------------------------------------------------------------------
		// 实现 IDestroy 接口
		//----------------------------------------------------------------------------------------------------------------------------------
		
		public function destroy():void
		{
			if(_socket != null)
			{
				close();
				_socketDataCallback = null;
				_outputCache.clear();
				_outputCache = null;
				_inputCache.clear();
				_inputCache = null;
			}
		}
	}
}