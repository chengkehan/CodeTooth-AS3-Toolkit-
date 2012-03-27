package 
{
	import com.codeTooth.actionscript.interaction.drag.SimpleDragManager;
	import com.codeTooth.actionscript.interaction.drag.SimpleDragManagerEvent;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	
	public class Main extends Sprite 
	{
		private var _drag:SimpleDragManager = null;
		
		public function Main()
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			_drag  = new SimpleDragManager(stage, true);
			//_drag.addEventListener(SimpleDragManagerEvent.SIMPLE_DRAG_START, dragStartHandler);
			//_drag.addEventListener(SimpleDragManagerEvent.SIMPLE_DRAG_STOP, dragStopHandler);
			//_drag.addEventListener(SimpleDragManagerEvent.SIMPLE_DRAGGING, draggingHandler);
			_drag.setPositionDragableObject(dragObject);
			
			addChild(new Box());
		}
		
		private function dragObject(x:Number, y:Number, obj:DisplayObject):void
		{
			obj.x = int(x / 20) * 20;
			obj.y = int(y / 20) * 20; 
		}
		
		private function draggingHandler(e:SimpleDragManagerEvent):void 
		{
			trace("dragging", e.dragableObject);
		}
		
		private function dragStopHandler(e:SimpleDragManagerEvent):void 
		{
			trace("dragStop", e.dragableObject);
		}
		
		private function dragStartHandler(e:SimpleDragManagerEvent):void 
		{
			trace("dragStart", e.dragableObject);
		}
		
	}
	
}