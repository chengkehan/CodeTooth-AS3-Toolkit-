package com.codeTooth.actionscript.game.amfAgreement
{
	import com.codeTooth.actionscript.lang.exceptions.NullPointerException;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	/**
	 * 加载多个路径下的协议XML，与AMFAgreementURLLoader所不同的是可以一次指定多个URL。
	 */
	public class AMFAgreementURLQueueLoader extends EventDispatcher implements IAMFAgreementLoader
	{
		private var _parser:IAMFAgreementParser = null;
		
		/**
		 * 构造函数
		 * 
		 * @param parser 解析器
		 * 
		 * @throws com.codeTooth.actionscript.lang.exceptions.NullPointerException 
		 * 入参是null
		 */
		public function AMFAgreementURLQueueLoader(parser:IAMFAgreementParser)
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
		
		// 加载的所有路径
		private var _source:Vector.<String> = null;
		
		// 加载器
		private var _loader:URLLoader = null;
		
		// 当前正在加载的索引
		private var _currentIndex:uint = 0;
		
		// 存储所有加载到的数据
		private var _data:Vector.<Object> = null;
		
		/**
		 * 开始加载
		 * 
		 * @param source 应该是一个Vector.<String>类型的集合，集合中的每一个元素，是一个协议XML的URL路径。
		 */
		public function load(source:Object):void
		{
			if(_loader == null)
			{
				_loader = new URLLoader();
			}
			
			_data = new Vector.<Object>();
			_currentIndex = 0;
			_source = Vector.<String>(source);
			close();
			addLoaderListeners();
			loadInternal();
		}
		
		/**
		 * @inheritDoc
		 */
		public function getAMFAgreementXML():XML
		{
			return _parser.parse(_data);
		}
		
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
		
		// 加载一条
		private function loadInternal():void
		{
			// 全部都加载完成了
			if(_source == null || _currentIndex >= _source.length)
			{
				close();
				
				// 抛出完成事件
				var newEvent:AMFAgreementEvent = new AMFAgreementEvent(AMFAgreementEvent.COMPLETE);
				newEvent.source = _source;
				dispatchEvent(newEvent);
			}
			// 还有没加载的
			else
			{
				_loader.load(new URLRequest(_source[_currentIndex]));
			}
		}
		
		// 添加加载器事件
		private function addLoaderListeners():void
		{
			_loader.addEventListener(Event.COMPLETE, completeHandler);
			_loader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			_loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
		}
		
		// 移除加载器事件
		private function removeLoaderListeners():void
		{
			_loader.removeEventListener(Event.COMPLETE, completeHandler);
			_loader.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			_loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
		}
		
		// 加载发生SecurityError
		private function securityErrorHandler(event:SecurityErrorEvent):void
		{
			close();
			dispatchEventInternal(AMFAgreementEvent.SECURITY_ERROR);
		}
		
		// 加载发生IOError
		private function ioErrorHandler(event:IOErrorEvent):void
		{
			close();
			dispatchEventInternal(AMFAgreementEvent.IO_ERROR);
		}
		
		// 加载完一条时触发
		private function completeHandler(event:Event):void
		{
			// 存储当前加载到的数据，然后尝试加载下一条数据
			_data[_currentIndex] = _loader.data;
			_currentIndex++;
			loadInternal();
		}
		
		private function dispatchEventInternal(type:String):void
		{
			var newEvent:AMFAgreementEvent = new AMFAgreementEvent(type);
			newEvent.source = _source[_currentIndex];
			dispatchEvent(newEvent);
		}
		
		private function destroyLoader():void
		{
			close();
			_loader = null;
		}
		
		//----------------------------------------------------------------------------------------------------------------------------------
		// 实现 IDestroy 接口
		//----------------------------------------------------------------------------------------------------------------------------------
		
		/**
		 * @inheritDoc
		 */
		public function destroy():void
		{
			destroyLoader();
			_parser = null;
			_data = null;
			_source = null;
		}
	}
}