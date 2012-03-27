package com.codeTooth.actionscript.game.map.tile 
{
	import com.codeTooth.actionscript.core.codeTooth_internal;
	import com.codeTooth.actionscript.display.GraphicsPen;
	import com.codeTooth.actionscript.display.SimpleBigBitmap;
	import com.codeTooth.actionscript.game.map.Map;
	import com.codeTooth.actionscript.game.map.MapInitializeParameters;
	import com.codeTooth.actionscript.game.map.pathSearching.RectangleMapHexagonTilesPathSearching;
	import com.codeTooth.actionscript.lang.exceptions.NullPointerException;
	import com.codeTooth.actionscript.lang.utils.Assert;
	import com.codeTooth.actionscript.lang.utils.Common;
	import com.codeTooth.actionscript.lang.utils.geom.Mathematic;
	
	import flash.display.Graphics;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 * 菱形地图六边形砖块。
	 * 示意图。（行_列）
	 * 0_0   0_2   0_4   0_6   0_8
	 *    0_1   0_3   0_5   0_7
	 * 1_0   1_2   1_4   1_6   0_8
	 *    1_1   1_3   1_5   1_7
	 */
	public class RectangleMapHexagonTiles extends TilesBase 
	{
		use namespace codeTooth_internal;
		
		public function RectangleMapHexagonTiles(mapInitParams:MapInitializeParameters) 
		{
			super(mapInitParams);
		}
		
		//-----------------------------------------------------------------------------------------------------
		// 重写抽象方法
		//-----------------------------------------------------------------------------------------------------
		
		override public function createDefaultPathSearching(map:Map):void
		{
			_pathSearching = new RectangleMapHexagonTilesPathSearching(map);
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
			
			GraphicsPen.drawHexagon(canvas, mapInitParams.tileSize, tileData.screenX, tileData.screenY, false);
		}
		
		override public function getScreenCoordinateByRowCol(row:int, col:int, mapInitParams:MapInitializeParameters):Point
		{
			Assert.checkNull(mapInitParams);
			
			var R:Number = mapInitParams.tileSize;
			var hOffset:Number = 3 / 2 * R;
			var vOffsetInALine:Number = Mathematic.getHexagonInnerRByOuterR(R);
			var vOffset:Number = 2 * vOffsetInALine;
			// 偶数列
			if ((col & 1) == 0)
			{
				_point2D.y = row * vOffset;
			}
			// 奇数列
			else
			{
				_point2D.y = row * vOffset + vOffsetInALine;
			}
			_point2D.x = col * hOffset + _tileOffsetX;
			
			return _point2D;
		}
		
		override public function getRowColByScreenCoordinate(x:Number, y:Number, mapInitParams:MapInitializeParameters):Point
		{
			Assert.checkNull(mapInitParams);
			
			var R:Number = mapInitParams.tileSize;
			var rowHeight:Number = Mathematic.getHexagonInnerRByOuterR(R);
			var colWidth:Number = R * .5;
			var row:int = Math.floor(y / rowHeight);
			var col:int = Math.floor(x / colWidth);
			var tx:Number = col * colWidth;
			var ty:Number = row * rowHeight;
			var tempCol:int;
			// col 0, 3, 6, 9
			if (col % 3 == 0)
			{
				// /
				if (((row + col) & 1) == 0)
				{
					// down
					if (Mathematic.pointInTriangle(x, y, tx + colWidth, ty, tx + colWidth, ty + rowHeight, tx, ty + rowHeight))
					{
						_point2D.x = Math.floor(col / 3);
						_point2D.y = Math.floor(row * .5);
					}
					// up
					else
					{
						_point2D.x = Math.floor(col / 3) - 1;
						if ((row & 1) == 0)
						{
							_point2D.y = Math.floor(row * .5) - 1;
						}
						else
						{
							_point2D.y = Math.floor(row * .5);
						}
					}
				}
				// \
				else
				{
					// down
					if (Mathematic.pointInTriangle(x, y, tx, ty, tx + colWidth, ty, tx + colWidth, ty + rowHeight))
					{
						_point2D.x = Math.floor(col / 3);
						if ((row & 1) == 0)
						{
							_point2D.y = Math.floor(row * .5) - 1;
						}
						else
						{
							_point2D.y = Math.floor(row * .5);
						}
					}
					else
					{
						_point2D.x = Math.floor(col / 3) - 1;
						_point2D.y = Math.floor(row * .5);
					}
				}
			}
			// col 1 2, 4 5, 7 8, 10 11
			else
			{
				tempCol = Math.floor(col / 3);
				// col 1 2, 7 8
				if ((tempCol & 1) == 0)
				{
					// row 0, 2, 4
					if ((row & 1) == 0)
					{
						_point2D.x = tempCol;
						_point2D.y = Math.floor((row + 1) * .5);
					}
					// row 1, 3, 5
					else
					{
						_point2D.x = tempCol;
						_point2D.y = Math.floor(row * .5);
					}
				}
				// col 4 5, 10 11
				else
				{
					// row 0, 2, 4
					if ((row & 1) == 0)
					{
						_point2D.x = tempCol;
						_point2D.y = Math.floor((row + 1) * .5) - 1;
					}
					// row 1, 3, 5
					else
					{
						_point2D.x = tempCol;
						_point2D.y = Math.floor(row * .5);
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
			// 外接圆半径R
			var R:Number = mapInitParams.tileSize;
			// 水平相邻的两列的x偏移量,3/2R
			var hOffset:Number = 3 / 2 * R;
			// 同一行中，奇数列和偶数列六边形y轴偏移量，sqrt(3) / 2 * R
			var vOffsetInALine:Number = Mathematic.getHexagonInnerRByOuterR(R);
			// 垂直相邻两列的y偏移量
			var vOffset:Number = 2 * vOffsetInALine;
			var tileData:TileDataBase;
			var createTileData:Function = mapInitParams.getCreateTileData();
			var tx:Number;
			var ty:Number;
			var tileSize:uint = mapInitParams.tileSize;
			var tilesCount:int = 0;
			_tilesData = new Vector.<TileDataBase>(rows * cols);
			
			for (var row:uint = 0; row < rows; row++)
			{
				for (var col:uint = 0; col < cols; col++)
				{
					// 偶数列
					if ((col & 1) == 0)
					{
						ty = row * vOffset;
					}
					// 奇数列
					else
					{
						ty= row * vOffset + vOffsetInALine;
					}
					tx = col * hOffset + _tileOffsetX;
					
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
			_point2D.y = Mathematic.getHexagonInnerRByOuterR(_point2D.x);;
			
			return _point2D;
		}
	}

}