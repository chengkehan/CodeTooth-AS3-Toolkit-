package com.codeTooth.actionscript.game.agreement
{
	import com.codeTooth.actionscript.lang.utils.destroy.IDestroy;
	
	import flash.events.IEventDispatcher;

	public interface IAgreementSourceLoader extends IEventDispatcher, IDestroy
	{
		function load(source:Object):void;
		
		function close():void;
		
		function getAgreementXML():XML;
	}
}