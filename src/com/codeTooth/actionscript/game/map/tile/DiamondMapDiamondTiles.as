package com.codeTooth.actionscript.game.map.tile 
{
	import com.codeTooth.actionscript.core.codeTooth_internal;
	import com.codeTooth.actionscript.display.GraphicsPen;
	import com.codeTooth.actionscript.display.SimpleBigBitmap;
	import com.codeTooth.actionscript.game.map.Map;
	import com.codeTooth.actionscript.game.map.MapInitializeParameters;
	import com.codeTooth.actionscript.game.map.pathSearching.DiamondMapDiamondTilesPathSearching;
	import com.codeTooth.actionscript.lang.exceptions.NullPointerException;
	import com.codeTooth.actionscript.lang.utils.Assert;
	import com.codeTooth.actionscript.lang.utils.Common;
	import com.codeTooth.actionscript.lang.utils.geom.Mathematic;
	import com.codeTooth.actionscript.lang.utils.geom.Point3D;
	
	import flash.display.Graphics;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 * 菱形地图菱形砖块。
	 * 示意图。（行_列）
	 *          0_0
	 *       1_0   0_1
	 *    2_0   1_1   0_2
	 * 3_0   2_1   1_2   0_3
	 *    3_1   2_2   1_3
	 *       3_2   2_3
	 *          3_3
	 */
	public class DiamondMapDiamondTiles extends TilesBase 
	{
		use namespace codeTooth_internal;
		
		public function DiamondMapDiamondTiles(mapInitParams:MapInitializeParameters) 
		{
			super(mapInitParams);
		}
		
		//----------------------------------------------------------------------------------------------------------------
		// 重写抽象方法
		//----------------------------------------------------------------------------------------------------------------
		
		override public function createDefaultPathSearching(map:Map):void
		{
			_pathSearching = new DiamondMapDiamondTilesPathSearching(map);
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
			
			GraphicsPen.drawDiamond(canvas, mapInitParams.tileSize, tileData.screenX, tileData.screenY, false);
		}
		
		override public function getScreenCoordinateByRowCol(row:int, col:int, mapInitParams:MapInitializeParameters):Point
		{
			Assert.checkNull(mapInitParams);
			
			var tileSize:uint = mapInitParams.tileSize;
			var scrPos:Point = Mathematic.isoWorldToScreenStandard(col * tileSize, 0, row * tileSize);
			_point2D.x = scrPos.x + _tileOffsetX;
			_point2D.y = scrPos.y;
			
			return _point2D;
		}
		
		override public function getRowColByScreenCoordinate(x:Number, y:Number, mapInitParams:MapInitializeParameters):Point
		{
			Assert.checkNull(mapInitParams);
			
			// 将行列转换为屏幕坐标的一个反操作
			x -= _tileOffsetX + mapInitParams.tileSize;
			var tileSize:uint = mapInitParams.tileSize;
			var tempP:Point3D = Mathematic.isoScreenToWorldStandard(x, y);
			_point2D.x = Math.floor(tempP.x / tileSize);
			_point2D.y = Math.floor(tempP.z / tileSize);
			
			return _point2D;
		}
		
		override protected function initialize(mapInitParams:MapInitializeParameters):void
		{
			Assert.checkNull(mapInitParams);
			
			// 砖块的坐标偏移
			_tileOffsetX = Map.getTileOffsetX(mapInitParams.getMapType(), mapInitParams.rows, mapInitParams.cols, mapInitParams.tileSize);
			
			// 砖块区域
			// 使用标准的等角坐标转换
			_tilesBounds = Map.getTilesBounds(mapInitParams.getMapType(), mapInitParams.rows, mapInitParams.cols, mapInitParams.tileSize);
			
			// 砖块画布
			_tileCanvas = new SimpleBigBitmap(
				SimpleBigBitmap.CELL_SIZE, SimpleBigBitmap.CELL_SIZE, 
				Math.ceil(_tilesBounds.width), Math.ceil(_tilesBounds.height), 
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
			var scrPos:Point;
			var tileData:TileDataBase;
			var createTileData:Function = mapInitParams.getCreateTileData();
			var tx:Number;
			var ty:Number;
			var tilesCount:int = 0;
			_tilesData = new Vector.<TileDataBase>(rows * cols);
			
			for (var z:uint = 0; z < rows; z++)
			{
				for (var x:uint = 0; x < cols; x++)
				{
					// 将世界坐标转换成屏幕坐标
					scrPos = Mathematic.isoWorldToScreenStandard(x * tileSize, 0, z * tileSize);
					tx = scrPos.x + _tileOffsetX;
					ty = scrPos.y;
					
					if (createTile != null)
					{
						_tileCanvas.copyPixels(createTile(mapInitParams, z, x), null, tx, ty);
					}
					
					if(createTileData == null)
					{
						tileData = new TileDataBase(z + Common.DELIM + x);
					}
					else
					{
						tileData = createTileData(mapInitParams, z, x);
					}
					
					_tilesDataMap[tileData.getUniqueID()] = tileData;
					_tilesData[tilesCount++] = tileData;
					
					tileData.setX(x);
					tileData.setY(z);
					tileData.setZ(0);
					tileData.setScreenX(tx);
					tileData.setScreenY(ty);
				}
			}
			
		}
		
		override public function getTileCenterOffset(mapInitParams:MapInitializeParameters):Point
		{
			Assert.checkNull(mapInitParams);
			
			_point2D.x = mapInitParams.tileSize;
			_point2D.y = mapInitParams.tileSize * .5;
			
			return _point2D;
		}
	}

}