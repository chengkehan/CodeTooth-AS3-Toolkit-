package com.codeTooth.actionscript.dependencyInjection.core 
{
	import flash.events.EventDispatcher;
	
	/**
	 * xml对象注入加载器
	 */	
	public class DiXMLLoader extends EventDispatcher 
																	implements IDiLoader
	{
		//注入的xml对象
		private var _xml:XML = null;
		
		//加载器
		//如果注入的xml对象中有insert节点将使用到此加载器
		private var _diURLLoader:DiURLLoader = null;
		
		private var _getLocalDataFunction:Function = null;
		
		public function DiXMLLoader()
		{
			
		}
		
		/**
		 * @inheritDoc
		 */
		public function load(source:Object):void
		{
			//如果注入的xml对象中不存在insert节点将直接加载完成
		 	//如果包含insert节点，将使用URLLoader加载器进行加载
			
			destroy();
			
			_xml = XML(source);
			if(_xml.insert == undefined)
			{
				dispatchEventInternal(DiContainerEvent.COMPLETE, null);
			}
			else
			{
				var diXMLLoadedDataParser:DiXMLLoadedDataParser = new DiXMLLoadedDataParser();
				_diURLLoader = new DiURLLoader(diXMLLoadedDataParser);
				_diURLLoader.setGetLocalFunction(_getLocalDataFunction);
				addListeners();
				var insertsList:XMLList = _xml.insert;
				for each(var insertXML:XML in insertsList)
				{
					if(insertXML.@relativePath == undefined)
					{
						_diURLLoader.addURL(String(insertXML.@source));
					}
					else
					{
						_diURLLoader.addURL(_getLocalDataFunction(String(insertXML.@relativePath)) + String(insertXML.@source));
					}
				}
				_diURLLoader.load(null);
				diXMLLoadedDataParser.addData(_xml);
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function getLoadedData():XML
		{
			return _diURLLoader == null ? _xml : _diURLLoader.getLoadedData();
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
			destroy();
		}
		
		/**
		 * @inheritDoc
		 */
		public function destroy():void
		{
			if(_diURLLoader != null)
			{
				removeListeners();
				_diURLLoader.destroy();
				_diURLLoader = null;
				_xml = null;
			}
			_getLocalDataFunction = null;
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
			_diURLLoader.addEventListener(DiContainerEvent.COMPLETE, completeHandler);
			_diURLLoader.addEventListener(DiContainerEvent.IO_ERROR, ioErrorHandler);
			_diURLLoader.addEventListener(DiContainerEvent.SECURITY_ERROR, securityErrorHandler);
		}
		
		//移除加载器帧听
		private function removeListeners():void
		{
			_diURLLoader.removeEventListener(DiContainerEvent.COMPLETE, completeHandler);
			_diURLLoader.removeEventListener(DiContainerEvent.IO_ERROR, ioErrorHandler);
			_diURLLoader.removeEventListener(DiContainerEvent.SECURITY_ERROR, securityErrorHandler);
		}
		
		//加载完成
		private function completeHandler(event:DiContainerEvent):void
		{
			dispatchEventInternal(event.type, null);
		}
		
		//加载发生IOError
		private function ioErrorHandler(event:DiContainerEvent):void
		{
			destroy();
			dispatchEventInternal(event.type, event.source);
		}
		
		//加载发生SecurityError
		private function securityErrorHandler(event:DiContainerEvent):void
		{
			destroy();
			dispatchEventInternal(event.type, event.source);
		}
	}
}