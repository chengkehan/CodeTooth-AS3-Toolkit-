package com.codeTooth.actionscript.game.agreement
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;

	public class AgreementURLConfigLoader extends AgreementURLQueueLoader
	{
		private var _delim:String = null;
		
		public function AgreementURLConfigLoader(parser:IAgreementParser, delim:String)
		{
			super(parser);
			_delim = delim;
		}
		
		//----------------------------------------------------------------------------------------------------------------------------------
		// 重写 IAgreementSourceLoader 接口
		//----------------------------------------------------------------------------------------------------------------------------------
		
		private var _loader:URLLoader = null;
		
		private var _source:Object = null;
		
		override public function load(source:Object):void
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
		
		override public function close():void
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
			super.close();
		}
		
		private function addLoaderListeners():void
		{
			_loader.addEventListener(Event.COMPLETE, completeHandler);
			_loader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			_loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR,securityErrorHandler);
		}
		
		private function removeLoaderListeners():void
		{
			_loader.removeEventListener(Event.COMPLETE, completeHandler);
			_loader.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			_loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,securityErrorHandler);
		}
		
		private function completeHandler(event:Event):void
		{
			var str:String = _loader.data;
			var paths:Array = str.split(_delim);
			close();
			super.load(Vector.<String>(paths));
		}
		
		private function ioErrorHandler(event:IOErrorEvent):void
		{
			close();
			dispatchEventInner(AgreementEvent.IO_ERROR);
		}
		
		private function securityErrorHandler(event:SecurityErrorEvent):void
		{
			close();
			dispatchEventInner(AgreementEvent.SECURITY_ERROR);
		}
		
		private function dispatchEventInner(type:String):void
		{
			var newEvent:AgreementEvent = new AgreementEvent(type);
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
		// 重写 IDestroy 接口
		//----------------------------------------------------------------------------------------------------------------------------------
		
		override public function destroy():void
		{
			destroyLoader();
			super.destroy();
		}
	}
}