package  
{
	import com.codeTooth.actionscript.lang.utils.geom.Mathematic;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.geom.Rectangle;
	
	public class BoundsRectangleTest extends Sprite 
	{
		private var _rect1:Rectangle = null;
		
		private var _rect2:Rectangle = null;
		
		private var _rect3:Rectangle = null;
		
		public function BoundsRectangleTest() 
		{
			_rect1 = new Rectangle(0, 0, 100, 100);
			_rect2 = new Rectangle(100, 100, 200, 150);
			
			addEventListener(Event.ENTER_FRAME, enterFrameHandler);
		}
		
		private function enterFrameHandler(event:Event):void
		{
			graphics.clear();
			
			_rect2.x = mouseX;
			_rect2.y = mouseY;
			_rect3 = Mathematic.getBoundsRectangle(_rect1, _rect2);
			
			drawRect(_rect1, 0xFF0000);
			drawRect(_rect2, 0x00FF00);
			drawRect(_rect3, 0x0000FF);
		}
		
		private function drawRect(rect:Rectangle, color:uint):void
		{
			graphics.lineStyle(1, color);
			graphics.drawRect(rect.x, rect.y, rect.width, rect.height);
		}
	}

}