package 
{
	import com.codeTooth.actionscript.display.BitmapDataHumanClipD8;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.Timer;
	
	public class Main extends Sprite 
	{
		[Embed(source="human.png")]
		private var _humanBmpdDefinition:Class;
		
		private const CLIP_WIDTH:int = 70;
		
		private const CLIP_HEIGHT:int = 124;
		
		private var _human:BitmapDataHumanClipD8 = null;
		
		private var _canvas:Bitmap = null;
		
		private var _destPoint:Point = null;
		
		private var _timer:Timer = null;
		
		public function Main() 
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			_destPoint = new Point();
			
			_human = new BitmapDataHumanClipD8(new _humanBmpdDefinition().bitmapData, 
				CLIP_WIDTH, CLIP_HEIGHT, true, 3, 0, 1, 2, 6, 4, 7, 5);
				
			_canvas = new Bitmap(new BitmapData(CLIP_WIDTH, CLIP_HEIGHT, true, 0x00000000));
			addChild(_canvas);
			
			_timer = new Timer(160);
			_timer.addEventListener(TimerEvent.TIMER, onTimerHandler);
			_timer.start();
		}
		
		private function onTimerHandler(event:TimerEvent):void 
		{
			_human.walkRightDown();
			_canvas.bitmapData.copyPixels(_human.getBitmapData(), _human.getClipRectangle(), _destPoint);
		}
		
	}
	
}