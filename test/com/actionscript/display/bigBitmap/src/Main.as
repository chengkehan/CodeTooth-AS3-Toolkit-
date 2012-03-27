package 
{
	import com.codeTooth.actionscript.display.SimpleBigBitmap;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.utils.getTimer;
	
	public class Main extends Sprite 
	{
		
		public function Main()
		{
			var bmp:SimpleBigBitmap = new SimpleBigBitmap(100, 100, 550, 450, true, 0xFF990000);
			addChild(bmp);
			
			var circ:Shape = new Shape();
			circ.graphics.beginFill(0x0099FF);
			circ.graphics.drawCircle(95, 95, 95);
			circ.graphics.endFill();
			//addChild(circ);
			
			var time:int = getTimer();
			for (var i:int = 0; i < 500; i++)
			{
				bmp.draw(circ, 120, 250);
			}
			trace(getTimer() - time);
			
			var circBmpd:BitmapData = new BitmapData(circ.width, circ.height, true, 0x00000000);
			circBmpd.draw(circ);
			//addChild(new Bitmap(circBmpd));
			
			time = getTimer();
			//bmp.draw(circ, NaN, NaN, 150, 120);
			for (i = 0; i < 500; i++)
			{
				bmp.copyPixels(circBmpd, 150, 120);
			}
			trace(getTimer() - time);
			
			//bmp.destroy();
		}
		
	}
	
}