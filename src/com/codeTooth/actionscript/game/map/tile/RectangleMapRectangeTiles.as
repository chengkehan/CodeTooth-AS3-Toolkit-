package com.codeTooth.actionscript.game.map.tile 
{
	import com.codeTooth.actionscript.core.codeTooth_internal;
	import com.codeTooth.actionscript.display.GraphicsPen;
	import com.codeTooth.actionscript.display.SimpleBigBitmap;
	import com.codeTooth.actionscript.game.map.Map;
	import com.codeTooth.actionscript.game.map.MapInitializeParameters;
	import com.codeTooth.actionscript.game.map.pathSearching.RectangleMapRectangleTilesPathSearching;
	import com.codeTooth.actionscript.lang.exceptions.NullPointerException;
	import com.codeTooth.actionscript.lang.utils.Assert;
	import com.codeTooth.actionscript.lang.utils.Common;
	
	import flash.display.Graphics;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 * 矩形地图举行砖块。
	 * 示意图。（行_列）
	 * 0_0   0_1   0_2   0_3
	 * 1_0   1_1   1_2   1_3
	 * 2_0   2_1   2_2   2_3
	 */
	public class RectangleMapRectangeTiles extends TilesBase 
	{
		use namespace codeTooth_internal;
		
		public function RectangleMapRectangeTiles(mapInitParams:MapInitializeParameters) 
		{
			super(mapInitParams);
		}
		
		//-------------------------------------------------------------------------------------------------------------
		// 重写抽象方法
		//-------------------------------------------------------------------------------------------------------------
		
		override public function createDefaultPathSearching(map:Map):void
		{
			_pathSearching = new RectangleMapRectangleTilesPathSearching(map);
		}
		
		override protected function drawAsstTile(canvas:Graphics, tileData:TileDataBase, mapInitParams:MapInitializeParameters):void
		{
			Assert.checkNull(mapInitParams);
			if (canvas == null)
			{
				throw new NullPointerException("Null canvas");
			}
			if (tileData == null)
			{
				throw new NullPointerException("Null tileData");
			}
			
			GraphicsPen.drawRectangle(canvas, mapInitParams.tileSize, mapInitParams.tileSize, tileData.screenX, tileData.screenY, false);
		}
		
		override public function getScreenCoordinateByRowCol(row:int, col:int, mapInitParams:MapInitializeParameters):Point
		{
			Assert.checkNull(mapInitParams);
			
			var tileSize:uint = mapInitParams.tileSize;
			_point2D.x = col * tileSize;
			_point2D.y = row * tileSize;
			
			return _point2D;
		}
		
		override public function getRowColByScreenCoordinate(x:Number, y:Number, mapInitParams:MapInitializeParameters):Point
		{
			Assert.checkNull(mapInitParams);
			
			var tileSize:uint = mapInitParams.tileSize;
			_point2D.x = Math.floor(x / tileSize);
			_point2D.y = Math.floor(y / tileSize);
			
			return _point2D;
		}
		
		override protected function initialize(mapInitParams:MapInitializeParameters):void
		{	
			Assert.checkNull(mapInitParams);
			
			// 砖块区域
			_tilesBounds = Map.getTilesBounds(mapInitParams.getMapType(), mapInitParams.rows, mapInitParams.cols, mapInitParams.tileSize);
			
			// 砖块画布
			_tileCanvas = new SimpleBigBitmap(
				SimpleBigBitmap.CELL_SIZE, SimpleBigBitmap.CELL_SIZE, 
				_tilesBounds.width, _tilesBounds.height, 
				mapInitParams.tileCanvasTransparent, mapInitParams.tileCanvasColor
			);
			mapInitParams.getTileContainer().addChild(_tileCanvas);
			
			// 创建砖块
			createTilesInternal(mapInitParams);
		}
		
		override protected function createTilesInternal(mapInitParams:MapInitializeParameters):void
		{
			Assert.checkNull(mapInitParams);
			
			var createTile:Function = mapInitParams.getCreateTile();
			var tileSize:uint = mapInitParams.tileSize;
			var rows:uint = mapInitParams.rows;
			var cols:uint = mapInitParams.cols;
			var tileData:TileDataBase;
			var createTileData:Function = mapInitParams.getCreateTileData();
			var tx:Number;
			var ty:Number;
			var tileCount:int = 0;
			_tilesData = new Vector.<TileDataBase>(rows * cols);
			
			for (var row:uint = 0; row < rows; row++)
			{
				for (var col:uint = 0; col < cols; col++)
				{
					tx = col * tileSize + _tileOffsetX;
					ty = row * tileSize;
					
					if (createTile != null)
					{
						_tileCanvas.copyPixels(createTile(mapInitParams, row, col), null, tx, ty);
					}
					
					if(createTileData == null)
					{
						tileData = new TileDataBase(row + Common.DELIM + col);
					}
					else
					{
						tileData = createTileData(mapInitParams, row, col);
					}
					
					_tilesDataMap[tileData.getUniqueID()] = tileData;
					_tilesData[tileCount++] = tileData;
					
					tileData.setX(col);
					tileData.setY(row);
					tileData.setZ(0);
					tileData.setScreenX(tx);
					tileData.setScreenY(ty);
				}
			}
		}
		
		override public function getTileCenterOffset(mapInitParams:MapInitializeParameters):Point
		{
			Assert.checkNull(mapInitParams);
			
			_point2D.x = mapInitParams.tileSize * .5;
			_point2D.y = _point2D.x;
			
			return _point2D;
		}
		
	}

}