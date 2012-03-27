package com.codeTooth.actionscript.nativeInterface
{
	import flash.accessibility.AccessibilityImplementation;
	import flash.display.NativeMenu;

	public interface IInteractiveObject extends IDisplayObject
	{
		function get accessibilityImplementation():AccessibilityImplementation;
		function set accessibilityImplementation(value:AccessibilityImplementation):void;
			
		function get contextMenu():NativeMenu;
		function set contextMenu(value:NativeMenu):void;
			
		function get doubleClickEnabled():Boolean;
		function set doubleClickEnabled(value:Boolean):void;
			
		function get focusRect():Object;
		function set focusRect(value:Object):void;
			
		function get mouseEnabled():Boolean;
		function set mouseEnabled(value:Boolean):void;
			
		function get tabEnabled():Boolean;
		function set tabEnabled(value:Boolean):void;
			
		function get tabIndex():int;
		function set tabIndex(value:int):void;
	}
}