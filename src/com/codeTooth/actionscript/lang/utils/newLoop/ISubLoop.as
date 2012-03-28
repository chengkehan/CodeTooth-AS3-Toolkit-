package com.codeTooth.actionscript.lang.utils.newLoop
{
	public interface ISubLoop
	{
		function get canEnter():Boolean;
		
		function get canExit():Boolean;
		
		function loop(prevTime:int, currTime:int):void;
	}
}