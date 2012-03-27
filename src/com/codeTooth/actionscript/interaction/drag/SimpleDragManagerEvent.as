package com.codeTooth.actionscript.interaction.drag 
{
	import flash.events.Event;
	
	public class SimpleDragManagerEvent extends Event 
	{
		public static const SIMPLE_DRAG_START:String = "simpleDragStart";
		
		public static const SIMPLE_DRAGGING:String = "simpleDragging";
		
		public static const SIMPLE_DRAG_STOP:String = "startDragStop";
		
		public var dragableObject:Object = null;
		
		public function SimpleDragManagerEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
			
		} 
		
		public override function clone():Event 
		{ 
			var newEvent:SimpleDragManagerEvent = new SimpleDragManagerEvent(type, bubbles, cancelable);
			newEvent.dragableObject = dragableObject;
			
			return newEvent;
		} 
		
	}
	
}