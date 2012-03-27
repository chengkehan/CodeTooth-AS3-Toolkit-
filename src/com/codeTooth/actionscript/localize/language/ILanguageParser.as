package com.codeTooth.actionscript.localize.language
{
	import com.codeTooth.actionscript.lang.utils.destroy.IDestroy;

	public interface ILanguageParser extends IDestroy
	{
		function parse(data:Object):String;
	}
}