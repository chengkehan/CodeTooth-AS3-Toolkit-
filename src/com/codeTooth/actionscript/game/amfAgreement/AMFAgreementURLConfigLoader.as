package com.codeTooth.actionscript.game.amfAgreement
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;

	/**
	 * 通过配置文件指定的一个或多个路径加载协议XML
	 */
	public class AMFAgreementURLConfigLoader extends AMFAgreementURLQueueLoader
	{
		/**
		 * 构造函数
		 * 
		 * @param parser 解析器
		 * @param delim 配置文件中每条协议路径的分隔符
		 */
		public function AMFAgreementURLConfigLoader(parser:IAMFAgreementParser, delim:String)
		{
			super(parser);
			_delim = delim;
		}
		
		//----------------------------------------------------------------------------------------------------------------------------------
		// 重写方法
		//----------------------------------------------------------------------------------------------------------------------------------
		
		private var _delim:String = null;
		
		// 加载配置文件的Loader
		private var _loader:URLLoader = null;
		
		private var _source:Object = null;
		
		/**
		 * 开始加载
		 * 
		 * @param source 路径配置文件的url
		 */
		override public function load(source:Object):void
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
		
		/**
		 * @inheritDoc
		 */
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
		
		// 配置文件Loader添加侦听
		private function addLoaderListeners():void
		{
			_loader.addEventListener(Event.COMPLETE, completeHandler);
			_loader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			_loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
		}
		
		// 配置文件Loader移除侦听
		private function removeLoaderListeners():void
		{
			_loader.removeEventListener(Event.COMPLETE, completeHandler);
			_loader.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			_loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
		}
		
		// 加载配置文件完成
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
			dispatchEventInternal(AMFAgreementEvent.IO_ERROR);
		}
		
		private function securityErrorHandler(event:SecurityErrorEvent):void
		{
			close();
			dispatchEventInternal(AMFAgreementEvent.SECURITY_ERROR);
		}
		
		private function dispatchEventInternal(type:String):void
		{
			var newEvent:AMFAgreementEvent = new AMFAgreementEvent(type);
			newEvent.source = _source;
			dispatchEvent(newEvent);
		}
		
		private function destroyLoader():void
		{
			close();
			_loader = null;
		}
		
		//----------------------------------------------------------------------------------------------------------------------------------
		// 重写 IDestroy 接口
		//----------------------------------------------------------------------------------------------------------------------------------
		
		/**
		 * @inheritDoc
		 */
		override public function destroy():void
		{
			destroyLoader();
			super.destroy();
		}
	}
}