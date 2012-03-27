package com.codeTooth.actionscript.localize.language
{
	import com.codeTooth.actionscript.lang.exceptions.NullPointerException;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	public class LanguageTextLoader extends EventDispatcher implements ILanguageLoader
	{
		private var _text:String = null;
		
		private var _parser:ILanguageParser = null;
		
		public function LanguageTextLoader(parser:ILanguageParser)
		{
			if(parser == null)
			{
				throw new NullPointerException("Null parser");
			}
			_parser = parser;
		}
		
		public function load(source:Object):void
		{
			_text = _parser.parse(source);
			
			var newEvent:LanguageEvent = new LanguageEvent(LanguageEvent.COMPLETE);
			newEvent.source = source;
			dispatchEvent(newEvent);
		}
		
		public function close():void
		{
			// Do nothing
		}
		
		public function getLanguageData():String
		{
			return _text;
		}
		
		public function destroy():void
		{
			_parser = null;
			_text = null;
		}
	}
}