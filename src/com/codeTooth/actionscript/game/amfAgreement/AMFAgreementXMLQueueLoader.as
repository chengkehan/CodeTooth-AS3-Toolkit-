package com.codeTooth.actionscript.game.amfAgreement
{
	import com.codeTooth.actionscript.lang.exceptions.NullPointerException;
	
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	public class AMFAgreementXMLQueueLoader extends EventDispatcher implements IAMFAgreementLoader
	{
		private var _parser:IAMFAgreementParser = null;
		
		public function AMFAgreementXMLQueueLoader(parser:IAMFAgreementParser)
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
		
		private var _source:Object = null;
		
		/**
		 * 开始加载
		 * 
		 * @param source 类型是Vector.<Object>的集合，集合中的每一个元素是一个协议XML
		 */
		public function load(source:Object):void
		{
			_source = source;
			var newEvent:AMFAgreementEvent = new AMFAgreementEvent(AMFAgreementEvent.COMPLETE);
			newEvent.source = _source;
			dispatchEvent(newEvent);
		}
		
		public function getAMFAgreementXML():XML
		{
			return _parser.parse(_source);
		}
		
		public function close():void
		{
			// Do nothing
		}
		
		//----------------------------------------------------------------------------------------------------------------------------------
		// 实现 IDestroy 接口
		//----------------------------------------------------------------------------------------------------------------------------------
		
		public function destroy():void
		{
			_parser = null;
			_source = null;
		}
	}
}