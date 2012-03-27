package com.codeTooth.actionscript.localize.language
{
	public class LanguageTextParser implements ILanguageParser
	{
		public function LanguageTextParser()
		{
		}
		
		public function parse(data:Object):String
		{
			return String(data);
		}
		
		public function destroy():void
		{
			// Do nothing
		}
	}
}