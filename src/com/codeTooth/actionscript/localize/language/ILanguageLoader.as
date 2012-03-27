package com.codeTooth.actionscript.localize.language
{
	import com.codeTooth.actionscript.lang.utils.destroy.IDestroy;
	
	import flash.events.IEventDispatcher;

	public interface ILanguageLoader extends IEventDispatcher, IDestroy
	{
		function load(source:Object):void;
		
		function close():void; 
		
		function getLanguageData():String;
	}
}