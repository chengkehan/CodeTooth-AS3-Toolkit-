package com.codeTooth.actionscript.localize.language
{
	public class LanguageTextQueueParser implements ILanguageParser
	{
		private var _delim:String = null;
		
		public function LanguageTextQueueParser(delim:String)
		{
			_delim = delim;
		}
		
		public function parse(data:Object):String
		{
			var datas:Vector.<Object> = Vector.<Object>(data);
			var allText:String = "";
			var length:uint = datas.length;
			for(var i:uint = 0; i < length; i++)
			{
				allText += String(datas[i]);
				
				if(i != length - 1)
				{
					allText += _delim;
				}
			}
			
			return allText;
		}
		
		public function destroy():void
		{
			// Do nothing
		}
	}
}