package com.codeTooth.actionscript.game.connection.local
{
	import com.codeTooth.actionscript.lang.exceptions.NullPointerException;
	import com.codeTooth.actionscript.lang.exceptions.UnsupportedException;
	import com.codeTooth.actionscript.lang.utils.destroy.IDestroy;
	
	import flash.events.AsyncErrorEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.SecurityErrorEvent;
	import flash.events.StatusEvent;
	import flash.net.LocalConnection;

	/**
	 * 双工的LocalConnection
	 */
	public class LocalCommunication extends EventDispatcher implements IDestroy
	{
		/**
		 * 构造函数
		 * 
		 * @throws com.codeTooth.actionscript.lang.exceptions.UnsupportedException 
		 * 当前平台不支持LocalConnection
		 */
		public function LocalCommunication():void
		{
			if(!LocalConnection.isSupported)
			{
				throw new UnsupportedException("Unsupport LocalConnection platform.");
			}
		}
		
		// 接收数据绑定的名称
		private var _bindName:String = null;
		
		// 发送数据的目标名称
		private var _connectionName:String = null;
		
		// 接收数据的回调对象
		private var _client:Object = null;
		
		// 接收数据的域
		private var _domain:String = null;
		
		/**
		 * 开始通讯。
		 * 如果只指定bindName和client，那么只能接收数据。
		 * 如果指定了connectionName，那么只能发送数据。
		 * domain使用默认的null，那么只能在相同的域中的通信。
		 * 
		 * @param bindName 接收数据绑定的名称
		 * @param client 接收数据的回调对象
		 * @param connectionName 发送数据的目标名称
		 * @param domain 接收数据的域
		 * 
		 * @throws com.codeTooth.actionscript.lang.exceptions.NullPointerException 
		 * 指定了接收数据的名称，但没有同时指定接收数据的回调对象
		 */
		public function open(bindName:String = null, client:Object = null, connectionName:String = null, domain:String = null):void
		{
			if(bindName != null && client == null)
			{
				throw new NullPointerException("Null client");
			}
			
			_client = client;
			_bindName = bindName;
			_connectionName = connectionName;
			_domain = domain;
			
			destroyInput();
			destroyOutput();
			initializeInput();
			initializeOutput();
		}
		
		/**
		 * 发送数据
		 * 
		 * @param methodName 接收方的回调方法名
		 * @param data 发送给接收方的数据
		 */
		public function send(methodName:String, data:Object = null):void
		{
			if(data == null)
			{
				_output.send(_connectionName, methodName);
			}
			else
			{
				_output.send(_connectionName, methodName, data);
			}
		}
		
		/**
		 * 关闭输入输出流
		 */
		public function close():void
		{
			destroyInput();
			destroyOutput();
		}
		
		/**
		 * 发送数据的目标名称
		 */
		public function get connectionName():String
		{
			return _connectionName;
		}
		
		/**
		 * 接收数据绑定的名称
		 */
		public function get bindName():String
		{
			return _bindName;
		}
		
		//----------------------------------------------------------------------------------------------------------------------------------
		// InputStream
		//----------------------------------------------------------------------------------------------------------------------------------
		
		private var _input:LocalConnection = null;
		
		private function initializeInput():void
		{
			if(_bindName != null)
			{
				_input = new LocalConnection();
				_input.client = _client;
				_input.connect(_bindName);
				
				if(_domain != null)
				{
					_input.allowDomain(_domain);
				}
			}
		}
		
		private function destroyInput():void
		{
			if(_input != null)
			{
				try
				{
					_input.close();
				} 
				catch(error:Error) 
				{
					// Do nothing
				}
				_input = null;
			}
		}
		
		//----------------------------------------------------------------------------------------------------------------------------------
		// OutputStream
		//----------------------------------------------------------------------------------------------------------------------------------
		
		private var _output:LocalConnection = null;
		
		private function initializeOutput():void
		{
			if(_connectionName != null)
			{
				_output = new LocalConnection();
				_output.addEventListener(AsyncErrorEvent.ASYNC_ERROR, asyncErrorHandler);
				_output.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
				_output.addEventListener(StatusEvent.STATUS, statusHandler);
			}
		}
		
		private function statusHandler(event:StatusEvent):void
		{
			dispatchEventInternal(LocalCommunicationEvent.SEND_FAILURE, event);
		}
		
		private function securityErrorHandler(event:SecurityErrorEvent):void
		{
			dispatchEventInternal(LocalCommunicationEvent.SECURITY_ERROR, event);
		}
		
		private function asyncErrorHandler(event:AsyncErrorEvent):void
		{
			dispatchEventInternal(LocalCommunicationEvent.ASYNC_ERROR, event);
		}
		
		private function dispatchEventInternal(type:String, event:Event):void
		{
			var newEvent:LocalCommunicationEvent = new LocalCommunicationEvent(type);
			newEvent.event = event;
			dispatchEvent(newEvent);
		}
		
		private function destroyOutput():void
		{
			if(_output != null)
			{
				_output.removeEventListener(AsyncErrorEvent.ASYNC_ERROR, asyncErrorHandler);
				_output.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
				_output.removeEventListener(StatusEvent.STATUS, statusHandler);
				
				try
				{
					_output.close();
				} 
				catch(error:Error) 
				{
					// Do nothing
				}
				_output = null;
			}
		}
		
		//----------------------------------------------------------------------------------------------------------------------------------
		// 实现 IDestroy 接口
		//----------------------------------------------------------------------------------------------------------------------------------
		
		public function destroy():void
		{
			close();
		}
		
	}
}