package com.codeTooth.actionscript.game.agreement
{
	import com.codeTooth.actionscript.lang.utils.destroy.IDestroy;

	public interface IAgreementParser extends IDestroy
	{
		function parse(input:Object):XML;
	}
}