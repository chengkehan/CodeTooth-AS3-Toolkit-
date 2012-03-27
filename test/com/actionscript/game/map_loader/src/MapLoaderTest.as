package
{
	import com.codeTooth.actionscript.game.map.loader.GridMapLoader;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	
	[SWF(width="1000", height="700", frameRate="24")]
	public class MapLoaderTest extends Sprite
	{
		private var _gridMapLoader:GridMapLoader = null;
		
		public function MapLoaderTest()
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.showDefaultContextMenu = false;
			
			_gridMapLoader = new GridMapLoader(2500, 2000, 250, 200, 
				"asset/map/smallMap.jpg", 1, 
				"asset/map/cell/bigMap__$row$_x_$col$_.jpg", "_$row$_", "_$col$_", 
				1, 1, false, 0, false, 250, 200
			);
			addChild(_gridMapLoader);
			
			_gridMapLoader.setViewPort(250, 200, 250, 200);
		}
	}
}