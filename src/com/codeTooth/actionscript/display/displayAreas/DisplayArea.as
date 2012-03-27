package com.codeTooth.actionscript.display.displayAreas
{
	import com.codeTooth.actionscript.lang.exceptions.NoSuchObjectException;
	import com.codeTooth.actionscript.lang.exceptions.NullPointerException;
	import com.codeTooth.actionscript.lang.utils.destroy.DestroyUtil;
	import com.codeTooth.actionscript.lang.utils.destroy.IDestroy;
	import com.codeTooth.actionscript.lang.utils.uniqueObject.IUniqueObject;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.utils.Dictionary;

	internal class DisplayArea implements IDestroy, IUniqueObject
	{
		public function DisplayArea(id:Object)
		{
			_id = id;
			_elements = new Dictionary();
		}
		
		//----------------------------------------------------------------------------------------------------------------------------------
		// Visible
		//----------------------------------------------------------------------------------------------------------------------------------
		
		private var _visible:Boolean = false;
		
		public function setVisible(visible:Boolean, elements:Dictionary/*key DisplayObject, value Element*/, container:DisplayObjectContainer):void
		{
			if(elements == null)
			{
				throw new NullPointerException("Null elements");
			}
			if(container == null)
			{
				throw new NullPointerException("Null container");
			}
			
			if(_visible != visible)
			{
				_visible = visible;
				 for each(var element:DisplayObject in _elements)
				 {
					setElementVisible(element, elements, container);
				 }
			}
		}
		
		public function getVisible():Boolean
		{
			return _visible;
		}
		
		//----------------------------------------------------------------------------------------------------------------------------------
		// ElementIDs
		//----------------------------------------------------------------------------------------------------------------------------------
		
		private var _elements:Dictionary/*key element:DisplayObject, value element:DisplayObject*/ = null;
		
		public function addElementID(element:DisplayObject, elements:Dictionary/*key DisplayObject, value Element*/, container:DisplayObjectContainer):void
		{
			_elements[element] = element;
			
			if(elements[element] == null)
			{
				throw new NoSuchObjectException("Has not the element \"" + element + "\" in elements");
			}
			var elementObj:Element = elements[element];
			elementObj.addDisplayAreaID(_id);
			
			setElementVisible(element, elements, container);
		}
		
		public function removeElementID(element:DisplayObject, elements:Dictionary/*key DisplayObject, value Element*/, container:DisplayObjectContainer):void
		{
			if(elements == null)
			{
				throw new NullPointerException("Null elements");
			}
			if(container == null)
			{
				throw new NullPointerException("Null container");
			}
			
			delete _elements[element];
			
			if(elements[element] == null)
			{
				throw new NoSuchObjectException("Has not the element \"" + element + "\" in elements");
			}
			var elementObj:Element = elements[element];
			elementObj.removeDisplayAreaID(_id);
			
			if(elementObj.getElement().parent == container)
			{
				container.removeChild(elementObj.getElement());
			}
		}
		
		public function containerElementID(element:DisplayObject):Boolean
		{
			return _elements[element] != null;
		}
		
		private function setElementVisible(element:DisplayObject, elements:Dictionary/*key DisplayObject, value Element*/, container:DisplayObjectContainer):void
		{
			if(elements == null)
			{
				throw new NullPointerException("Null elements");
			}
			if(container == null)
			{
				throw new NullPointerException("Null container");
			}
			
			if(elements[element] == null)
			{
				throw new NoSuchObjectException("Has not the element \"" + element + "\" in elements");
			}
			var elementObj:Element = elements[element];
			
			if(getVisible())
			{
				if(elementObj.getElement().parent != container)
				{
					container.addChild(elementObj.getElement());
				}
			}
			else
			{
				if(elementObj.getElement().parent == container)
				{
					container.removeChild(elementObj.getElement());
				}
			}
		}
		
		//----------------------------------------------------------------------------------------------------------------------------------
		// 实现 IUniqueObject 接口
		//----------------------------------------------------------------------------------------------------------------------------------
		
		private var _id:Object = null;
		
		public function getUniqueID():*
		{
			return _id;
		}
		
		//----------------------------------------------------------------------------------------------------------------------------------
		// 实现 IDestroy 接口
		//----------------------------------------------------------------------------------------------------------------------------------
		
		public function destroy():void
		{
			DestroyUtil.breakMap(_elements);
			_elements = null;
		}
	}
}