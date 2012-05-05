package com.codeTooth.actionscript.game.action
{
	import com.codeTooth.actionscript.nativeInterface.IDisplayObject;

	public interface IAction extends IDisplayObject
	{
		function set fps(value:uint):void;
		
		function get fps():uint;
		
		function refreshClip():void;
		
		function nextClip():void;
	}
}