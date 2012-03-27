package com.codeTooth.actionscript.game.map.tile 
{
	import com.codeTooth.actionscript.algorithm.pathSearching.base.IPathSearching;
	import com.codeTooth.actionscript.core.codeTooth_internal;
	import com.codeTooth.actionscript.display.SimpleBigBitmap;
	import com.codeTooth.actionscript.game.map.Map;
	import com.codeTooth.actionscript.game.map.MapInitializeParameters;
	import com.codeTooth.actionscript.lang.errors.AbstractError;
	import com.codeTooth.actionscript.lang.exceptions.NoSuchObjectException;
	import com.codeTooth.actionscript.lang.exceptions.NullPointerException;
	import com.codeTooth.actionscript.lang.utils.ArrayUtil;
	import com.codeTooth.actionscript.lang.utils.Assert;
	import com.codeTooth.actionscript.lang.utils.destroy.DestroyUtil;
	import com.codeTooth.actionscript.lang.utils.destroy.IDestroy;
	
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.display.IBitmapDrawable;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	public class TilesBase implements IDestroy 
	{
		use namespace codeTooth_internal;
		
		protected var _point2D:Point = null;
		
		public function TilesBase(mapInitParams:MapInitializeParameters) 
		{
			Assert.checkNull(mapInitParams);
			
			_point2D = new Point();
			_tilesDataMap = new Dictionary();
			initialize(mapInitParams);
		}
		
		//--------------------------------------------------------------------------------------------------------------------------------------
		// 对砖块的一些操作
		//--------------------------------------------------------------------------------------------------------------------------------------
		
		/**
		 * 通过id获得指定的砖块数据
		 * 
		 * @param	id
		 * 
		 * @return	没有找到指定id的砖块数据返回null
		 */
		public function getTileDataByID(id:Object):TileDataBase
		{
			return _tilesDataMap[id];
		}
		
		/**
		 * 通过行列值获得指定砖块数据
		 * 
		 * @param	row
		 * @param	col
		 * @param	rows
		 * @param	cols
		 * 
		 * @return	如果没有找到返回null
		 */
		public function getTileDataByRowCol(row:int, col:int, rows:uint, cols:uint):TileDataBase
		{
			return ArrayUtil.getItemByRowCol(_tilesData, row, col, rows, cols);
		}
		
		/**
		 * 通过行列值获得指定砖块在屏幕上的坐标
		 * 
		 * @param	row
		 * @param	col
		 * @param	rows
		 * @param	cols
		 * 
		 * @return	返回砖块的屏幕坐标，如果没有找到返回null
		 */
		public function getTileScreenCoordinateByRowCol(row:int, col:int, rows:uint, cols:uint):Point
		{
			var tileData:TileDataBase = ArrayUtil.getItemByRowCol(_tilesData, row, col, rows, cols);
			if (tileData == null)
			{
				return null;
			}
			else
			{
				_point2D.x = tileData.screenX;
				_point2D.y = tileData.screenY;
				
				return _point2D;
			}
		}
		
		/**
		 * 通过id找到指定砖块的屏幕坐标
		 * 
		 * @param	id
		 * 
		 * @return	返回砖块的屏幕坐标，如果没有找到返回null
		 */
		public function getTileScreenCoordinateByID(id:Object):Point
		{
			if (_tilesData[id] == undefined)
			{
				return null;
			}
			else
			{
				var tileData:TileDataBase = _tilesData[id];
				_point2D.x = tileData.screenX;
				_point2D.y = tileData.screenY;
				
				return _point2D;
			}
		}
		
		/**
		 * 显示辅助砖块
		 * 
		 * @param	mapInitParams
		 * 
		 * @return 是否成功显示
		 */
		public function showAssistantTiles(canvas:Graphics, pRows:uint, pCols:uint, mapInitParams:MapInitializeParameters):void
		{
			if(canvas == null)
			{
				throw new NoSuchObjectException("Has not the specified assistantTiles canvas");
			}
			
			Assert.checkNull(mapInitParams);
			
			var length:int = _tilesData.length;
			var row:int;
			var col:int;
			var cols:uint = mapInitParams.cols;
			
			canvas.clear();
			canvas.lineStyle(mapInitParams.assistantLineThickness, mapInitParams.assistantLineColor, mapInitParams.assistantLineAlpha);
			for (var i:int = 0; i < length; i++)
			{
				if (_tilesData[i] != null)
				{
					row = int(i / cols);
					col = i % cols;
					if (row < pRows && col < pCols)
					{
						drawAsstTile(canvas, _tilesData[i], mapInitParams)
					}
				}
			}
		}
		
		// 画辅助线条
		protected function drawAsstTile(canvas:Graphics, tileData:TileDataBase, mapInitParams:MapInitializeParameters):void
		{
			throw new AbstractError();
		}
		
		/**
		 * 隐藏辅助砖块
		 * 
		 * @return 返回是否成功隐藏
		 */
		public function hideAssistantTiles(graphics:Graphics):Boolean
		{
			if (graphics == null)
			{
				return false;
			}
			else
			{
				graphics.clear();
				
				return true;
			}
		}
		
				/**
		 * 在指定的行列画砖块
		 * 
		 * @param	tile
		 * @param	x	指定的列
		 * @param	y	指定的行
		 * @param	width
		 * @param	height
		 * @param	mapInitParams
		 * 
		 * @return
		 */
		public function drawTileByRowCol(tile:IBitmapDrawable, x:int, y:int, width:Number, height:Number, mapInitParams:MapInitializeParameters):IBitmapDrawable
		{
			var scrPoint:Point = getScreenCoordinateByRowCol(y, x, mapInitParams);
			
			return drawToTileCanvas(tile, scrPoint.x, scrPoint.y, width, height);
		}
		
		/**
		 * 向砖块画布上画一个对象。指定的对象必须是左上角对其注册点
		 * 
		 * @param	target	指定的对象
		 * @param	width	对象的宽，NaN表示默认的使用的target的width属性
		 * @param	height	对象的高，NaN表示默认的使用的target的height属性
		 * @param	x	画在画布上的x坐标
		 * @param	y	画在画布上的y坐标
		 * 
		 * @return	返回成功画到画布上的对象
		 */
		public function drawToTileCanvas(target:IBitmapDrawable, x:Number = 0, y:Number = 0, width:Number = NaN, height:Number = NaN):IBitmapDrawable
		{
			return _tileCanvas.draw(target, x, y, width, height);
		}
		
		/**
		 * 在指定的行列画砖块
		 * 
		 * @param	tile
		 * @param	x	指定的列
		 * @param	y	指定的行
		 * @param	mapInitParams
		 * 
		 * @return
		 */
		public function copyTilePixelsByRowCol(tile:BitmapData, tileRect:Rectangle, x:int, y:int, mapInitParams:MapInitializeParameters):BitmapData
		{
			var scrPoint:Point = getScreenCoordinateByRowCol(y, x, mapInitParams);
			
			return copyPixelsToTileCanvas(tile, tileRect, scrPoint.x, scrPoint.y);
		}
		
		/**
		 * 向砖块画布上画一个位图
		 * 
		 * @param	target	指定的位图
		 * @param	x	画在画布上的x坐标
		 * @param	y	画在画布上的y坐标
		 * 
		 * @return	返回成功画到画布上的位图
		 */
		public function copyPixelsToTileCanvas(bmpd:BitmapData, bmpdRect:Rectangle = null, x:Number = 0, y:Number = 0):BitmapData
		{
			return _tileCanvas.copyPixels(bmpd, bmpdRect, x, y);
		}
		
		/**
		 * 清除画在砖块画布上的图像
		 */
		public function clearTileCanvas():void
		{
			_tileCanvas.fill(0x00000000);
		}
		
		// 将行列坐标转换成屏幕坐标
		public function getScreenCoordinateByRowCol(row:int, col:int, mapInitParams:MapInitializeParameters):Point
		{
			throw new AbstractError();
			return null;
		}
		
		// 将屏幕坐标转换为行列坐标
		public function getRowColByScreenCoordinate(x:Number, y:Number, mapInitParams:MapInitializeParameters):Point
		{
			throw new AbstractError();
			return null;
		}
		
		// 获得砖块中心点相对于砖块左上角的偏移量
		public function getTileCenterOffset(mapInitParams:MapInitializeParameters):Point
		{
			throw new AbstractError();
			return null;
		}
		
		// 初始化所有砖块
		protected function initialize(mapInitParams:MapInitializeParameters):void
		{
			throw new AbstractError();
		}
		
		protected function createTilesInternal(mapInitParams:MapInitializeParameters):void
		{
			throw new AbstractError();
		}
		
		//-----------------------------------------------------------------------------------------------------------
		// 寻路
		//-----------------------------------------------------------------------------------------------------------
		
		protected var _pathSearching:IPathSearching = null;
		
		/**
		 * 寻路
		 * 
		 * @param	rowFrom	起始行
		 * @param	colFrom	起始列
		 * @param	rowTo	目标行
		 * @param	colTo	目标列
		 * 
		 * @return	返回结果路径。没有找到路径返回null
		 */
		public function searchPath(rowFrom:int, colFrom:int, rowTo:int, colTo:int):Vector.<Vector.<int>>
		{
			if (_pathSearching == null)
			{
				throw new NoSuchObjectException("Has not pathSearchingObject be created");
				return null;
			}
			else
			{
				return _pathSearching.search(rowFrom, colFrom, rowTo, colTo);
			}
		}
		
		/**
		 * 获得寻路对象
		 * 
		 * @return
		 */
		public function getPathSearching():IPathSearching
		{
			return _pathSearching;
		}
		
		/**
		 * 设置寻路对象
		 * 
		 * @param	obj
		 */
		public function setPathSearching(obj:IPathSearching):void
		{
			_pathSearching = obj;
		}
		
		/**
		 * 创建寻路对象
		 * 
		 * @param	map
		 */
		public function createDefaultPathSearching(map:Map):void
		{
			throw new AbstractError();
		}
		
		//-----------------------------------------------------------------------------------------------------------
		// Tiles
		//-----------------------------------------------------------------------------------------------------------
		
		// 砖块画布
		protected var _tileCanvas:SimpleBigBitmap = null;
		
		// 存储砖块数据
		protected var _tilesData:Vector.<TileDataBase> = null;
		protected var _tilesDataMap:Dictionary = null;
		
		// 砖块的坐标偏移（菱形地图菱形砖块会使用这个参数，以保证砖块的坐标都是正数）
		protected var _tileOffsetX:Number = 0;
		
		// 所有砖块形成的矩形区域
		protected var _tilesBounds:Rectangle = null;
		
		/**
		 * 获得砖块形成的矩形区域
		 * 
		 * @return
		 */
		public function getTilesBounds():Rectangle
		{
			return _tilesBounds;
		}
		
		/**
		 * 获得所有砖块的数据
		 * 
		 * @return
		 */
		public function getTilesData():Vector.<TileDataBase>
		{
			return _tilesData;
		}
		
		/**
		 * 获得所有砖块的数据
		 * 
		 * @return
		 */
		public function getTilesDataMap():Dictionary
		{
			return _tilesDataMap;
		}
		
		private function destroyTiles():void
		{			
			_tilesBounds = null;
			DestroyUtil.breakMap(_tilesDataMap);
			_tilesDataMap = null;
			DestroyUtil.destroyVector(_tilesData);
			_tilesData = null;
			
			if (_tileCanvas != null)
			{
				_tileCanvas.destroy();
				if (_tileCanvas.parent != null)
				{
					_tileCanvas.parent.removeChild(_tileCanvas);
				}
				_tileCanvas = null;
			}
		}
		
		//-----------------------------------------------------------------------------------------------------------
		// 实现 IDestroy 接口
		//-----------------------------------------------------------------------------------------------------------
		
		public function destroy():void
		{
			destroyTiles();
			_point2D = null;
			_pathSearching = null;
		}
		
	}

}