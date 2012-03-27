package com.codeTooth.actionscript.game.agreement
{
	import com.codeTooth.actionscript.lang.exceptions.NullPointerException;
	
	import flash.events.EventDispatcher;

	/**
	 * 根据协议XML加载协议
	 */
	public class AgreementXMLLoader extends EventDispatcher implements IAgreementSourceLoader
	{
		private var _parser:IAgreementParser = null;
		
		public function AgreementXMLLoader(parser:IAgreementParser)
		{
			if(parser == null)
			{
				throw new NullPointerException("Null parser");
			}
			_parser = parser;
			
		}
		
		//----------------------------------------------------------------------------------------------------------------------------------
		// 实现 IAgreementSourceLoader 接口
		//----------------------------------------------------------------------------------------------------------------------------------
		
		private var _xml:XML = null;
		
		public function load(source:Object):void
		{
			_xml = _parser.parse(source);
			
			var newEvent:AgreementEvent = new AgreementEvent(AgreementEvent.COMPLETE);
			newEvent.source = source;
			dispatchEvent(newEvent);
		}
		
		public function close():void
		{
			// Do nothing
		}
		
		public function getAgreementXML():XML
		{
			return _xml;
		}
		
		//----------------------------------------------------------------------------------------------------------------------------------
		// 实现 IDestroy 接口
		//----------------------------------------------------------------------------------------------------------------------------------
		
		public function destroy():void
		{
			_xml = null;
			_parser = null;
		}
	}
}