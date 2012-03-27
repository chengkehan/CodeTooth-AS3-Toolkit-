package
{
	import com.codeTooth.actionscript.game.map.Map;
	import com.codeTooth.actionscript.game.map.MapInitializeParameters;
	import com.codeTooth.actionscript.game.map.MapType;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	
	[SWF(width="1000", height="700", frameRate="24")]
	public class MapTest extends Sprite
	{
		[Embed(source="../asset/map/image/map.jpg")]
		private var _mapImage:Class;
		
		private var _map:Map = null;
		
		private var _tileContainer:DisplayObjectContainer = null;
		
		private var _elementContainer:DisplayObjectContainer = null;
		
		private var _unwalkableMarkContainer:DisplayObjectContainer = null;
		
		private var _asstTileCanvas:Shape = null;
		
		public function MapTest()
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			_tileContainer = new Sprite();
			addChild(_tileContainer);
			
			_elementContainer = new Sprite();
			addChild(_elementContainer);
			
			_unwalkableMarkContainer = new Sprite();
			addChild(_unwalkableMarkContainer);
			
			_asstTileCanvas = new Shape();
			addChild(_asstTileCanvas);
			
			var initParams:MapInitializeParameters = new MapInitializeParameters(
				16, 20, MapType.RECTANGLE_MAP_RECTANGLE_TILE, 40, _tileContainer, _elementContainer
			);
			
			initParams.unwalkableMarkColor = 0x444444;
			initParams.setUnwalkableMarkContainer(_unwalkableMarkContainer);
			initParams.setCreateUnwalkableMark(createUnwalbableMark);
			
			initParams.setAssistantTileCanvas(_asstTileCanvas.graphics);
			initParams.assistantLineColor = 0x444444;
			initParams.assistantLineThickness = 1;
			
			initParams.elementTileCenterAlign = true;
			
			_map = new Map(initParams);
			
//			_map.addUnwalkableTileByRowCol(0, 0);
//			_map.showUnwalkableMarks();
			
			_map.showAssistantTiles();
			
//			_map.removeUnwalkableTileByRowCol(0, 0);
			
			_map.copyPixelsToTileCanvas(Bitmap(new _mapImage()).bitmapData);
		}
		
		private function createUnwalbableMark(initParams:MapInitializeParameters):DisplayObject
		{
			var mark:Shape = new Shape();
			mark.graphics.beginFill(0xFF0000);
			mark.graphics.drawCircle(0, 0, 5);
			mark.graphics.endFill();
			
			return mark;
		}
	}
}