package com.codeTooth.actionscript.game.amfAgreement
{
	import com.codeTooth.actionscript.lang.exceptions.NullPointerException;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	/**
	 * 直接将传入的XML作为AMF协议
	 */
	public class AMFAgreementXMLLoader extends EventDispatcher implements IAMFAgreementLoader
	{
		private var _parser:IAMFAgreementParser = null;
		
		private var _source:Object = null;
		
		/**
		 * 构造函数
		 * 
		 * @param parser 指定解析加载得到的数据的解析器
		 * 
		 * @throws com.codeTooth.actionscript.lang.exceptions.NullPointerException 
		 * 入参是null
		 */
		public function AMFAgreementXMLLoader(parser:IAMFAgreementParser)
		{
			if(parser == null)
			{
				throw new NullPointerException("Null parser");
			}
			_parser = parser;
		}
		
		/**
		 * 开始加载
		 * 
		 * @param source 应该是一个协议XML对象
		 */
		public function load(source:Object):void
		{
			_source = source;
			
			var newEvent:AMFAgreementEvent = new AMFAgreementEvent(AMFAgreementEvent.COMPLETE);
			newEvent.source = _source;
			dispatchEvent(newEvent);
		}
		
		/**
		 * @inheritDoc
		 */
		public function getAMFAgreementXML():XML
		{
			return _parser.parse(_source);
		}
		
		/**
		 * @inheritDoc
		 */
		public function close():void
		{
			// Do nothing
		}
		
		//----------------------------------------------------------------------------------------------------------------------------------
		// 实现 IDestroy 接口
		//----------------------------------------------------------------------------------------------------------------------------------
		
		/**
		 * @inheritDoc
		 */
		public function destroy():void
		{
			_source = null;
			_parser = null;
		}
	}
}