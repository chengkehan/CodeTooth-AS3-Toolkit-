package  
{
	import com.codeTooth.actionscript.lang.utils.geom.Point3D;
	import com.codeTooth.actionscript.lang.utils.geom.Mathematic;
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class Rotate3DTest extends Sprite 
	{
		private var _circ:Sprite = null;
		
		private var _radian:Number = 2 * Math.PI / 180;
		
		public function Rotate3DTest() 
		{
			_circ = new Sprite();
			_circ.graphics.beginFill(0x0099FF);
			_circ.graphics.drawCircle(0, 0, 10);
			_circ.graphics.endFill();
			addChild(_circ);
			
			_circ.x = 100;
			
			addEventListener(Event.ENTER_FRAME, loopHanlder);
		}
		
		private function loopHanlder(event:Event):void 
		{			
			var newPos:Point3D = Mathematic.rotate3D(_circ.x, _circ.y, 0, 0, 0, _radian);
			_circ.x = newPos.x;
			_circ.y = newPos.y;
		}
	}

}