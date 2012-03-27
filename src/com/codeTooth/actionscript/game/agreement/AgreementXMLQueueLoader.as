package com.codeTooth.actionscript.game.agreement
{
	import com.codeTooth.actionscript.lang.exceptions.NullPointerException;
	
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	public class AgreementXMLQueueLoader extends EventDispatcher implements IAgreementSourceLoader
	{
		private var _parser:IAgreementParser = null;
		
		private var _source:Object = null;
		
		public function AgreementXMLQueueLoader(parser:IAgreementParser)
		{
			if(parser == null)
			{
				throw new NullPointerException("Null parser");
			}
			_parser = parser;
		}
		
		public function load(source:Object):void
		{
			_source = source;
			
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
			return _parser.parse(_source);
		}
		
		public function destroy():void
		{
			_parser = null;
			_source = null;
		}
	}
}