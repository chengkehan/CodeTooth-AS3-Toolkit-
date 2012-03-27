package com.codeTooth.actionscript.game.map.element 
{
	import com.codeTooth.actionscript.core.codeTooth_internal;
	import com.codeTooth.actionscript.game.map.MapInitializeParameters;
	import com.codeTooth.actionscript.game.map.tile.TilesBase;
	import com.codeTooth.actionscript.lang.exceptions.IllegalOperationException;
	import com.codeTooth.actionscript.lang.exceptions.IllegalParameterException;
	import com.codeTooth.actionscript.lang.exceptions.NoSuchObjectException;
	import com.codeTooth.actionscript.lang.utils.Assert;
	import com.codeTooth.actionscript.lang.utils.destroy.DestroyUtil;
	import com.codeTooth.actionscript.lang.utils.destroy.IDestroy;
	import com.codeTooth.actionscript.lang.utils.geom.Vector2D;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	/**
	 * 地图元素
	 */
	public class Elements implements IDestroy
	{
		use namespace codeTooth_internal;
		
		public function Elements() 
		{
			_elements = new Dictionary();
			_elementsData = new Dictionary();
			_elementInDisplayList = new Array();
			_element1Bounds = new Rectangle();
			_element2Bounds = new Rectangle();
			_element1Slope = new Vector2D();
			_element2Slope1 = new Vector2D();
			_element2Slope2 = new Vector2D();
		}
		
		//-------------------------------------------------------------------------------------------------------------
		// 深度排序
		//-------------------------------------------------------------------------------------------------------------
		
		// 当前在显示列表的所有元素
		private var _elementInDisplayList:Array = null;
		
		private var _element1Bounds:Rectangle = null;
		
		private var _element2Bounds:Rectangle = null;
		
		private var _element1Slope:Vector2D = null;
		
		private var _element2Slope1:Vector2D = null;
		
		private var _element2Slope2:Vector2D = null;
		
		/**
		 * 深度排序
		 * 
		 * @param	mapInitParams
		 */
		public function sortDepth(mapInitParams:MapInitializeParameters):void
		{
			Assert.checkNull(mapInitParams);
			
			_elementInDisplayList.length = 0;
			for each(var element:DisplayObject in _elements)
			{
				if (element.parent != null)
				{
					_elementInDisplayList.push(element);
				}
			}
			// 原始的方案
			//_elementInDisplayList.sortOn("y", Array.NUMERIC);
			// 改进的方案
			_elementInDisplayList.sort(copmpareElementsDepth);
			
			var container:DisplayObjectContainer = mapInitParams.getElementContainer();
			var count:int = 0;
			for each(var iElement:* in _elementInDisplayList)
			{
				if (iElement.indexInDisplayList != count)
				{
					container.setChildIndex(iElement, count);
					iElement.indexInDisplayList = count;
				}
				count++;
			}
		}
		
		private function copmpareElementsDepth(element1:IElement, element2:IElement):int
		{	
			_element1Bounds.x = element1.boundsX;
			_element1Bounds.y = element1.boundsY;
			_element1Bounds.width = element1.boundsWidth;
			_element1Bounds.height = element1.boundsHeight;
			
			_element2Bounds.x = element2.boundsX;
			_element2Bounds.y = element2.boundsY;
			_element2Bounds.width = element2.boundsWidth;
			_element2Bounds.height = element2.boundsHeight;
			
			var element1Data:ElementDataBase = _elementsData[element1.getDataUniqueID()];
			var element2Data:ElementDataBase = _elementsData[element2.getDataUniqueID()];
			
			if (_element1Bounds.intersects(_element2Bounds))
			{
				_element1Slope.x = element1Data.rightX - element1Data.leftX;
				_element1Slope.y = element1Data.rightY - element1Data.leftY;
				
				var element2RightX:Number = element2.x + element2Data.rightX - element1.x;
				var element2RightY:Number = element2.y + element2Data.rightY - element1.y;
				var element2LeftX:Number = element2.x + element2Data.leftX - element1.x;
				var element2LeftY:Number = element2.y + element2Data.leftY - element1.y;
				
				_element2Slope1.x = element2RightX - element1Data.leftX;
				_element2Slope1.y = element2RightY - element1Data.leftY;
				_element2Slope2.x = element2LeftX - element1Data.leftX;
				_element2Slope2.y = element2LeftY - element1Data.leftY;
				
				//SpriteElement(element1).g.graphics.clear();
				//SpriteElement(element2).g.graphics.clear();
				//_element1Slope.draw(SpriteElement(element1).g.graphics, 0xFF0000, element1Data.leftX, element1Data.leftY);
				//_element2Slope1.draw(SpriteElement(element1).g.graphics, 0x00FF00, element1Data.leftX, element1Data.leftY);
				//_element2Slope2.draw(SpriteElement(element1).g.graphics, 0x0000FF, element1Data.leftX, element1Data.leftY);
				
				//SpriteElement(element1).g.graphics.beginFill(0x000000);
				//SpriteElement(element2).g.graphics.beginFill(0xFFFFFF);
				//SpriteElement(element1).g.graphics.drawCircle(element1Data.leftX, element1Data.leftY, 10);
				//SpriteElement(element1).g.graphics.drawCircle(element1Data.rightX, element1Data.rightY, 10);
				//SpriteElement(element2).g.graphics.drawCircle(element2Data.rightX, element2Data.rightY, 20);
				//SpriteElement(element2).g.graphics.drawCircle(element2Data.leftX, element2Data.leftY, 20);
				//SpriteElement(element1).g.graphics.drawCircle(element2LeftX, element2LeftY, 30);
				//SpriteElement(element1).g.graphics.drawCircle(element2RightX, element2RightY, 30);
				
				//trace(_element1Slope.signQuickly(_element2Slope1) < 0, _element1Slope.signQuickly(_element2Slope2) < 0);
				var result1:Boolean = _element1Slope.signQuickly(_element2Slope1) < 0;
				var result2:Boolean = _element1Slope.signQuickly(_element2Slope2) < 0;
				if (result1 == result2)
				{
					return result1 || result2 ? 1 : -1;
				}
				else
				{
					//trace("way2");
					_element1Slope.x = element2Data.rightX - element2Data.leftX;
					_element1Slope.y = element2Data.rightY - element2Data.leftY;
					
					element2RightX = element1.x + element1Data.rightX - element2.x;
					element2RightY = element1.y + element1Data.rightY - element2.y;
					element2LeftX = element1.x + element1Data.leftX - element2.x;
					element2LeftY = element1.y + element1Data.leftY - element2.y;
					
					_element2Slope1.x = element2RightX - element2Data.leftX;
					_element2Slope1.y = element2RightY - element2Data.leftY;
					_element2Slope2.x = element2LeftX - element2Data.leftX;
					_element2Slope2.y = element2LeftY - element2Data.leftY;
					
					return _element1Slope.signQuickly(_element2Slope1) < 0 || _element1Slope.signQuickly(_element2Slope2) < 0 ? -1 : 1;
				}
			}
			else
			{
				if (element1.y + element1Data.minAreaPointY < element2.y + element2Data.minAreaPointY)
				{
					return -1;
				}
				else
				{
					return 1;
				}
			}
		}
		
		private function destroyGridCells():void
		{
			DestroyUtil.breakVector(_elementInDisplayList);
			_elementInDisplayList = null;
			_element1Bounds = null;
			_element2Bounds = null;
			_element1Slope = null;
			_element2Slope2 = null;
			_element2Slope1 = null;
		}
		
		//-------------------------------------------------------------------------------------------------------------
		// Elements
		//-------------------------------------------------------------------------------------------------------------
		
		// 存储地图元素
		private var _elements:Dictionary/*key:id, value:IElement*/ = null;
		
		// 存储地图元素数据
		private var _elementsData:Dictionary/*key:id, value:ElementDataBase*/ = null;
		
		/**
		 * 更新所有地图元素的斜率，地图元素的斜率参数用来计算遮挡关系
		 */
		public function updateElementsSlope():void
		{
			for each(var element:ElementDataBase in _elementsData)
			{
				element.updateSlope();
			}
		}
		
		/**
		 * 更新指定地图元素的斜率，地图元素的斜率参数用来计算遮挡关系
		 * 
		 * @param	id
		 */
		public function updateElementSlope(id:Object):void
		{
			if(!containsElement(id))
			{
				throw new NoSuchObjectException("Has not the element \"" + id + "\"");
			}
			
			var element:IElement = _elements[id];
			var elementData:ElementDataBase = _elements[element.getDataUniqueID()];
			Assert.checkNull(elementData);
			elementData.updateSlope();
		}
		
		/**
		 * 添加建筑占位点
		 * 
		 * @param	id
		 * @param	x
		 * @param	y
		 */
		public function addAreaPoint(id:Object, x:int, y:int):void
		{
			if(!containsElement(id))
			{
				throw new NoSuchObjectException("Has not the element \"" + id + "\"");
			}
			
			var element:IElement = _elements[id];
			var elementData:ElementDataBase = _elementsData[element.getDataUniqueID()];
			Assert.checkNull(elementData);
			elementData.addAreaPoint(x, y);
		}
		
		/**
		 * 删除建筑占位点
		 * 
		 * @param	id
		 * @param	x
		 * @param	y
		 */
		public function removeAreaPoint(id:Object, x:int, y:int):void
		{
			if(!containsElement(id))
			{
				throw new NoSuchObjectException("Has not the element \"" + id + "\"");
			}
			
			var element:IElement = _elements[id];
			var elementData:ElementDataBase = _elementsData[_elements[id].getDataUniqueID()];
			Assert.checkNull(elementData);
			elementData.removeAreaPoint(x, y);
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
			return _elements[id];
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
			return _elementsData[id];
		}
		
		/**
		 * 获得所有的地图元素。键是元素的id，值是类型是ElementBase的对象
		 * 
		 * @return
		 */
		public function getElements():Dictionary
		{
			return _elements;
		}
		
		/**
		 * 获得所有地图元素数据。键是数据的id，值是类型是ElementDataBase的对象
		 * 
		 * @return
		 */
		public function getElementsData():Dictionary
		{
			return _elementsData;
		}
		
		/**
		 * 添加一个地图元素。
		 * 
		 * @param	element	地图元素
		 * @param	elementData	地图元素的数据
		 * @param	mapInitParams
		 * @param	tiles
		 */
		public function addElement(element:IElement, elementData:ElementDataBase, mapInitParams:MapInitializeParameters, tiles:TilesBase):void
		{
			Assert.checkNull(mapInitParams, tiles);
			
			if(containsElement(element.getUniqueID()))
			{
				throw new IllegalOperationException("Has contains the element \"" + element.getUniqueID() + "\"");
			}
			if(containsElementData(elementData.getUniqueID()))
			{
				throw new IllegalOperationException("Has contains the elementData \"" + elementData.getUniqueID() + "\"");
			}
			if(element.getDataUniqueID() != elementData.getUniqueID())
			{
				throw new IllegalParameterException(
					"Element id " + element.getDataUniqueID() + " isnot equal to elementData id \"" + elementData.getUniqueID() + "\""
				);
			}
			
			_elements[element.getUniqueID()] = element;
			_elementsData[elementData.getUniqueID()] = elementData;
			mapInitParams.getElementContainer().addChild(DisplayObject(element));
			moveElementByRowCol(element.getUniqueID(), elementData.x, elementData.y, mapInitParams, tiles);
		}
		
		/**
		 * 通过屏幕上的像素坐标移动地图元素
		 * 
		 * @param	id
		 * @param	x
		 * @param	y
		 * @param	mapInitParams
		 * @param	tiles
		 */
		public function moveElementByScreenCoordinate(id:Object, x:Number, y:Number, mapInitParams:MapInitializeParameters, tiles:TilesBase):void
		{
			Assert.checkNull(mapInitParams, tiles);
			
			if(!containsElement(id))
			{
				throw new NoSuchObjectException("Has not the element \"" + id + "\"");
			}
			
			var element:IElement = getElement(id);
			Assert.checkNull(element);
			var elementData:ElementDataBase = getElementData(element.getDataUniqueID());
			Assert.checkNull(elementData);
			var rowColCoord:Point = tiles.getRowColByScreenCoordinate(x, y, mapInitParams);
				
			element.x = x;
			element.y = y;
			elementData.setX(rowColCoord.x);
			elementData.setY(rowColCoord.y);
		}
		
		/**
		 * 通过行列坐标移动一个地图元素
		 * 
		 * @param	id	要移动地图元素的id号
		 * @param	x	移动到的列
		 * @param	y	移动到的行
		 * @param	mapInitParams
		 * @param	tiles
		 */
		public function moveElementByRowCol(id:Object, x:int, y:int, mapInitParams:MapInitializeParameters, tiles:TilesBase):void
		{
			Assert.checkNull(mapInitParams, tiles);
			
			if(!containsElement(id))
			{
				throw new NoSuchObjectException("Has not the element \"" + id + "\"");
			}
			
			var element:IElement = getElement(id);
			Assert.checkNull(element);
			var elementData:ElementDataBase = getElementData(element.getDataUniqueID());
			Assert.checkNull(elementData);
			var scrPoint:Point = tiles.getScreenCoordinateByRowCol(y, x, mapInitParams);
			var srcX:Number = scrPoint.x;
			var srcY:Number = scrPoint.y;
			
			if (mapInitParams.elementTileCenterAlign)
			{
				var offset:Point = tiles.getTileCenterOffset(mapInitParams);
				srcX += offset.x;
				srcY += offset.y;
			}
			
			element.x = srcX;
			element.y = srcY;
			elementData.setX(x);
			elementData.setY(y);
		}
		
		/**
		 * 删除指定的地图元素
		 * 
		 * @param	id	要是删除的地图元素的id
		 * @param	mapInitParams 
		 * @param	loop 
		 */
		public function removeElement(id:Object, mapInitParams:MapInitializeParameters):void
		{
			Assert.checkNull(mapInitParams);
			
			if(!containsElement(id))
			{
				throw new NoSuchObjectException("Has not the element \"" + id + "\"");
			}
			
			var element:IElement = getElement(id);
			Assert.checkNull(element);
			var elementData:ElementDataBase = getElementData(element.getDataUniqueID());
			Assert.checkNull(elementData);
			var container:DisplayObjectContainer = mapInitParams.getElementContainer();
			if (element.parent == container)
			{
				container.removeChild(DisplayObject(element));
			}
			
			delete _elements[id];
			delete _elementsData[id];
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
			return _elements[id] != undefined;
		}
		
		/**
		 * 判断是否存在指定id的地图元素数据
		 * 
		 * @param	id
		 * 
		 * @return
		 */
		public function containsElementData(id:Object):Boolean
		{
			return _elementsData[id] != undefined;
		}
		
		private function destroyElements():void
		{
			for each(var element:IElement in _elements)
			{
				if (element.parent != null)
				{
					element.parent.removeChild(DisplayObject(element));
				}
			}
			
			DestroyUtil.breakMap(_elements);
			_elements = null;
			DestroyUtil.breakMap(_elementsData);
			_elements = null;
		}
		
		//-------------------------------------------------------------------------------------------------------------
		// 实现 IDestroy 接口
		//-------------------------------------------------------------------------------------------------------------
		
		public function destroy():void
		{
			destroyElements();
			destroyGridCells();
		}
	}

}