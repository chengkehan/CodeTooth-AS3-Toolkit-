package com.codeTooth.actionscript.nativeInterface
{
	import flash.display.DisplayObject;
	import flash.geom.Point;
	import flash.text.TextSnapshot;

	public interface IDisplayObjectContainer extends IInteractiveObject
	{
		function get mouseChildren():Boolean;
		function set mouseChildren(value:Boolean):void;
			
		function get numChildren():int;
			
		function get tabChildren():Boolean;
		function set tabChildren(value:Boolean):void;
			
		function get textSnapshot():TextSnapshot;
		
		function addChild(child:DisplayObject):DisplayObject;
			
		function addChildAt(child:DisplayObject, index:int):DisplayObject;
			
		function areInaccessibleObjectsUnderPoint(point:Point):Boolean;
			
		function contains(child:DisplayObject):Boolean;
			
		function getChildAt(index:int):DisplayObject;
			
		function getChildByName(name:String):DisplayObject;
			
		function getChildIndex(child:DisplayObject):int;
			
		function getObjectsUnderPoint(point:Point):Array;
			
		function removeChild(child:DisplayObject):DisplayObject;
			
		function removeChildAt(index:int):DisplayObject;
			
		function setChildIndex(child:DisplayObject, index:int):void;
			
		function swapChildren(child1:DisplayObject, child2:DisplayObject):void;
			
		function swapChildrenAt(index1:int, index2:int):void;
	}
}