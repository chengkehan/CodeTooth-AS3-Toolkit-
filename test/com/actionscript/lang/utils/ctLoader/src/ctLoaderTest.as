package
{
	import com.codeTooth.actionscript.lang.utils.ctLoader.CtLoader;
	import com.codeTooth.actionscript.lang.utils.ctLoader.CtLoaderItem;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	
	[SWF(width="1000", height="700")]
	public class ctLoaderTest extends Sprite
	{
		private var _loader:CtLoader = null;
		
		public function ctLoaderTest()
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			_loader = new CtLoader();
//			_loader.load("_bigMap_1x1.jpg", null, completeCallback, null, null, null, null, null);
//			_loader.load("_bigMap_1x1.jpg", null, completeCallback, null, null, null, null, null);
			
			var errorPlaceholder:BitmapData = new BitmapData(150, 150, false, 0x0099FF);
			var loadingPlaceholder:BitmapData = new BitmapData(150, 150, false, 0xFF0000);
			var image:DisplayObject = _loader.loadImage("_bigMap_1x1.jpg", null, loadingPlaceholder, errorPlaceholder);
			addChild(image);
		}
		
		private function completeCallback(loader:CtLoaderItem):void
		{
			var bmp:Bitmap = loader.getBitmap();
			bmp.x = Math.random() * 800;
			bmp.y = Math.random() * 500;
			addChild(bmp);
		}
	}
}