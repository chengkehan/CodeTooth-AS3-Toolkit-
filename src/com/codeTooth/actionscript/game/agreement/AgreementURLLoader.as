package com.codeTooth.actionscript.game.agreement
{
	import com.codeTooth.actionscript.lang.exceptions.NullPointerException;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;

	/**
	 * 协议加载器，根据协议文件路径加载协议
	 */
	public class AgreementURLLoader extends EventDispatcher implements IAgreementSourceLoader
	{
		private var _parser:IAgreementParser = null;
		
		public function AgreementURLLoader(parser:IAgreementParser)
		{
			if(parser == null)
			{
				throw new NullPointerException("Null parser");
			}
			_parser = parser;
		}
		
		//----------------------------------------------------------------------------------------------------------------------------------
		// 实现 IAgreementSourceLoader 接口
		//----------------------------------------------------------------------------------------------------------------------------------
		
		private var _loader:URLLoader = null;
		
		private var _loaderListenersAdded:Boolean = false;
		
		private var _source:Object = null;
		
		private var _xml:XML = null;
		
		public function load(source:Object):void
		{
			if(_loader == null)
			{
				_loader = new URLLoader();
			}
			close();
			addLoaderListeners();
			_loader.load(new URLRequest(String(source)));
		}
		
		public function close():void
		{
			closeLoader();
		}
		
		public function getAgreementXML():XML
		{
			return _xml;
		}
		
		private function closeLoader():void
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
		
		private function addLoaderListeners():void
		{
			if(_loader != null && !_loaderListenersAdded)
			{
				_loaderListenersAdded = true;
				_loader.addEventListener(Event.COMPLETE, completeHandler);
				_loader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
				_loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
			}
		}
		
		private function removeLoaderListeners():void
		{
			if(_loader != null && _loaderListenersAdded)
			{
				_loaderListenersAdded = false;
				_loader.removeEventListener(Event.COMPLETE, completeHandler);
				_loader.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
				_loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
			}
		}
		
		private function dispatchLoaderEvent(type:String):void
		{
			var newEvent:AgreementEvent = new AgreementEvent(type);
			newEvent.source = _source;
			dispatchEvent(newEvent);
		}
		
		private function completeHandler(event:Event):void
		{
			_xml = _parser.parse(_loader.data);
			removeLoaderListeners();
			dispatchLoaderEvent(AgreementEvent.COMPLETE);
		}
		
		private function ioErrorHandler(event:IOErrorEvent):void
		{
			removeLoaderListeners();
			dispatchLoaderEvent(AgreementEvent.IO_ERROR);
		}
		
		private function securityErrorHandler(event:SecurityErrorEvent):void
		{
			removeLoaderListeners();
			dispatchLoaderEvent(AgreementEvent.SECURITY_ERROR);
		}
		
		private function destroyLoader():void
		{
			closeLoader();
			_loader = null;
		}
		
		//----------------------------------------------------------------------------------------------------------------------------------
		// 实现 IDestroy 接口
		//----------------------------------------------------------------------------------------------------------------------------------
		
		public function destroy():void
		{
			_parser = null;
			_xml = null;
			destroyLoader();
		}
	}
}