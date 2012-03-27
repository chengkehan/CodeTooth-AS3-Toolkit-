package com.codeTooth.actionscript.game.amfAgreement
{
	import com.codeTooth.actionscript.lang.exceptions.NullPointerException;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	/**
	 * 通过URL路径加载AMF协议
	 */
	public class AMFAgreementURLLoader extends EventDispatcher implements IAMFAgreementLoader
	{
		private var _parser:IAMFAgreementParser = null;
		
		/**
		 * 构造函数
		 * 
		 * @param parser 指定解析加载得到的数据的解析器
		 * 
		 * @throws com.codeTooth.actionscript.lang.exceptions.NullPointerException 
		 * 入参是null
		 */
		public function AMFAgreementURLLoader(parser:IAMFAgreementParser)
		{
			if(parser == null)
			{
				throw new NullPointerException("Null parser");
			}
			_parser = parser;
		}
		
		//----------------------------------------------------------------------------------------------------------------------------------
		// 实现 IAMFAgreementLoader 接口
		//----------------------------------------------------------------------------------------------------------------------------------
		
		// 加载器
		private var _loader:URLLoader = null;
		
		// 指定的加载路径
		private var _source:Object = null;
		
		// 存储加载到的数据
		private var _dataLoaded:Object = null;
		
		/**
		 * @inheritDoc
		 */
		public function close():void
		{
			if(_loader != null)
			{
				removeLoaderListeners();
				try
				{
					_loader.close();
				}
				catch(error:Error)
				{
					// Do nothing
				}
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function getAMFAgreementXML():XML
		{
			return _parser.parse(_dataLoaded);
		}
		
		/**
		 * 开始加载
		 * 
		 * @param source 应该是一个URL字符串
		 */
		public function load(source:Object):void
		{
			if(_loader == null)
			{
				_loader = new URLLoader();
			}
			
			_source = source;
			close();
			addLoaderListeners();
			_loader.load(new URLRequest(String(_source)));
		}
		
		// 添加加载器的侦听
		private function addLoaderListeners():void
		{
			_loader.addEventListener(Event.COMPLETE, completeHandler);
			_loader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			_loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
		}
		
		// 移除加载器的侦听
		private function removeLoaderListeners():void
		{
			_loader.removeEventListener(Event.COMPLETE, completeHandler);
			_loader.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			_loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
		}
		
		// 加载遇到SecurityError
		private function securityErrorHandler(event:SecurityErrorEvent):void
		{
			close();
			dispatchEventInternal(AMFAgreementEvent.SECURITY_ERROR);
		}
		
		// 加载遇到IOError
		private function ioErrorHandler(event:IOErrorEvent):void
		{
			close();
			dispatchEventInternal(AMFAgreementEvent.IO_ERROR);
		}
		
		// 加载完成
		private function completeHandler(event:Event):void
		{
			_dataLoaded = _loader.data;
			
			close();
			dispatchEventInternal(AMFAgreementEvent.COMPLETE);
		}
		
		private function dispatchEventInternal(type:String):void
		{
			var newEvent:AMFAgreementEvent = new AMFAgreementEvent(type);
			newEvent.source = _source;
			dispatchEvent(newEvent);
		}
		
		//----------------------------------------------------------------------------------------------------------------------------------
		// 实现 IDestroy 接口
		//----------------------------------------------------------------------------------------------------------------------------------
		
		/**
		 * @inheritDoc
		 */
		public function destroy():void
		{
			close();
			_loader = null;
			_dataLoaded = null;
			_source = null;
		}
	}
}