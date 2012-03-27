package com.codeTooth.actionscript.game.map.tile 
{
	import com.codeTooth.actionscript.display.GraphicsPen;
	import com.codeTooth.actionscript.game.map.MapInitializeParameters;
	import com.codeTooth.actionscript.lang.exceptions.IllegalParameterException;
	import com.codeTooth.actionscript.lang.exceptions.NoSuchObjectException;
	import com.codeTooth.actionscript.lang.exceptions.NullPointerException;
	import com.codeTooth.actionscript.lang.utils.Assert;
	import com.codeTooth.actionscript.lang.utils.destroy.DestroyUtil;
	import com.codeTooth.actionscript.lang.utils.destroy.IDestroy;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Shape;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	
	/**
	 * 不可行走标记点
	 */
	public class UnwalkableMarks implements IDestroy
	{
		// 所有的标记点对象
		private var _marks:Dictionary/*key TileDataBase's id, value Shape*/ = null;
		
		// 当前是否显示标记点
		private var _shown:Boolean = false;
		
		public function UnwalkableMarks() 
		{
			_marks = new Dictionary();
		}
		
		/**
		 * 显示一个标记点
		 * 
		 * @param	row
		 * @param	col
		 * @param	mapInitParams
		 * @param	tiles
		 * 
		 * @return 是否成功显示。
		 * 如果没有调用show方法，或，
		 * 在调用了hide方法之后调用了此方法，或，
		 * 初始化地图时没有指定不可行走标记容器，或，
		 * 行列超出了地图的范围，或，
		 * 在指定的行列已经有一个了，则返回false
		 * 
		 * @throws	com.codeTooth.actionscript.lang.exceptions.IllegalParameterException 
		 * 指定的行列超出了最大值 
		 * @throws	com.codeTooth.actionscript.lang.exceptions.NoSuchObjectException 
		 * 不存在显示不可行走标记的容器
		 */
		public function showOne(row:uint, col:uint, mapInitParams:MapInitializeParameters, tiles:TilesBase):void
		{
			if (!_shown)
			{
				return;
			}
			
			Assert.checkNull(mapInitParams, tiles);
			
			if(row >= mapInitParams.rows)
			{
				throw new IllegalParameterException("Row index \"" + row + "\" cannot >= rows \"" + mapInitParams.rows + "\"");
			}
			if(col >= mapInitParams.cols)
			{
				throw new IllegalParameterException("Col index \"" + col + "\" cannot >= cols \"" + mapInitParams.cols + "\"");
			}
			
			// 获得指定行列位置对应的地图砖块数据
			var tileData:TileDataBase = tiles.getTileDataByRowCol(row, col, mapInitParams.rows, mapInitParams.cols);
			Assert.checkNull(tileData);
			
			// 已经有了
			if (_marks[tileData.getUniqueID()] != undefined)
			{
				return;
			}
			
			var container:DisplayObjectContainer = mapInitParams.getUnwalkableMarkContainer();
			if (container == null)
			{
				throw new NoSuchObjectException("Has not the specified unwalkable container");
			}
			
			// 创建
			var mark:DisplayObject = createMark(mapInitParams);
			// 定位
			positionMark(mark, row, col, mapInitParams, tiles);
			// 显示
			container.addChild(mark);
			_marks[tileData.getUniqueID()] = mark;
		}
		
		/**
		 * 移除一个显示的标记
		 * 
		 * @param	row
		 * @param	col
		 * @param	mapInitParams
		 * @param	tiles
		 * 
		 * @return	返回是否成功移除。
		 * 如果指定的行列超出范围，或，
		 * 在指定的行列没有标记点，或，
		 * 初始化地图时没有指定不可行走标记容器，则返回false
		 * 
		 * @throws	com.codeTooth.actionscript.lang.exceptions.NullPointerException 
		 * 指定的mapInitParams或tiles是null
		 * @throws	com.codeTooth.actionscript.lang.exceptions.NoSuchObjectException 
		 * 在指定的行列不存在地图砖块数据
		 */
		public function removeOne(row:int, col:int, mapInitParams:MapInitializeParameters, tiles:TilesBase):Boolean
		{
			if (mapInitParams == null)
			{
				throw new NullPointerException("Null mapInitParams");
				return false;
			}
			if (tiles == null)
			{
				throw new NullPointerException("Null tiles");
				return false;
			}
			
			// 指定的行列超出范围
			if (row < 0 || row >= mapInitParams.rows || col < 0 || col >= mapInitParams.cols)
			{
				return false;
			}
			
			var tileData:TileDataBase = tiles.getTileDataByRowCol(row, col, mapInitParams.rows, mapInitParams.cols);
			if (tileData == null)
			{
				throw new NoSuchObjectException("Has not the tileData, row \"" + row + "\", col \"" + col + "\"");
				return false;
			}
			
			// 在指定的行列不存在标记点
			if (_marks[tileData.getUniqueID()] == undefined)
			{
				return false;
			}
			
			var container:DisplayObjectContainer = mapInitParams.getUnwalkableMarkContainer();
			if (container == null)
			{
				return false;
			}
			
			// 删除标记
			var mark:Shape = _marks[tileData.getUniqueID()];
			mark.graphics.clear();
			if (mark.parent == container)
			{
				container.removeChild(mark);
			}
			delete _marks[tileData.getUniqueID()];
			
			return true;
		}
		
		/**
		 * 显示所有的标记点
		 * 
		 * @param	mapInitParams
		 * @param	tiles
		 * 
		 * @throws com.codeTooth.actionscript.lang.exceptions.NoSuchObjectException 
		 * 没有指定显示不可行走标记的容器
		 */
		public function showAll(mapInitParams:MapInitializeParameters, tiles:TilesBase):void
		{
			Assert.checkNull(mapInitParams, tiles);
			
			var container:DisplayObjectContainer = mapInitParams.getUnwalkableMarkContainer();
			if (container == null)
			{
				throw new NoSuchObjectException("Has not the specified unwalkable container");
			}
			
			var tilesData:Vector.<TileDataBase> = tiles.getTilesData();
			Assert.checkNull(tileData);
			
			var mark:DisplayObject = null;
			var color:uint = mapInitParams.unwalkableMarkColor;
			_shown = true;
			// 遍历
			for each(var tileData:TileDataBase in tilesData)
			{
				if (tileData.unwalkable)
				{
					// 还没有创建过，创建一个新的
					if (_marks[tileData.getUniqueID()] == undefined)
					{
						mark = createMark(mapInitParams);
						_marks[tileData.getUniqueID()] = mark;
					}
					// 已经创建过了，直接获取
					else
					{
						mark = _marks[tileData.getUniqueID()];
					}
					// 定位
					positionMark(mark, tileData.y, tileData.x, mapInitParams, tiles);
					// 显示
					if(mark.parent != container)
					{
						container.addChild(mark);
					}
				}
			}
		}
		
		/**
		 * 隐藏所有的标记点
		 * 
		 * @param	mapInitParams
		 * 
		 * @throws com.codeTooth.actionscript.lang.exceptions.NoSuchObjectException 
		 * 没有指定显示不可行走标记的容器
		 */
		public function hideAll(mapInitParams:MapInitializeParameters):void
		{
			Assert.checkNull(mapInitParams);
			
			var container:DisplayObjectContainer = mapInitParams.getUnwalkableMarkContainer();
			if (container == null)
			{
				throw new NoSuchObjectException("Has not the specified unwalkable container");
			}
			
			_shown = false;
			// 遍历
			for each(var mark:Shape in _marks)
			{
				if (mark.parent == container)
				{
					// 移除显示
					// 这里并不delete数据，这样再次显示的时候就不用再创建对象了
					// 如果想彻底移除所有的标记点，调用removeAll
					container.removeChild(mark);
				}
			}
		}
		
		/**
		 * 移除所有的标记点
		 * 
		 * @param	mapInitParams
		 * 
		 * @return	是否成功移除标记点
		 * 
		 * @throws	com.codeTooth.actionscript.lang.exceptions.NullPointerException 
		 * 指定的mapInitParams是null
		 */
		public function removeAll(mapInitParams:MapInitializeParameters):Boolean
		{
			if (mapInitParams == null)
			{
				throw new NullPointerException("Null mapInitParams");
				return false;
			}
			
			var container:DisplayObjectContainer = mapInitParams.getUnwalkableMarkContainer();
			if (container == null)
			{
				return false;
			}
			
			for each(var mark:Shape in _marks)
			{
				if (mark.parent == container)
				{
					mark.graphics.clear();
					container.removeChild(mark);
				}
			}
			DestroyUtil.breakMap(_marks);
			
			return true;
		}
		
		private function createMark(mapInitParams:MapInitializeParameters):DisplayObject
		{
			var createUnwalkableMark:Function = mapInitParams.getCreateUnwalkableMark();
			if(createUnwalkableMark == null)
			{
				// 创建
				var mark:Shape = new Shape();
				// 画标记
				mark.graphics.beginFill(mapInitParams.unwalkableMarkColor);
				GraphicsPen.drawCross(mark.graphics, 20, 10);
				mark.graphics.endFill();
				
				return mark;
			}
			else
			{
				return createUnwalkableMark(mapInitParams);
			}
			
		}
		
		private function positionMark(mark:DisplayObject, row:uint, col:uint, mapInitParams:MapInitializeParameters, tiles:TilesBase):void
		{
			// 定位
			var offsetX:Number = 0;
			var offsetY:Number = 0;
			if(mapInitParams.elementTileCenterAlign)
			{
				var offsetPoint:Point = tiles.getTileCenterOffset(mapInitParams);
				offsetX = offsetPoint.x;
				offsetY = offsetPoint.y;
			}
			var point:Point = tiles.getScreenCoordinateByRowCol(row, col, mapInitParams);
			mark.x = point.x + offsetX;
			mark.y = point.y + offsetY;
		}
		
		//------------------------------------------------------------------------------------------------------------------------------------------------------
		// 实现 IDestroy 接口
		//------------------------------------------------------------------------------------------------------------------------------------------------------
		
		public function destroy():void
		{
			if (_marks != null)
			{
				for each(var mark:Shape in _marks)
				{
					if (mark.parent != null)
					{
						
						mark.parent.removeChild(mark);
					}
				}
				
				DestroyUtil.breakMap(_marks);
				_marks = null;
			}
		}
	}

}