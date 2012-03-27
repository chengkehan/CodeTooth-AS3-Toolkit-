package  
{
	import com.codeTooth.actionscript.lang.utils.geom.Mathematic;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.utils.getTimer;
	
	public class PointInTriangle extends Sprite 
	{
		private var _p1:Point = null;
		private var _p2:Point = null;
		private var _p3:Point = null;
		
		public function PointInTriangle(stage:Stage) 
		{
			_p1 = new Point(0, 0);
			_p2 = new Point(200, 100);
			_p3 = new Point(200, 200);
			
			graphics.lineStyle(1);
			graphics.moveTo(_p1.x, _p1.y);
			graphics.lineTo(_p2.x, _p2.y);
			graphics.lineTo(_p3.x, _p3.y);
			graphics.lineTo(_p1.x, _p1.y);
			
			var time:int = getTimer();
			for (var i:int = 0; i < 99999; i++)
			{
				stageMouseMoveHandler(null)
			}
			trace("time", getTimer() - time);
			
			//stage.addEventListener(MouseEvent.MOUSE_MOVE, stageMouseMoveHandler);
		}
		
		private function stageMouseMoveHandler(event:MouseEvent):void 
		{
			if (Mathematic.pointInTriangle(mouseX, mouseY, _p1.x, _p1.y, _p2.x, _p2.y, _p3.x, _p3.y))
			//if (Mathematic.pointInTriangleByVector(mouseX, mouseY, _p1.x, _p1.y, _p2.x, _p2.y, _p3.x, _p3.y, 1))
			//if (Mathematic.pointInTriangleByVector(mouseX, mouseY, _p3.x, _p3.y, _p2.x, _p2.y, _p1.x, _p1.y, -1))
			{
				//trace("in");
			}
			else
			{
				//trace("out");
			}
		}
		
	}

}