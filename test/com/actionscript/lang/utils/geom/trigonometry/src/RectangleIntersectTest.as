package  
{
	import com.codeTooth.actionscript.lang.utils.geom.Mathematic;
	import flash.geom.Rectangle;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filters.GlowFilter;
	import flash.geom.Rectangle;
	import flash.utils.getTimer;
	
	public class RectangleIntersectTest extends Sprite 
	{
		private var _rect1:Rectangle = null;
		
		private var _rect2:Rectangle = null;
		
		private var _rect3:Rectangle = null;
		
		private var _rect4:Rectangle = null;
		
		private var _canvas:Shape = null;
		
		public function RectangleIntersectTest() 
		{
			_rect1 = new Rectangle(100, 100, 80, 40);
			_rect2 = new Rectangle(100, 100, 40, 80);
			_rect3 = new Rectangle(100, 100, 40, 80);
			_rect4 = new Rectangle(100, 100, 40, 80);
			
			_canvas = new Shape();
			addChild(_canvas);
			
			//addEventListener(Event.ENTER_FRAME, enterFrameHandler);
			
			var time:int = getTimer();
			for (var i:int = 0; i < 99999; i++)
			{
				//Mathematic.rentanglesIntersect(_rect1, _rect2);
				_rect3.intersects(_rect4);
			}
			trace("time", getTimer() - time);
		}
		
		private function enterFrameHandler(e:Event):void 
		{
			_rect1.x = mouseX;
			_rect1.y = mouseY;
			
			_canvas.graphics.clear();
			_canvas.graphics.lineStyle(1);
			_canvas.graphics.drawRect(_rect1.x, _rect1.y, _rect1.width, _rect1.height);
			_canvas.graphics.drawRect(_rect2.x, _rect2.y, _rect2.width, _rect2.height);
			
			_canvas.filters = Mathematic.rentanglesIntersect(_rect1, _rect2) ? [new GlowFilter()] : null;
		}
		
	}

}