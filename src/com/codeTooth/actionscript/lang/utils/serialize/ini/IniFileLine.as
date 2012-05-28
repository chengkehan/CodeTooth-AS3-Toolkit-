package com.codeTooth.actionscript.lang.utils.serialize.ini
{
	internal class IniFileLine
	{
		public var isComment:Boolean = false;
		
		public var key:String = null;
		
		public var value:String = null;
		
		public function IniFileLine(isComment:Boolean, key:String, value:String)
		{
			this.isComment = isComment;
			this.key = key;
			this.value = value;
		}
	}
}