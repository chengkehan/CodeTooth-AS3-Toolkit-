package com.codeTooth.actionscript.display.displayAreasBaseOnSceneRectangle
{
	import com.codeTooth.actionscript.adt.quadTree.QuadTree;
	import com.codeTooth.actionscript.lang.exceptions.IllegalOperationException;
	import com.codeTooth.actionscript.lang.exceptions.NullPointerException;
	import com.codeTooth.actionscript.lang.utils.destroy.DestroyUtil;
	import com.codeTooth.actionscript.lang.utils.destroy.IDestroy;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	public class SceneRectangleDisplayAreas implements IDestroy
	{
		public function SceneRectangleDisplayAreas(container:DisplayObjectContainer)
		{
			initializeContainer(container);
			initializeVisibleBounds();
			initializeElements();
		}
		
		//----------------------------------------------------------------------------------------------------------------------------------
		// VisibleBounds
		//----------------------------------------------------------------------------------------------------------------------------------
		
		private var _visibleBounds:Rectangle = null;
		
		public function setVisibleBounds(x:Number, y:Number, width:Number, height:Number):void
		{
			_visibleBounds.x = x;
			_visibleBounds.y = y;
			_visibleBounds.width = width;
			_visibleBounds.height = height;
		}
		
		public function getVisibleBounds():Rectangle
		{
			return _visibleBounds.clone();
		}
		
		private function initializeVisibleBounds():void
		{
			_visibleBounds = new Rectangle();
		}
		
		private function destroyVisibleBounds():void
		{
			_visibleBounds = null;
		}
		
		//----------------------------------------------------------------------------------------------------------------------------------
		// Container
		//----------------------------------------------------------------------------------------------------------------------------------
		
		private var _container:DisplayObjectContainer = null;
		
		private function initializeContainer(container:DisplayObjectContainer):void
		{
			if(container == null)
			{
				throw new NullPointerException("Null container");
			}
			_container = container;
		}
		
		private function destroyContainer():void
		{
			_container = null;
		}
		
		//----------------------------------------------------------------------------------------------------------------------------------
		// Elements
		//----------------------------------------------------------------------------------------------------------------------------------
		
		private var _elements:Dictionary = null;
		
		public function addElement(element:DisplayObject):void
		{
			checkElementNull(element);
			if(containsElement(element))
			{
				throw new IllegalOperationException("Has contains the element \"" + element + "\"");
			}
			
			_elements[element] = element;
			if(_visibleBounds.contains(element.x, element.y) && element.parent != _container)
			{
				_container.addChild(element);
			}
		}
		
		public function removeElement(element:DisplayObject):void
		{
			checkElementNull(element);
			if(!containsElement(element))
			{
				throw new IllegalOperationException("Has not contains the element \"" + element + "\"");
			}
			
			delete _elements[element];
			if(_visibleBounds.contains(element.x, element.y) && element.parent == _container)
			{
				_container.removeChild(element);
			}
		}
		
		public function moveElement(element:DisplayObject):void
		{
			checkElementNull(element);
			if(!containsElement(element))
			{
				throw new IllegalOperationException("Has not contains the element \"" + element + "\"");
			}
			
			if(_visibleBounds.contains(element.x, element.y))
			{
				if(element.parent != _container)
				{
					_container.addChild(element);
				}
			}
			else
			{
				if(element.parent == _container)
				{
					_container.removeChild(element);
				}
			}
		} 
		
		public function containsElement(element:DisplayObject):Boolean
		{
			return _elements[element] != null;
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
		}
		
		private function destroyElements():void
		{
			DestroyUtil.breakMap(_elements);
			_elements = null;
		}
		
		//----------------------------------------------------------------------------------------------------------------------------------
		// 实现 IDestroy 接口
		//----------------------------------------------------------------------------------------------------------------------------------
		
		public function destroy():void
		{
			destroyContainer();
			destroyVisibleBounds();
			destroyElements();
		}
	}
}