package com.codeTooth.actionscript.dependencyInjection.core 
{	
	import com.codeTooth.actionscript.lang.exceptions.NullPointerException;
	import com.codeTooth.actionscript.lang.utils.destroy.DestroyUtil;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;

	/**
	 * url注入加载器
	 */
	public class DiURLLoader extends EventDispatcher 
																implements IDiLoader
	{
		//加载器
		private var _urlLoader:URLLoader = null;
		
		//url队列
		private var _urlsQueue:Array = null;
		
		//当前正在加载的url
		private var _currentURL:String = null;
		
		//解析器
		private var _parser:IDiLoadedDataParser = null;
		
		private var _getLocalDataFunction:Function = null;
		
		/**
		 * 构造函数
		 * 
		 * @param parser 指定加载注入内容的解析器
		 * 
		 * @throws com.codeTooth.actionscript.lang.exceptions.NullPointerException 
		 * 指定的解析器是null
		 */		
		public function DiURLLoader(parser:IDiLoadedDataParser)
		{
			if(parser == null)
			{
				throw new NullPointerException("Null parser");
			}
			
			_parser = parser;
			_urlLoader = new URLLoader();
			_urlsQueue = new Array();
		}
		
		// TODO FIXME why the input parameter is null
		/**
		 * 开始加载注入内容
		 * 
		 * @param source	加载源,
		 * 如果指定的source是null，会忽略null，
		 * 并且查看队列中是否有需要加载的，进行加载
		 */		
		public function load(source:Object):void
		{
			close();
			
			if(source != null)
			{
				addURL(String(source));
			}
			addListeners();
			loadInternal();
		}
		
		/**
		 * 手动向加载队列中添加url
		 * 
		 * @param url
		 */		
		public function addURL(url:String):void
		{
			_urlsQueue.push(url);
		}
		
		/**
		 * @inheritDoc
		 */
		public function getLoadedData():XML
		{
			return _parser.parse();
		}
		
		/**
		 * @inheritDoc
		 */		
		public function setGetLocalFunction(getLocalFunction:Function):void
		{
			_getLocalDataFunction = getLocalFunction;
		}
		
		/**
		 * @inheritDoc
		 */
		public function close():void
		{
			try
			{
				_parser.clear();
				removeListeners();
				_urlLoader.close();
			}
			catch(error:Error)
			{
				
			}
		}
		
		/**
		 * @inheritDoc
		 */		
		public function destroy():void
		{
			close();
			destroyURLsQueue();
			_urlsQueue = null;
			_urlLoader = null;
			_parser.destroy();
			_parser = null;
			_getLocalDataFunction = null;
		}
		
		//检查加载队列中是否有需要加载
		//如果有，开始加载
		//没有，抛出加载完成事件
		private function loadInternal():void
		{
			if(_urlsQueue.length == 0)
			{
				destroyURLsQueue();
				dispatchEventInternal(DiContainerEvent.COMPLETE, null);
			}
			else
			{
				_currentURL = String(_urlsQueue.shift());
				_urlLoader.load(new URLRequest(_currentURL));
			}
		}
		
		//销毁加载队列
		private function destroyURLsQueue():void
		{
			DestroyUtil.breakArray(_urlsQueue);
		}
		
		//抛出事件
		private function dispatchEventInternal(type:String, source:Object):void
		{
			var newEvent:DiContainerEvent = new DiContainerEvent(type);
			newEvent.source = source;
			dispatchEvent(newEvent);
		}
		
		//添加加载器帧听
		private function addListeners():void
		{
			_urlLoader.addEventListener(Event.COMPLETE, completeHandler);
			_urlLoader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			_urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
		}
		
		//移除加载器帧听
		private function removeListeners():void
		{
			_urlLoader.removeEventListener(Event.COMPLETE, completeHandler);
			_urlLoader.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			_urlLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
		}
		
		//加载完成
		private function completeHandler(event:Event):void
		{
			var xml:XML = XML(_urlLoader.data);
			//如果有插入的内容
			//把插入的内容源添加到加载队列
			if(xml.insert != undefined)
			{
				var insertList:XMLList = xml.insert;
				for each(var insertXML:XML in insertList)
				{
					if(insertXML.@relativePath == undefined)
					{
						addURL(String(insertXML.@source));
					}
					else
					{
						addURL(_getLocalDataFunction(String(insertXML.@relativePath)) + String(insertXML.@source));
					}
				}
			}
			
			//把加载的内容添加到解析器
			_parser.addData(xml);
			
			//开始新一轮的加载
			loadInternal();
		}
		
		//加载发生IOError
		private function ioErrorHandler(event:IOErrorEvent):void
		{
			destroyURLsQueue();
			close();
			dispatchEventInternal(DiContainerEvent.IO_ERROR, _currentURL);
		}
		
		//加载发生SecurityError
		private function securityErrorHandler(event:SecurityErrorEvent):void
		{
			destroyURLsQueue();
			close();
			dispatchEventInternal(DiContainerEvent.SECURITY_ERROR, _currentURL);
		}
	}
}