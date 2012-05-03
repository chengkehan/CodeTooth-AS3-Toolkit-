package com.codeTooth.actionscript.game.action
{
	public interface IAction
	{
		function set fps(value:uint):void;
		
		function get fps():uint;
		
		function refreshClip():void;
		
		function nextClip():void;
	}
}