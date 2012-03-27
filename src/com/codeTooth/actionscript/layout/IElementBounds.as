package com.codeTooth.actionscript.layout
{
	import flash.display.DisplayObject;

	public interface IElementBounds
	{
		function get x():Number;
		
		function get y():Number;
		
		function set x(value:Number):void;
		
		function set y(value:Number):void;
		
		function get width():Number;
		
		function get height():Number;
		
		function setElement(element:DisplayObject, layoutContainer:LayoutContainer):void;
	}
}