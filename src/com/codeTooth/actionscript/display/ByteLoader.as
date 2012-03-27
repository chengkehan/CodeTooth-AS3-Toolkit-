package com.codeTooth.actionscript.display
{
	import com.codeTooth.actionscript.lang.utils.destroy.IDestroy;
	
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;
	
	public class ByteLoader extends EventDispatcher implements IDestroy
	{
		public function ByteLoader(byteProcessor:Function/*func(bytes:ByteArray):ByteArray*/ = null)
		{
			setByteProcessor(byteProcessor);
		}
		
		//----------------------------------------------------------------------------------------------------------------------------------
		// 
		//----------------------------------------------------------------------------------------------------------------------------------
		
		private var _context:LoaderContext = null;
		
		private var _request:URLRequest = null;
		
		private var _byteProcessor:Function = null;
		
		public function setByteProcessor(func:Function):void
		{
			_byteProcessor = func;
		}
		
		public function getByteProcessor():Function
		{
			return _byteProcessor;
		}
		
		public function load(request:URLRequest, contenxt:LoaderContext = null):void
		{
			_context = contenxt;
			_request = request;
			closeURLLoader();
			closeLoader();
			urlLoaderLoad(request);
		}
		
		private function dispatchEventInternal(type:String):void
		{
			var newEvent:ByteLoaderEvent = new ByteLoaderEvent(type);
			newEvent.url = _request.url;
			dispatchEvent(newEvent);
		}
		
		//----------------------------------------------------------------------------------------------------------------------------------
		// URLLoader
		//----------------------------------------------------------------------------------------------------------------------------------
		
		private var _urlLoader:URLLoader = null;
		
		public function getURLLoader():URLLoader
		{
			return _urlLoader;
		}
		
		private function urlLoaderLoad(request:URLRequest):void
		{
			if(_urlLoader == null)
			{
				_urlLoader = new URLLoader();
				_urlLoader.dataFormat = URLLoaderDataFormat.BINARY;
			}
			addURLLoaderListeners();
			_urlLoader.load(request);
		}
		
		private function addURLLoaderListeners():void
		{
			_urlLoader.addEventListener(Event.COMPLETE, urlLoaderCompleteHandler);
			_urlLoader.addEventListener(IOErrorEvent.IO_ERROR, urlLoaderIOErrorHandler);
			_urlLoader.addEventListener(ProgressEvent.PROGRESS, urlLoaderProgressHandler);
			_urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, urlLoaderSecurityErrorHandler);
		}
		
		private function removeURLLoaderListeners():void
		{
			_urlLoader.removeEventListener(Event.COMPLETE, urlLoaderCompleteHandler);
			_urlLoader.removeEventListener(IOErrorEvent.IO_ERROR, urlLoaderIOErrorHandler);
			_urlLoader.removeEventListener(ProgressEvent.PROGRESS, urlLoaderProgressHandler);
			_urlLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, urlLoaderSecurityErrorHandler);
		}
		
		private function urlLoaderCompleteHandler(event:Event):void
		{
			var bytes:ByteArray = _urlLoader.data;
			loaderLoad(_byteProcessor == null ? bytes : _byteProcessor(bytes));
			dispatchEventInternal(ByteLoaderEvent.URL_LOADER_COMPLETE);
		}
		
		private function urlLoaderIOErrorHandler(event:IOErrorEvent):void
		{
			closeURLLoader();
			dispatchEventInternal(ByteLoaderEvent.URL_LOADER_IO_ERROR);
		}
		
		private function urlLoaderProgressHandler(event:ProgressEvent):void
		{
			var newEvent:ByteLoaderEvent = new ByteLoaderEvent(ByteLoaderEvent.PROGRESS);
			newEvent.bytesLoaded = event.bytesLoaded;
			newEvent.bytesTotal = event.bytesTotal;
			newEvent.url = _request.url;
			dispatchEvent(newEvent);
		}
		
		private function urlLoaderSecurityErrorHandler(event:SecurityErrorEvent):void
		{
			closeURLLoader();
			dispatchEventInternal(ByteLoaderEvent.URL_LOADER_SECURITY_ERROR);
		}
		
		private function closeURLLoader():void
		{
			if(_urlLoader != null)
			{
				try
				{
					_urlLoader.close();
				}
				catch(error:Error)
				{
					// Do nothing
				}
				removeURLLoaderListeners();
			}
		}
		
		private function destroyURLLoader():void
		{
			closeURLLoader();
			_urlLoader = null;
		}
		
		//----------------------------------------------------------------------------------------------------------------------------------
		// Loader
		//----------------------------------------------------------------------------------------------------------------------------------
		
		private var _loader:Loader = null;
		
		public function getLoader():Loader
		{
			return _loader;
		}
		
		private function loaderLoad(bytes:ByteArray):void
		{
			if(_loader == null)
			{
				_loader = new Loader();
			}
			addLoaderListeners();
			_loader.loadBytes(bytes, _context);
		}
		
		private function addLoaderListeners():void
		{
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loaderCompleteHandler);
			_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, loaderIOErrorHandler);
		}
		
		private function removeLoaderListeners():void
		{
			_loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, loaderCompleteHandler);
			_loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, loaderIOErrorHandler);
		}
		
		private function loaderCompleteHandler(event:Event):void
		{
			dispatchEventInternal(ByteLoaderEvent.LOADER_COMPLETE);
		}
		
		private function loaderIOErrorHandler(event:IOErrorEvent):void
		{
			closeURLLoader();
			closeLoader();
			dispatchEventInternal(ByteLoaderEvent.LOADER_IO_ERROR);
		}
		
		private function closeLoader():void
		{
			if(_loader != null)
			{
				_loader.unloadAndStop();
				try
				{
					_loader.close();
				}
				catch(error:Error)
				{
					// Do nothing
				}
				removeLoaderListeners();
			}
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
			destroyURLLoader();
			destroyLoader();
			_context = null;
			_request = null;
			_byteProcessor = null;
		}
	}
}