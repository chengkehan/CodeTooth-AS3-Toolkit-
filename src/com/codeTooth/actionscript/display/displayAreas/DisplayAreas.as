package com.codeTooth.actionscript.display.displayAreas
{
	import com.codeTooth.actionscript.lang.exceptions.IllegalOperationException;
	import com.codeTooth.actionscript.lang.exceptions.IllegalParameterException;
	import com.codeTooth.actionscript.lang.exceptions.NoSuchObjectException;
	import com.codeTooth.actionscript.lang.exceptions.NullPointerException;
	import com.codeTooth.actionscript.lang.utils.Common;
	import com.codeTooth.actionscript.lang.utils.destroy.DestroyUtil;
	import com.codeTooth.actionscript.lang.utils.destroy.IDestroy;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;

	/**
	 * 通过将显示容器栅格化，让不在可见范围内的元素不显示出来，以降低消耗
	 */
	public class DisplayAreas implements IDestroy
	{
		// 显示元素的容器
		private var _container:DisplayObjectContainer = null;
		
		// 区域的尺寸
		private var _areaSize:uint = 100;
		
		// 缓冲区的厚度
		private var _bufferAreaThickness:uint = 0;
		
		public function DisplayAreas(container:DisplayObjectContainer, areaSize:uint = 100, bufferAreaThickness:uint = 0)
		{
			if(container == null)
			{
				throw new NullPointerException("Null container");
			}
			if(areaSize == 0)
			{
				throw new IllegalParameterException("Illegal areaSize \"" + areaSize + "\"");
			}
			
			_container = container;
			_areaSize = areaSize;
			_bufferAreaThickness = bufferAreaThickness;
			initializeVisibleArea();
			initializeElements();
			initializeDisplayAreas();
		}
		
		//----------------------------------------------------------------------------------------------------------------------------------
		// VisibleArea
		//----------------------------------------------------------------------------------------------------------------------------------
		
		// 可见的像素范围
		private var _visibleBounds:Rectangle = null;
		
		// 可见的行列范围
		private var _visibleBoundsRowCol:BoundsRowCol = null;
		
		// 设置可见的像素范围
		public function setVisibleBounds(x:Number, y:Number, width:Number, height:Number):void
		{
			_visibleBounds.x = x;
			_visibleBounds.y = y;
			_visibleBounds.width = width;
			_visibleBounds.height = height;
			
			var boundsRowCol:BoundsRowCol = getBoundsRowCol(_visibleBounds);
			_visibleBoundsRowCol.rowFrom = boundsRowCol.rowFrom - _bufferAreaThickness;
			_visibleBoundsRowCol.colFrom = boundsRowCol.colFrom - _bufferAreaThickness;
			_visibleBoundsRowCol.rowTo = boundsRowCol.rowTo + _bufferAreaThickness;
			_visibleBoundsRowCol.colTo = boundsRowCol.colTo + _bufferAreaThickness;
		}
		
		// 获得可见的像素范围
		public function getVisibleBounds():Rectangle
		{
			return _visibleBounds.clone();
		}
		
		// 获得可见的行列范围
		public function getVisibleBoundsRowCol():BoundsRowCol
		{
			return _visibleBoundsRowCol.clone();
		}
		
		private function inVisibleRowCol(row:int, col:int):Boolean
		{
			return row >= _visibleBoundsRowCol.rowFrom && row <= _visibleBoundsRowCol.rowTo && 
				col >= _visibleBoundsRowCol.colFrom && col <= _visibleBoundsRowCol.colTo;
		}
		
		private function initializeVisibleArea():void
		{
			_visibleBounds = new Rectangle();
			_visibleBoundsRowCol = new BoundsRowCol();
		}
		
		private function destroyVisibleArea():void
		{
			_visibleBounds = null;
			_visibleBoundsRowCol = null;
		}
		
		//----------------------------------------------------------------------------------------------------------------------------------
		// DisplayAreas
		//----------------------------------------------------------------------------------------------------------------------------------
		
		// 所有的可见区域
		private var _displayAreas:Dictionary/*key id, value DisplayArea*/ = null;
		
		// 通过行列值创建一个ID号
		private function createDisplayAreaID(row:int, col:int):String
		{
			return row + Common.DELIM + col;
		}
		
		// 创建一个指定ID的区域对象
		private function createDisplayArea(row:int, col:int):DisplayArea
		{
			var displayAreaID:String = createDisplayAreaID(row, col);
			
			if(containsDisplayArea(displayAreaID))
			{
				throw new IllegalOperationException("Has contains the displayArea \"" + displayAreaID + "\"");
			}
			
			var displayArea:DisplayArea = new DisplayArea(displayAreaID);
			_displayAreas[displayAreaID] = displayArea;
			displayArea.setVisible(inVisibleRowCol(row, col), _elements, _container);
			
			return displayArea;
		}
		
		// 判断当前是否已经包含了指定ID的区域对象
		private function containsDisplayArea(displayAreaID:Object):Boolean
		{
			return _displayAreas[displayAreaID] != null;
		}
		
		// 获得指定ID的区域对象
		private function getDisplayArea(displayAreaID:Object):DisplayArea
		{
			return _displayAreas[displayAreaID];
		}
		
		private function initializeDisplayAreas():void
		{
			_displayAreas = new Dictionary();
		}
		
		private function destroyDisplayAreas():void
		{
			DestroyUtil.destroyMap(_displayAreas);
			_displayAreas = null;
		}
		
		//----------------------------------------------------------------------------------------------------------------------------------
		// Elements
		//----------------------------------------------------------------------------------------------------------------------------------
		
		// 所有的元素
		private var _elements:Dictionary/*key DisplayObject, value Element*/ = null;
		
		// 临时变量，避免重复创建对象
		private var _tempElementBounds:Rectangle = null;
		
		//  临时变量，避免重复创建对象
		private var _tempBoundsRowCol:BoundsRowCol = null;
		
		// 临时存储区域对象的集合
		private var _tempBoundsDisplayAreas:Vector.<DisplayArea> = null;
		
		// 添加一个元素
		public function addElement(element:DisplayObject):void
		{
			checkElementNull(element);
			
			if(containsElement(element))
			{
				throw new IllegalOperationException("Has contains the element \"" + element + "\"");
			}
			
			var elementObj:Element = new Element(element);
			_elements[element] = elementObj;
			
			var displayAreas:Vector.<DisplayArea> = getBoundsDisplayAreas(getElementBounds(element));
			for each(var displayArea:DisplayArea in displayAreas)
			{
				displayArea.addElementID(element, _elements, _container);
			}
		}
		
		// 删除一个元素
		public function removeElement(element:DisplayObject):void
		{
			checkElementNull(element);
			
			if(containsElement(element))
			{
				var elementObj:Element = getElement(element);
				var displayAreaIDs:Dictionary = elementObj.getDisplayAreaIDs();
				for each(var displayAreaID:Object in displayAreaIDs)
				{
					var displayArea:DisplayArea = getDisplayArea(displayAreaID);
					displayArea.removeElementID(element, _elements, _container);
				}
				
				delete _elements[element];
				elementObj.destroy();
			}
			else
			{
				throw new NoSuchObjectException("Has not contains the element \"" + element + "\"");
			}
		}
		
		// 移动元素
		public function moveElement(element:DisplayObject):void
		{
			checkElementNull(element);
			
			if(containsElement(element))
			{
				// 从原始显示区删除
				var elementObj:Element = getElement(element);
				var displayAreaIDs:Dictionary = elementObj.getDisplayAreaIDs();
				var displayArea:DisplayArea = null;
				for each(var displayAreaID:Object in displayAreaIDs)
				{
					displayArea = getDisplayArea(displayAreaID);
					displayArea.removeElementID(element, _elements, _container);
				}
				
				// 添加到新的显示区
				var displayAreas:Vector.<DisplayArea> = getBoundsDisplayAreas(getElementBounds(element));
				for each(displayArea in displayAreas)
				{
					displayArea.addElementID(element, _elements, _container);
				}
			}
			else
			{
				throw new NoSuchObjectException("Has not contains the element \"" + element + "\"");
			}
		}
		
		// 判断是否包含指定的元素
		public function containsElement(element:DisplayObject):Boolean
		{
			checkElementNull(element);
			
			return _elements[element] != null;
		}
		
		// 通过可见的像素范围，获得所有区域对象
		private function getBoundsDisplayAreas(bounds:Rectangle):Vector.<DisplayArea>
		{
			return getBoundsRowColDisplayAreas(getBoundsRowCol(bounds));
		}
		
		// 通过可见的行列范围，获得所有区域对象
		private function getBoundsRowColDisplayAreas(boundsRowCol:BoundsRowCol):Vector.<DisplayArea>
		{
			_tempBoundsDisplayAreas.length = 0;
			
			for(var row:int = boundsRowCol.rowFrom; row <= boundsRowCol.rowTo; row++)
			{
				for(var col:int = boundsRowCol.colFrom; col <= boundsRowCol.colTo; col++)
				{
					var displayAreaID:String = createDisplayAreaID(row, col);
					var displayArea:DisplayArea = 
						containsDisplayArea(displayAreaID) ? getDisplayArea(displayAreaID) : createDisplayArea(row, col);
					_tempBoundsDisplayAreas.push(displayArea);
				}
			}
			
			return _tempBoundsDisplayAreas;
		}
		
		// 通过像素范围获得行列范围
		private function getBoundsRowCol(bounds:Rectangle):BoundsRowCol
		{
			_tempBoundsRowCol.rowFrom = Math.floor(bounds.y / _areaSize);
			_tempBoundsRowCol.rowTo = Math.floor((bounds.y + bounds.height) / _areaSize);
			
			_tempBoundsRowCol.colFrom = Math.floor(bounds.x / _areaSize);
			_tempBoundsRowCol.colTo = Math.floor((bounds.x + bounds.width) / _areaSize);
			
			return _tempBoundsRowCol;
		}
		
		// 获得一个元素的像素范围
		private function getElementBounds(element:DisplayObject):Rectangle
		{
			var bounds:Rectangle = element.getBounds(element);
			_tempElementBounds.x = element.x + bounds.x;
			_tempElementBounds.y = element.y + bounds.y;
			_tempElementBounds.width = element.width;
			_tempElementBounds.height = element.height;
			
			return _tempElementBounds;
		}
		
		private function getElement(element:DisplayObject):Element
		{
			return _elements[element];
		}
		
		private function checkElementNull(element:DisplayObject):void
		{
			if(element == null)
			{
				throw new NullPointerException("Null element");
			}
		}
		
		private function initializeElements():void
		{
			_elements = new Dictionary();
			_tempElementBounds = new Rectangle();
			_tempBoundsDisplayAreas = new Vector.<DisplayArea>();
			_tempBoundsRowCol = new BoundsRowCol();
		}
		
		private function destroyElements():void
		{
			DestroyUtil.destroyMap(_elements);
			_elements = null;
			
			_tempBoundsRowCol = null;
			_tempElementBounds = null;
			
			DestroyUtil.breakVector(_tempBoundsDisplayAreas);
			_tempBoundsDisplayAreas = null;
		}
		
		//----------------------------------------------------------------------------------------------------------------------------------
		// 实现 IDestroy 接口
		//----------------------------------------------------------------------------------------------------------------------------------
		
		public function destroy():void
		{
			destroyElements();
			destroyDisplayAreas();
			destroyVisibleArea();
		}
	}
}