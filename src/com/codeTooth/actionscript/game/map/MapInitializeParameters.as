package com.codeTooth.actionscript.game.map 
{
	import com.codeTooth.actionscript.algorithm.pathSearching.base.SearchingDirection;
	import com.codeTooth.actionscript.lang.exceptions.IllegalParameterException;
	import com.codeTooth.actionscript.lang.exceptions.NullPointerException;
	import com.codeTooth.actionscript.lang.utils.destroy.IDestroy;
	import com.codeTooth.actionscript.lang.utils.geom.Mathematic;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.Graphics;
	
	/**
	 * 初始化地图参数
	 */
	public class MapInitializeParameters implements IDestroy
	{
		// 砖块行数
		private var _rows:uint = 0;
		
		// 砖块列数
		private var _cols:uint = 0;
		
		// 地图的类型
		private var _mapType:MapType = null;
		
		// x轴旋转的角度
		private var _xAxisRadian:Number = 0;
		
		// y轴旋转的角度
		private var _yAxisRadian:Number = 0;
		
		// 创建砖块
		private var _createTile:Function = null;
		
		// 创建砖块数据
		private var _createTileData:Function = null;
		
		// 砖块的尺寸
		private var _tileSize:uint = 0;
		
		// 显示辅助线的画布
		private var _asstLineCanvas:Graphics = null;
		
		// 辅助线颜色
		private var _asstLineColor:uint = 0x000000;
		
		// 辅助线宽
		private var _asstLineThickness:Number = 1;
		
		// 辅助线透明度
		private var _asstLineAlpha:Number = 1;
		
		// 显示砖块的容器
		private var _tileContainer:DisplayObjectContainer = null;
		
		// 显示元素的容器
		private var _elementContainer:DisplayObjectContainer = null;
		
		// 移动地图元素时，地图元素左上角是否和砖块中心点对齐
		private var _elementTileCenterAlign:Boolean = false;
		
		// 不可行走区域标记容器
		private var _unwalkableMarkContainer:DisplayObjectContainer = null;
		
		// 不可行走标记颜色
		private var _unwalkableMarkColor:uint = 0x000000;
		
		// 寻路方向
		private var _searchingDirection:SearchingDirection = null;
		
		// 砖块画布透明
		private var _tileCanvasTransparent:Boolean = false;
		
		// 砖块画布颜色
		private var _tileCanvasColor:uint = 0x00000000;
		
		// 创建不可行走标记
		private var _createUnwalkableMark:Function = null;
		
		/**
		 * 构造函数
		 * 
		 * @param	rows 砖块行数
		 * @param	cols 砖块列数
		 * @param	mapType 地图的类型。
		 * @param	tileSize 砖块的尺寸。菱形砖块指的是长内径一半的尺寸。矩形砖块指的是边长。六边形砖块指的是外接圆的半径。
		 * @param	tileContainer 显示砖块的容器
		 * @param	elementContainer 显示元素的容器
		 * 
		 * @throws	com.codeTooth.actionscript.lang.exceptions.NullPointerException 
		 * 禁止的null入参
		 * 
		 * @throws	com.codeTooth.actionscript.lang.exceptions.IllegalParameterException 
		 * 非法的参数
		 */
		public function MapInitializeParameters(rows:uint, cols:uint, 
			mapType:MapType, tileSize:uint,  
			tileContainer:DisplayObjectContainer, elementContainer:DisplayObjectContainer)
		{
			if (mapType == null)
			{
				throw new NullPointerException("Null mapType");
			}
			if (tileContainer == null)
			{
				throw new NullPointerException("Null tileContainer");
			}
			if (elementContainer == null)
			{
				throw new NullPointerException("Null elementContainer");
			}
			if (rows == 0)
			{
				throw new IllegalParameterException("Illegal rows \"" + rows + "\"");
			}
			if (cols == 0)
			{
				throw new IllegalParameterException("Illegal cols \"" + cols + "\"");
			}
			if(tileSize == 0)
			{
				throw new IllegalParameterException("Illegal tileSize \"" + tileSize + "\"");
			}
			
			_rows = rows;
			_cols = cols;
			_mapType = mapType;
			_tileSize = tileSize;
			
			_tileContainer = tileContainer;
			_elementContainer = elementContainer;
			
			_searchingDirection = SearchingDirection.EIGHT;
			
			// 菱形地图菱形砖块
			if (mapType == MapType.DIAMOND_MAP_DIAMOND_TILE)
			{
				_xAxisRadian = -Mathematic.RADIAN_30;
				_yAxisRadian = Mathematic.RADIAN_45;
			}
		}
		
		/**
		 * 砖块行数
		 */
		public function get rows():int
		{
			return _rows;
		}
		
		/**
		 * 砖块列数
		 */
		public function get cols():int
		{
			return _cols;
		}
		
		/**
		 * x轴旋转的角度，只有在CUSTOM_MAP_DIAMOND_TILE地图类型时才有用
		 */
		public function get xAxisRadian():Number
		{
			return _xAxisRadian;
		}
		
		/**
		 * y轴旋转的角度，只有在CUSTOM_MAP_DIAMOND_TILE地图类型时才有用
		 */
		public function get yAxisRadian():Number
		{
			return _yAxisRadian;
		}
		
		/**
		 * 砖块的尺寸。菱形砖块指的是长内径一半的尺寸。矩形砖块指的是边长。六边形砖块指的是外接圆的直径。
		 */
		public function get tileSize():uint
		{
			return _tileSize;
		}
		
		/**
		 * 创建砖块。如果指定null，则不会显示砖块，只创建砖块数据。
		 * 函数原型func(mapInitParams:MapInitializeParameters, row:uint, col:uint):BitmapData
		 *
		 * @param func
		 */
		public function setCreateTile(func:Function):void
		{
			_createTile = func;
		}
		
		/**
		 * 创建砖块
		 * 
		 * @return
		 */
		public function getCreateTile():Function
		{
			return _createTile;
		}
		
		/**
		 * 创建砖块数据。如果指定null，将创建默认类型的砖块数据。
		 * 函数原型func(mapInitParams:MapInitializeParameters, row:uint, col:uint):TileDataBase
		 * 
		 * @param func
		 */
		public function setCreateTileData(func:Function):void
		{
			_createTileData = func;
		}
		
		/**
		 * 创建砖块数据
		 * 
		 * @return
		 */
		public function getCreateTileData():Function
		{
			return _createTileData;
		}
		
		/**
		 * 设定显示辅助砖块的画布
		 * 
		 * @param canvas
		 */
		public function setAssistantTileCanvas(canvas:Graphics):void
		{
			_asstLineCanvas = canvas;
		}
		
		/**
		 * 获得显示辅助砖块的画布
		 * 
		 * @return
		 */
		public function getAssistantTileCanvas():Graphics
		{
			return _asstLineCanvas;
		}
		
		/**
		 * 辅助线颜色
		 */
		public function get assistantLineColor():uint
		{
			return _asstLineColor;
		}
		
		/**
		 * @private
		 */
		public function set assistantLineColor(color:uint):void
		{
			_asstLineColor = color;
		}
		
		/**
		 * 辅助线宽
		 */
		public function get assistantLineThickness():Number
		{
			return _asstLineThickness;
		}
		
		/**
		 * @private
		 */
		public function set assistantLineThickness(value:Number):void
		{
			_asstLineThickness = value;
		}
		
		/**
		 * 辅助线透明度
		 */
		public function get assistantLineAlpha():Number
		{
			return _asstLineAlpha;
		}
		
		/**
		 * @private
		 */
		public function set assistantLineAlpha(value:Number):void
		{
			_asstLineAlpha = value;
		}
		
		/**
		 * @private
		 */
		public function set elementTileCenterAlign(bool:Boolean):void
		{
			_elementTileCenterAlign = bool;
		}
		
		/**
		 * 移动地图元素时，地图元素左上角是否和砖块中心点对齐
		 */
		public function get elementTileCenterAlign():Boolean
		{
			return _elementTileCenterAlign;
		}
		
		/**
		 * 显示砖块的容器
		 * 
		 * @return
		 */
		public function getTileContainer():DisplayObjectContainer
		{
			return _tileContainer;
		}
		
		/**
		 * 显示元素的容器
		 * 
		 * @return
		 */
		public function getElementContainer():DisplayObjectContainer
		{
			return _elementContainer;
		}
		
		/**
		 * 设定显示不可行走区域标记的容器
		 * 
		 * @param container
		 */
		public function setUnwalkableMarkContainer(container:DisplayObjectContainer):void
		{
			_unwalkableMarkContainer = container;
		}
		
		/**
		 * 获得显示不可行走区域标记的容器
		 * 
		 * @return
		 */
		public function getUnwalkableMarkContainer():DisplayObjectContainer
		{
			return _unwalkableMarkContainer;
		}
		
		/**
		 * 不可行走标记颜色
		 */
		public function get unwalkableMarkColor():uint
		{
			return _unwalkableMarkColor;
		}
		
		/**
		 * @private
		 */
		public function set unwalkableMarkColor(color:uint):void
		{
			_unwalkableMarkColor = color;
		}
		
		/**
		 * 地图类型
		 * 
		 * @return
		 */
		public function getMapType():MapType
		{
			return _mapType;
		}
		
		public function setSearchingDirection(searchingDirection:SearchingDirection):void
		{
			_searchingDirection = searchingDirection;
		}
		
		/**
		 * 获得寻路方向
		 * 
		 * @return
		 */
		public function getSeachingDirection():SearchingDirection
		{
			return _searchingDirection;
		}
		
		/**
		 * @private
		 */
		public function get tileCanvasTransparent():Boolean
		{
			return _tileCanvasTransparent;
		}
		
		/**
		 * 砖块画布透明
		 */
		public function set tileCanvasTransparent(value:Boolean):void
		{
			_tileCanvasTransparent = value;
		}
		
		/**
		 * @private
		 */
		public function get tileCanvasColor():uint
		{
			return _tileCanvasColor;
		}
		
		/**
		 * 砖块画布颜色
		 */
		public function set tileCanvasColor(value:uint):void
		{
			_tileCanvasColor = value;
		}
		
		/**
		 * 创建不可行走标记
		 * 
		 * @return 
		 */
		public function getCreateUnwalkableMark():Function
		{
			return _createUnwalkableMark;
		}
		
		/**
		 * 创建不可行走标记。
		 * 函数原型func(mapInitParams:MapInitializeParameters):DisplayObject
		 * 
		 * @param value
		 */
		public function setCreateUnwalkableMark(func:Function):void
		{
			_createUnwalkableMark = func;
		}
		
		/**
		 * @inheritDoc
		 */
		public function destroy():void
		{
			_mapType = null;
			_asstLineCanvas = null;
			_tileContainer = null;
			_createTile = null;
			_createTileData = null;
			_elementContainer = null;
			_searchingDirection = null;
			_unwalkableMarkContainer = null;
		}

	}

}