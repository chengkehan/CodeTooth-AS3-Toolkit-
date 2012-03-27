package com.codeTooth.actionscript.interaction.drag 
{
	import flash.events.Event;
	
	public class DragManagerEvent extends Event 
	{
		public static const DROP_INTERRUPTTED:String = "dropInterrupted";
		
		public static const CAN_DROP_UNDER_MOUSE:String = "canDropUnderMouse";
		
		public static const CANNOT_DROP_UNDER_MOUSE:String = "cannotDropUnderMouse";
		
		public static const DROP_NOT_ON_TARGET:String = "dropNotOnTarget";
		
		public var continueInterruptedDropFunc:Function = null;
		
		public var preventDropFunc:Function = null;
		
		public var dragData:DragData = null;
		
		public function DragManagerEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
			
		} 
		
		public override function clone():Event 
		{ 
			var newEvent:DragManagerEvent = new DragManagerEvent(type, bubbles, cancelable);
			newEvent.continueInterruptedDropFunc = continueInterruptedDropFunc;
			newEvent.preventDropFunc = preventDropFunc;
			newEvent.dragData = dragData;
			
			return newEvent;
		} 
		
	}
	
}