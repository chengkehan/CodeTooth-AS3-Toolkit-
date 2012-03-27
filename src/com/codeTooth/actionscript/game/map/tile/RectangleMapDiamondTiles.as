package com.codeTooth.actionscript.game.map.tile 
{
	import com.codeTooth.actionscript.core.codeTooth_internal;
	import com.codeTooth.actionscript.display.GraphicsPen;
	import com.codeTooth.actionscript.display.SimpleBigBitmap;
	import com.codeTooth.actionscript.game.map.Map;
	import com.codeTooth.actionscript.game.map.MapInitializeParameters;
	import com.codeTooth.actionscript.game.map.pathSearching.RectangleMapDiamondTilesPathSearching;
	import com.codeTooth.actionscript.lang.exceptions.NullPointerException;
	import com.codeTooth.actionscript.lang.utils.Assert;
	import com.codeTooth.actionscript.lang.utils.Common;
	import com.codeTooth.actionscript.lang.utils.geom.Mathematic;
	
	import flash.display.Graphics;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 * 矩形地图菱形砖块。
	 * 示意图。（行_列）
	 * 0_0   0_2   0_4   0_6   0_8
	 *    0_1   0_3   0_5   0_7
	 * 1_0   1_2   1_4   1_6   0_8
	 *    1_1   1_3   1_5   1_7
	 */
	public class RectangleMapDiamondTiles extends TilesBase 
	{
		use namespace codeTooth_internal;
		
		public function RectangleMapDiamondTiles(mapInitParams:MapInitializeParameters) 
		{
			super(mapInitParams);
		}
		
		//-------------------------------------------------------------------------------------------------------------
		// 重写抽象方法
		//-------------------------------------------------------------------------------------------------------------
		
		override public function createDefaultPathSearching(map:Map):void
		{
			_pathSearching = new RectangleMapDiamondTilesPathSearching(map);
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
			// 偶数列
			if ((col & 1) == 0)
			{
				_point2D.y = row * tileSize;
			}
			// 奇数列
			else
			{
				_point2D.y = row * tileSize + tileSize * .5;
			}
			_point2D.x = col * tileSize + _tileOffsetX;
			
			return _point2D;
		}
		
		override public function getRowColByScreenCoordinate(x:Number, y:Number, mapInitParams:MapInitializeParameters):Point
		{
			Assert.checkNull(mapInitParams);
			
			// 以tileSize水平划分，以tileSize/2垂直划分，形成矩形栅格
			// 判断当前鼠标在当前矩形中的那个三角形中，然后看这个三角属于哪个菱形，以此来判断在哪个菱形中
			var tileSize:uint = mapInitParams.tileSize
			var halfTileSize:Number = tileSize * .5;
			// 当前的行
			var row:int = Math.floor(y / halfTileSize);
			// 当前的列
			var col:int = Math.floor(x / tileSize);
			// 当前栅格的左上角坐标
			var tx:Number = col * tileSize;
			var ty:Number = row * halfTileSize;
			// 行列之和是偶数，当前坐标值可能会落在二四象限的三角内
			if (((row + col) & 1) == 0)
			{
				// 在二象限三角内
				if (Mathematic.pointInTriangle(x, y, tx + tileSize, ty, tx + tileSize, ty + halfTileSize, tx, ty + halfTileSize))
				{
					_point2D.x = col;
					_point2D.y = Math.floor(row * .5);;
				}
				// 在四象限三角内
				else
				{
					// 根据当前的行列值算出当前点击三角所在菱形的行列值
					// 列是偶数
					if ((col & 1) == 0)
					{
						_point2D.x = col - 1;
						_point2D.y = Math.floor(row * .5) - 1;
					}
					else
					{
						_point2D.x = col - 1;
						_point2D.y = Math.floor(row * .5);
					}
				}
			}
			// 可能会落在一三象限三角内
			else
			{
				// 在一象限三角内
				if (Mathematic.pointInTriangle(x, y, tx, ty, tx + tileSize, ty + halfTileSize, tx, ty + halfTileSize))
				{
					_point2D.x = col - 1;
					_point2D.y = Math.floor(row * .5);
				}
				// 在三象限三角内
				else
				{
					if ((col & 1) == 0)
					{
						_point2D.x = col;
						_point2D.y = Math.floor(row * .5);
					}
					else
					{
						_point2D.x = col;
						_point2D.y = Math.floor(row * .5) - 1;
					}
				}
			}
			
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
			var rows:uint = mapInitParams.rows;
			var cols:uint = mapInitParams.cols;
			var tileSize:uint = mapInitParams.tileSize;
			var tileData:TileDataBase;
			var createTileData:Function = mapInitParams.getCreateTileData();
			var tx:Number;
			var ty:Number;
			var tilesCount:int = 0;
			_tilesData = new Vector.<TileDataBase>(rows * cols);
			
			for (var row:uint = 0; row < rows; row++)
			{
				for (var col:uint = 0; col < cols; col++)
				{
					// 偶数列
					if ((col & 1) == 0)
					{
						ty = row * tileSize;
					}
					// 奇数列
					else
					{
						ty = row * tileSize + tileSize * .5;
					}
					tx = col * tileSize + _tileOffsetX;
					
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
					_tilesData[tilesCount++] = tileData;
					
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
			
			_point2D.x = mapInitParams.tileSize;
			_point2D.y = mapInitParams.tileSize * .5;
			
			return _point2D;
		}
	}

}