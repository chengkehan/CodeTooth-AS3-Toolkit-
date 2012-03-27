package com.codeTooth.actionscript.localize.language
{
	import com.codeTooth.actionscript.lang.exceptions.NullPointerException;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	public class LanguageURLLoader extends EventDispatcher implements ILanguageLoader
	{
		public function LanguageURLLoader(parser:ILanguageParser)
		{
			if(parser == null)
			{
				throw new NullPointerException("Null parser");
			}
			_parser = parser;
		}
		
		//----------------------------------------------------------------------------------------------------------------------------------
		// 实现 ILanguageLoader 接口
		//----------------------------------------------------------------------------------------------------------------------------------
		
		private var _parser:ILanguageParser = null;
		
		private var _loader:URLLoader = null;
		
		private var _source:Object = null;
		
		private var _data:String = null;
		
		public function load(source:Object):void
		{
			if(_loader == null)
			{
				_loader = new URLLoader();
			}
			close();
			addLoaderListeners();
			_source = source;
			_loader.load(new URLRequest(String(source)));
		}
		
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
		
		public function getLanguageData():String
		{
			return _data;
		}
		
		private function addLoaderListeners():void
		{
			_loader.addEventListener(Event.COMPLETE, completeHandler);
			_loader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			_loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
		}
		
		private function removeLoaderListeners():void
		{
			_loader.removeEventListener(Event.COMPLETE, completeHandler);
			_loader.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			_loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
		}
		
		private function completeHandler(event:Event):void
		{
			_data = _parser.parse(_loader.data);
			removeLoaderListeners();
			dispatchLoaderEvent(LanguageEvent.COMPLETE);
		}
		
		private function ioErrorHandler(event:IOErrorEvent):void
		{
			removeLoaderListeners();
			dispatchLoaderEvent(LanguageEvent.SECURITY_ERROR);
		}
		
		private function securityErrorHandler(event:SecurityErrorEvent):void
		{
			removeLoaderListeners();
			dispatchLoaderEvent(LanguageEvent.SECURITY_ERROR);
		}
		
		private function dispatchLoaderEvent(type:String):void
		{
			var newEvent:LanguageEvent = new LanguageEvent(type);
			newEvent.source = _source;
			dispatchEvent(newEvent);
		}
		
		private function destroyLoader():void
		{
			if(_loader != null)
			{
				close();
				_loader = null;
			}
		}
		
		//----------------------------------------------------------------------------------------------------------------------------------
		// 实现 IDestroy 接口
		//----------------------------------------------------------------------------------------------------------------------------------
		
		public function destroy():void
		{
			destroyLoader();
			_source = null;
			_data = null;
			_parser = null;
		}
	}
}