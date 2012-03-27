package com.codeTooth.actionscript.dependencyInjection.core 
{		
	import com.codeTooth.actionscript.lang.exceptions.NullPointerException;
	
	/**
	 * 加载的XML注入数据解析器
	 */
	public class DiXMLLoadedDataParser implements IDiLoadedDataParser
	{
		private var _xml:XML = null;
		
		public function DiXMLLoadedDataParser()
		{
			
		}
		
		/**
		 * @inheticDoc
		 */		
		public function addData(data:Object):void
		{
			if(data == null)
			{
				throw new NullPointerException("Null data");
			}
			
			if(_xml == null)
			{
				_xml = new XML(<di/>);
			}
			
			var xml:XML = XML(data);
			if(xml.item != undefined)
			{
				_xml.appendChild(xml.item);
			}
		}
		
		/**
		 * @inheticDoc
		 */
		public function clear():void
		{
			_xml = null;
		}
		
		/**
		 * @inheticDoc
		 */
		public function parse():XML
		{
			return _xml;
		}
		
		/**
		 * @inheritDoc
		 */		
		public function destroy():void
		{
			clear();
		}
	}
}