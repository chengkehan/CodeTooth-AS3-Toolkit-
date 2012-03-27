package com.codeTooth.actionscript.game.map 
{
	import com.codeTooth.actionscript.algorithm.pathSearching.base.IPathSearching;
	import com.codeTooth.actionscript.core.codeTooth_internal;
	import com.codeTooth.actionscript.game.map.element.ElementDataBase;
	import com.codeTooth.actionscript.game.map.element.Elements;
	import com.codeTooth.actionscript.game.map.element.IElement;
	import com.codeTooth.actionscript.game.map.tile.DiamondMapDiamondTiles;
	import com.codeTooth.actionscript.game.map.tile.RectangleMapDiamondTiles;
	import com.codeTooth.actionscript.game.map.tile.RectangleMapHexagonTiles;
	import com.codeTooth.actionscript.game.map.tile.RectangleMapRectangeTiles;
	import com.codeTooth.actionscript.game.map.tile.TileDataBase;
	import com.codeTooth.actionscript.game.map.tile.TilesBase;
	import com.codeTooth.actionscript.game.map.tile.UnwalkableMarks;
	import com.codeTooth.actionscript.lang.exceptions.IllegalParameterException;
	import com.codeTooth.actionscript.lang.exceptions.NoSuchObjectException;
	import com.codeTooth.actionscript.lang.exceptions.NullPointerException;
	import com.codeTooth.actionscript.lang.exceptions.UnknownTypeException;
	import com.codeTooth.actionscript.lang.utils.Assert;
	import com.codeTooth.actionscript.lang.utils.destroy.IDestroy;
	import com.codeTooth.actionscript.lang.utils.geom.Mathematic;
	
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.IBitmapDrawable;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	/**
	 * 地图
	 */
	public class Map implements IDestroy
	{
		use namespace codeTooth_internal;
		
		/**
		 * 构造函数
		 * 
		 * @param	initParams 初始化参数
		 * 
		 * @throws com.codeTooth.actionscript.lang.exceptions.NullPointerException 
		 * 初始化参数是null
		 */
		public function Map(initParams:MapInitializeParameters) 
		{
			if (initParams == null)
			{
				throw new NullPointerException("Null initParams");
			}
			
			_mapInitParams = initParams;
			initializeTiles();
			_elements = new Elements();
			_unwalkableMarks = new UnwalkableMarks();
		}
		
		//-----------------------------------------------------------------------------------------------------------
		// 寻路
		//-----------------------------------------------------------------------------------------------------------
		
		/**
		 * 开始寻路
		 * 
		 * @param	rowFrom	起始行
		 * @param	colFrom	起始列
		 * @param	rowTo	终止行
		 * @param	colTo	终止列
		 * 
		 * @return	返回寻路的结果。如果使用的是默认的寻路，返回结果见AStarLike#search
		 */
		public function searchPath(rowFrom:int, colFrom:int, rowTo:int, colTo:int):Vector.<Vector.<int>>
		{
			return _tiles.searchPath(rowFrom, colFrom, rowTo, colTo);
		}
		
		/**
		 * 创建默认的寻路器
		 */
		public function createDefaultPathSearching():void
		{
			_tiles.createDefaultPathSearching(this);
		}
		
		/**
		 * 设置自定义的寻路器
		 * 
		 * @param	obj
		 */
		public function setPathSearching(obj:IPathSearching):void
		{
			_tiles.setPathSearching(obj);
		}
		
		/**
		 * 获得当前的寻路器
		 * 
		 * @return
		 */
		public function getPathSearching():IPathSearching
		{
			return _tiles.getPathSearching();
		}
		
		//-----------------------------------------------------------------------------------------------------------
		// 不可行走点标记
		//-----------------------------------------------------------------------------------------------------------
		
		private var _unwalkableMarks:UnwalkableMarks = null;
		
		/**
		 * 显示所有的不可行走标记点
		 */
		public function showUnwalkableMarks():void
		{
			_unwalkableMarks.showAll(_mapInitParams, _tiles);
		}
		
		/**
		 * 隐藏所有的不可行走标记点
		 */
		public function hideUnwalkableMarks():void
		{
			_unwalkableMarks.hideAll(_mapInitParams);
		}
		
		/**
		 * 添加不可行走砖块通过行列值
		 * 
		 * @param	row
		 * @param	col
		 * 
		 * @throws	com.codeTooth.actionscript.lang.exceptions.IllegalParameterException 
		 * 指定的行列超出了最大值 
		 * @throws com.codeTooth.actionscript.lang.exceptions.NoSuchObjectException 
		 * 在指定的行列上没有找到砖块对象
		 */
		public function addUnwalkableTileByRowCol(row:uint, col:uint):void
		{
			if(row >= _mapInitParams.rows)
			{
				throw new IllegalParameterException("Row index \"" + row + "\" cannot >= rows \"" + _mapInitParams.rows + "\"");
			}
			if(col >= _mapInitParams.cols)
			{
				throw new IllegalParameterException("Col index \"" + col + "\" cannot >= cols \"" + _mapInitParams.cols + "\"");
			}
			
			var tileData:TileDataBase = _tiles.getTileDataByRowCol(row, col, _mapInitParams.rows, _mapInitParams.cols);
			if(tileData == null)
			{
				throw new NoSuchObjectException("Has not tile at row \"" + row + "\", col \"" + col + "\"");
			}
			
			if (tileData.unwalkable)
			{
				return;
			}
			tileData.setUnwalkable(true);
			_unwalkableMarks.showOne(row, col, _mapInitParams, _tiles);
		}
		
		/**
		 * 添加不可行走砖块通过屏幕坐标
		 * 
		 * @param	x
		 * @param	y
		 */
		public function addUnwalkableTileByScreenCoordinate(x:Number, y:Number):void
		{
			var rowCol:Point = _tiles.getRowColByScreenCoordinate(x, y, _mapInitParams);
			addUnwalkableTileByRowCol(rowCol.y, rowCol.x);
		}
		
		/**
		 * 添加不可行走砖块通过砖块id
		 * 
		 * @param	id
		 * 
		 * @return	返回是否成功添加
		 */
		public function addUnwalkableTileByTileID(id:Object):Boolean
		{
			var tileData:TileDataBase = _tiles.getTileDataByID(id);
			if (tileData == null)
			{
				return false;
			}
			if (tileData.unwalkable)
			{
				return false;
			}
			tileData.setUnwalkable(true);
			_unwalkableMarks.showOne(tileData.y, tileData.x, _mapInitParams, _tiles);
			
			return true;
		}
		
		/**
		 * 移除不可行走砖块通过行列值
		 * 
		 * @param	row
		 * @param	col
		 * 
		 * @return	返回是否成功移除
		 * 
		 * @throws	com.codeTooth.actionscript.lang.exceptions.NoSuchObjectException 
		 * 在指定的行列不存在砖块数据
		 */
		public function removeUnwalkableTileByRowCol(row:int, col:int):Boolean
		{
			if (row < 0 || row >= _mapInitParams.rows || col < 0 || col >= _mapInitParams.cols)
			{
				return false;
			}
			
			var tileData:TileDataBase = _tiles.getTileDataByRowCol(row, col, _mapInitParams.rows, _mapInitParams.cols);
			if (tileData == null)
			{
				throw new NoSuchObjectException("Has not the tileData \"" + tileData.getUniqueID() + "\"");
			}
			if (!tileData.unwalkable)
			{
				return false;
			}
			tileData.setUnwalkable(false);
			_unwalkableMarks.removeOne(row, col, _mapInitParams, _tiles);
			
			return true;
		}
		
		/**
		 * 移除不可行走砖块通过屏幕坐标
		 * 
		 * @param	x
		 * @param	y
		 * 
		 * @return	返回是否成功移除
		 */
		public function removeUnwalkableTileByScreenCoordinate(x:Number, y:Number):Boolean
		{
			var rowCol:Point = _tiles.getRowColByScreenCoordinate(x, y, _mapInitParams);
			return removeUnwalkableTileByRowCol(rowCol.y, rowCol.x);
		}
		
		/**
		 * 移除不可行走砖块通过砖块id
		 * 
		 * @param	id
		 * 
		 * @return	返回是否成功移除
		 */
		public function removeUnwalkableTileByTileID(id:Object):Boolean
		{
			var tileData:TileDataBase = _tiles.getTileDataByID(id);
			if (tileData == null)
			{
				return false;
			}
			if (!tileData.unwalkable)
			{
				return false;
			}
			tileData.setUnwalkable(false);
			_unwalkableMarks.removeOne(tileData.y, tileData.x, _mapInitParams, _tiles);
			
			return true;
		}
		
		private function destroyUnwalkableMarks():void
		{
			if (_unwalkableMarks != null)
			{
				_unwalkableMarks.destroy();
				_unwalkableMarks = null;
			}
		}
		
		//-----------------------------------------------------------------------------------------------------------
		// Elements
		//-----------------------------------------------------------------------------------------------------------
		
		private var _elements:Elements = null;
		
		/**
		 * 更新所有地图元素的斜率，地图元素的斜率参数用来计算遮挡关系
		 */
		public function updateElementsSlope():void
		{
			_elements.updateElementsSlope();
		}
		
		/**
		 * 更新指定地图元素的斜率，地图元素的斜率参数用来计算遮挡关系
		 * 
		 * @param	id
		 */
		public function updateElementSlope(id:Object):void
		{
			_elements.updateElementSlope(id);
		}
		
		/**
		 * 深度排序
		 */
		public function sortDepth():void
		{
			_elements.sortDepth(_mapInitParams);
		}
		
		/**
		 * 添加地图元素占位区域
		 * 
		 * @param	id
		 * @param	x
		 * @param	y
		 */
		public function addElementAreaPoint(id:Object, x:int, y:int):void
		{
			_elements.addAreaPoint(id, x, y);
		}
		
		/**
		 * 删除地图元素占位区域
		 * 
		 * @param	id
		 * @param	x
		 * @param	y
		 */
		public function removeElementAreaPoint(id:Object, x:int, y:int):void
		{
			_elements.removeAreaPoint(id, x, y);
		}
		
		/**
		 * 设定指定的地图元素的显示外观
		 * 
		 * @param	id
		 * @param	facade
		 * 
		 * @return	如果没有找到指定id的地图元素数据，返回false
		 */
		public function setElementFacade(id:Object, facade:BitmapData):Boolean
		{
			if (_elements.containsElement(id))
			{
				var element:IElement = _elements.getElement(id);
				var elementData:ElementDataBase = _elements.getElementData(element.getDataUniqueID());
				if (elementData == null)
				{
					throw new NullPointerException("Has not elementData");
				}
				elementData.setFacade(facade);
				element.setFacade(facade);
				
				return true;
			}
			else
			{
				return false;
			}
		}
		
		/**
		 * 获得地图元素
		 * 
		 * @param	id
		 * 
		 * @return	返回指定id的地图元素。没有找到返回null
		 */
		public function getElement(id:Object):IElement
		{
			return _elements.getElement(id);
		}
		
		/**
		 * 获得地图元素的数据
		 * 
		 * @param	id
		 * 
		 * @return	返回指定id的地图元素。没有找到返回null
		 */
		public function getElementData(id:Object):ElementDataBase
		{
			return _elements.getElementData(id);
		}
		
		/**
		 * 获得所有的地图元素。键是元素的id，值是类型是ElementBase的对象。仅提供遍历用
		 * 
		 * @return
		 */
		public function getElements():Dictionary
		{
			return _elements.getElements();
		}
		
		/**
		 * 获得所有地图元素数据。键是数据的id，值是类型是ElementDataBase的对象。仅提供遍历操作
		 * 
		 * @return
		 */
		public function getElementsData():Dictionary
		{
			return _elements.getElementsData();
		}
		
		/**
		 * 添加一个地图元素。
		 * 
		 * @param	element	地图元素
		 * @param	elementData	地图元素的数据
		 */
		public function addElement(element:IElement, elementData:ElementDataBase):void
		{	
			if(element == null)
			{
				throw new NullPointerException("Null element");
			}
			if(elementData == null)
			{
				throw new NullPointerException("Null elementData");
			}
			
			return _elements.addElement(element, elementData, _mapInitParams, _tiles);
		}
		
		/**
		 * 删除指定的地图元素
		 * 
		 * @param	id	要是删除的地图元素的id
		 */
		public function removeElement(id:Object):void
		{
			_elements.removeElement(id, _mapInitParams);
		}
		
		/**
		 * 通过行列值移动一个地图元素
		 * 
		 * @param	id	要移动地图元素的id号
		 * @param	x	移动到的列
		 * @param	y	移动到的行
		 */
		public function moveElementByRowCol(id:Object, x:int, y:int):void
		{
			_elements.moveElementByRowCol(id, x, y, _mapInitParams, _tiles);
		}
		
		/**
		 * 通过屏幕上的像素坐标移动地图元素
		 * 
		 * @param	id
		 * @param	x
		 * @param	y
		 */
		public function moveElementByScreenCoordinate(id:Object, x:Number, y:Number):void
		{
			_elements.moveElementByScreenCoordinate(id, x, y, _mapInitParams, _tiles);
		}
		
		/**
		 * 判断是否存在指定id的地图元素
		 * 
		 * @param	id
		 * 
		 * @return
		 */
		public function containsElement(id:Object):Boolean
		{
			return _elements.containsElement(id);
		}
		
		private function destroyElements():void
		{
			if (_elements != null)
			{
				_elements.destroy();
				_elements = null;
			}
		}
		
		//-----------------------------------------------------------------------------------------------------------
		// Tiles
		//-----------------------------------------------------------------------------------------------------------
		
		private var _tiles:TilesBase = null;
		
		private static var _tileBounds:Rectangle = new Rectangle();
		
		/**
		 * 通过指定的参数或的最终的地图尺寸
		 * 
		 * @param mapType
		 * @param rows
		 * @param cols
		 * @param tileSize
		 * 
		 * @return 
		 */
		public static function getTilesBounds(mapType:MapType, rows:uint, cols:uint, tileSize:uint):Rectangle
		{
			if(mapType == MapType.DIAMOND_MAP_DIAMOND_TILE)
			{
				var tileOffsetX:Number = getTileOffsetX(mapType, rows, cols, tileSize);
				var right:Point = Mathematic.isoWorldToScreenStandard(cols * tileSize, 0, 0).clone();
				var down:Point = Mathematic.isoWorldToScreenStandard(cols * tileSize, 0, rows * tileSize);
				
				_tileBounds.x = 0;
				_tileBounds.y = 0;
				_tileBounds.width = right.x + tileOffsetX + tileSize;
				_tileBounds.height = down.y;
				
				return _tileBounds;
			}
			else if(mapType == MapType.RECTANGLE_MAP_DIAMOND_TILE)
			{
				_tileBounds.x = 0;
				_tileBounds.y = 0;
				_tileBounds.width = tileSize * cols + tileSize;
				_tileBounds.height = tileSize * rows + tileSize * .5;
				
				return _tileBounds;
			}
			else if(mapType == MapType.RECTANGLE_MAP_HEXAGON_TILE)
			{
				var R:Number = tileSize;
				var D:Number = R * 2;
				var D_1_4:Number = D * .25;
				var h:Number = Mathematic.SQRT_3 * R * .5;
				
				_tileBounds.x = 0;
				_tileBounds.y = 0;
				_tileBounds.width = D * cols - (cols - 1) * D_1_4;
				_tileBounds.height = h * 2 * rows + h;
				
				return _tileBounds;
			}
			else if(mapType == MapType.RECTANGLE_MAP_RECTANGLE_TILE)
			{
				_tileBounds.x = 0;
				_tileBounds.y = 0;
				_tileBounds.width = tileSize * cols;
				_tileBounds.height = tileSize * rows;
				
				return _tileBounds;
			}
			else
			{
				// Do nothing
			}
			
			return null;
		}
		
		/**
		 * @private
		 * 获得砖块的坐标偏移
		 * 
		 * @param mapType
		 * @param rows
		 * @param cols
		 * @param tileSize
		 * 
		 * @return 
		 */
		public static function getTileOffsetX(mapType:MapType, rows:uint, cols:uint, tileSize:uint):Number
		{
			if(mapType == MapType.DIAMOND_MAP_DIAMOND_TILE)
			{
				return Math.ceil(rows * .5) * tileSize * 2 - tileSize - (rows % 2 == 0 ? 0 : tileSize);
			}
			else if(mapType == MapType.RECTANGLE_MAP_DIAMOND_TILE)
			{
				return 0;
			}
			else if(mapType == MapType.RECTANGLE_MAP_HEXAGON_TILE)
			{
				return 0;
			}
			else if(mapType == MapType.RECTANGLE_MAP_RECTANGLE_TILE)
			{
				return 0;
			}
			else
			{
				// Do nothing
			}
			
			return 0;
		}
		
		/**
		 * 获得砖块形成的矩形区域
		 * 
		 * @return
		 */
		public function getTilesBounds():Rectangle
		{
			return _tiles.getTilesBounds();
		}
		
		/**
		 * 将屏幕坐标转换成砖块屏幕坐标的方法。所谓砖块的屏幕坐标是指，指定点所在砖块的左上角屏幕坐标
		 * 
		 * @param	x
		 * @param	y
		 * 
		 * @return	返的对象仅供返回之后立即读取内部的值，如果打算持有返回的对象，请调用返回对象的clone方法。
		 */
		public function getTileCoordinateByScreenCoordinate(x:Number, y:Number):Point
		{
			var rowCol:Point = getRowColByScreenCoordinate(x, y);
			
			return getScreenCoordinateByRowCol(rowCol.y, rowCol.x);
		}
		
		/**
		 * 将行列坐标转换为屏幕坐标
		 * 
		 * @param	row
		 * @param	col
		 * 
		 * @return	返的对象仅供返回之后立即读取内部的值，如果打算持有返回的对象，请调用返回对象的clone方法。
		 */
		public function getScreenCoordinateByRowCol(row:int, col:int):Point
		{
			return _tiles.getScreenCoordinateByRowCol(row, col, _mapInitParams);
		}
		
		/**
		 * 将屏幕坐标转换为行列坐标
		 * 
		 * @param	x
		 * @param	y
		 * 
		 * @return	返的对象仅供返回之后立即读取内部的值，如果打算持有返回的对象，请调用返回对象的clone方法。
		 */
		public function getRowColByScreenCoordinate(x:Number, y:Number):Point
		{
			return _tiles.getRowColByScreenCoordinate(x, y, _mapInitParams);
		}
		
		/**
		 * 获得一块砖块的中心点相对于那块砖块左上角的偏移量
		 * 
		 * @return
		 */
		public function getTileCenterOffset():Point
		{
			return _tiles.getTileCenterOffset(_mapInitParams);
		}
		
		/**
		 * 在指定的行列画砖块。
		 * 在画砖块的方法中copyPixel方法要比draw运行的快
		 * 
		 * @param	tile
		 * @param	x	指定的列
		 * @param	y	指定的行
		 * @param	width	砖块的宽度，如果没有指定则将使用tile的width属性
		 * @param	height	砖块的高度，如果没有指定则将使用tile的height属性
		 * 
		 * @return
		 */
		public function drawTileByRowCol(tile:IBitmapDrawable, x:int, y:int, width:Number = NaN, height:Number = NaN):IBitmapDrawable
		{
			return _tiles.drawTileByRowCol(tile, x, y, width, height, _mapInitParams);
		}
		
		/**
		 * 在指定的屏幕坐标位置画砖块。
		 * 在画砖块的方法中copyPixel方法要比draw运行的快
		 * 
		 * @param	tile
		 * @param	x	屏幕x坐标
		 * @param	y	屏幕y坐标
		 * @param	width
		 * @param	height
		 * 
		 * @return
		 */
		public function drawTileByScreenCoordinate(tile:IBitmapDrawable, x:Number, y:Number, width:Number = NaN, height:Number = NaN):IBitmapDrawable
		{
			var rowCol:Point = getRowColByScreenCoordinate(x, y);
			
			return drawTileByRowCol(tile, rowCol.x, rowCol.y, width, height);
		}
		
		/**
		 * 向砖块画布上画一个对象。指定的对象必须是左上角对其注册点。
		 * 在画砖块的方法中copyPixel方法要比draw运行的快
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
			return _tiles.drawToTileCanvas(target, x, y, width, height);
		}
		
		/**
		 * 在指定的行列画砖块。
		 * 在画砖块的方法中copyPixel方法要比draw运行的快
		 * 
		 * @param	tile
		 * @param	bmpdRect	指定的位图的区域
		 * @param	x	指定的列
		 * @param	y	指定的行
		 * 
		 * @return
		 */
		public function copyTilePixelsByRowCol(tile:BitmapData, tileRect:Rectangle = null, x:int = 0, y:int = 0):BitmapData
		{
			return _tiles.copyTilePixelsByRowCol(tile, tileRect, x, y, _mapInitParams);
		}
		
		/**
		 * 在指定的屏幕坐标位置话砖块。
		 * 在画砖块的方法中copyPixel方法要比draw运行的快
		 * 
		 * @param	tile
		 * @param	bmpdRect	指定的位图的区域
		 * @param	x	屏幕x坐标
		 * @param	y	屏幕y坐标
		 * 
		 * @return
		 */
		public function copyTilePixelsByScreenCoordinate(tile:BitmapData, tileRect:Rectangle = null, x:Number = 0, y:Number = 0):BitmapData
		{
			var rowCol:Point = getRowColByScreenCoordinate(x, y);
			
			return copyTilePixelsByRowCol(tile, tileRect, rowCol.x, rowCol.y);
		}
		
		/**
		 * 向砖块画布上画一个位图。
		 * 在画砖块的方法中copyPixel方法要比draw运行的快
		 * 
		 * @param	target	指定的位图
		 * @param	bmpdRect	指定的位图的区域
		 * @param	x	画在画布上的x坐标
		 * @param	y	画在画布上的y坐标
		 * 
		 * @return	返回成功画到画布上的位图
		 */
		public function copyPixelsToTileCanvas(bmpd:BitmapData, bmpdRect:Rectangle = null, x:Number = 0, y:Number = 0):BitmapData
		{
			return _tiles.copyPixelsToTileCanvas(bmpd, bmpdRect, x, y);
		}
		
		/**
		 * 清除画在砖块画布上的图像
		 */
		public function clearTileCanvas():void
		{
			_tiles.clearTileCanvas();
		}
		
		/**
		 * 获得所有砖块的数据。仅供遍历使用
		 * 
		 * @return 
		 */
		public function getTilesData():Vector.<TileDataBase>
		{
			return _tiles.getTilesData();
		}
		
		/**
		 * 获得所有砖块的数据。仅供遍历使用
		 * 
		 * @return 集合中的每一个元素的类型是TileDataBase
		 */
		public function getTilesDataMap():Dictionary
		{
			return _tiles.getTilesDataMap();
		}
		
		/**
		 * 显示辅助砖块。
		 * 
		 * @param	canvas	如果没有指定画布，则在默认的画布上画，且画出所有的砖块。
		 * 如果指定了一块画布，则在指定的画布上画，并且只画出指定的行数和列数。	
		 * @param	rows
		 * @param	cols
		 * 
		 * @return 是否成功显示
		 */
		public function showAssistantTiles(canvas:Graphics = null, rows:uint = 3, cols:uint = 3):void
		{
			_tiles.showAssistantTiles(
				canvas == null ? _mapInitParams.getAssistantTileCanvas() : canvas, 
				canvas == null ? _mapInitParams.rows : rows, 
				canvas == null ? _mapInitParams.cols : cols, 
				_mapInitParams);
		}
		
		/**
		 * 隐藏辅助砖块
		 * 
		 * @return 是否成功隐藏
		 */
		public function hideAssistantTiles():Boolean
		{
			return _tiles.hideAssistantTiles(_mapInitParams.getAssistantTileCanvas());
		}
		
		/**
		 * 通过id获得指定的砖块数据
		 * 
		 * @param	id
		 * 
		 * @return	没有找到指定id的砖块数据返回null
		 */
		public function getTileDataByID(id:Object):TileDataBase
		{
			return _tiles.getTileDataByID(id);
		}
		
		/**
		 * 通过行列值获得指定砖块数据
		 * 
		 * @param	row
		 * @param	col
		 * 
		 * @return	如果没有找到返回null
		 */
		public function getTileDataByRowCol(row:int, col:int):TileDataBase
		{
			return _tiles.getTileDataByRowCol(row, col, _mapInitParams.rows, _mapInitParams.cols)
		}
		
		/**
		 * 通过行列值获得指定砖块在屏幕上的坐标
		 * 
		 * @param	row
		 * @param	col
		 * 
		 * @return	返回砖块的屏幕坐标，如果没有找到返回null
		 */
		public function getTileScreenCoordinateByRowCol(row:int, col:int):Point
		{
			return _tiles.getTileScreenCoordinateByRowCol(row, col, _mapInitParams.rows, _mapInitParams.cols);
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
			return _tiles.getTileScreenCoordinateByID(id);
		}
		
		// 初始化所有砖块
		private function initializeTiles():void
		{
			var mapType:MapType = _mapInitParams.getMapType();
			_tiles = mapType == MapType.RECTANGLE_MAP_RECTANGLE_TILE ? new RectangleMapRectangeTiles(_mapInitParams) : 
				mapType == MapType.RECTANGLE_MAP_DIAMOND_TILE ? new RectangleMapDiamondTiles(_mapInitParams) : 
				mapType == MapType.DIAMOND_MAP_DIAMOND_TILE ? new DiamondMapDiamondTiles(_mapInitParams) : 
				mapType == MapType.RECTANGLE_MAP_HEXAGON_TILE ? new RectangleMapHexagonTiles(_mapInitParams) : null;
		}
		
		private function destroyTiles():void
		{
			if (_tiles != null)
			{
				_tiles.destroy();
				_tiles = null;
			}
		}
		
		//-----------------------------------------------------------------------------------------------------------
		// MapInitParams
		//-----------------------------------------------------------------------------------------------------------
		
		private var _mapInitParams:MapInitializeParameters = null;
		
		/**
		 * 获得地图初始化对象
		 * 
		 * @return
		 */
		public function getMapInitializeParameters():MapInitializeParameters
		{
			return _mapInitParams;
		}
		
		private function destroyMapInitParams():void
		{
			if (_mapInitParams)
			{
				_mapInitParams = null;
			}
		}
		
		//-----------------------------------------------------------------------------------------------------------
		// 实现 IDestroy 接口
		//-----------------------------------------------------------------------------------------------------------
		
		/**
		 * @inheritDoc
		 */
		public function destroy():void
		{
			destroyTiles();
			destroyElements();
			destroyUnwalkableMarks();
			destroyMapInitParams();
		}
	}

}