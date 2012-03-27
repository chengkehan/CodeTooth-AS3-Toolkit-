package com.codeTooth.actionscript.layout
{
	import flash.geom.Rectangle;
	
	import flash.display.DisplayObject;
	import flash.display.Graphics;

	/**
	 * 排版基类
	 */
	public class LayoutBase
	{
		protected var _container:LayoutContainer = null;
		
		public function LayoutBase()
		{
			
		}
		
		//---------------------------------------------------------------------------------------------------------------------------------------------------
		// 排版
		//---------------------------------------------------------------------------------------------------------------------------------------------------
		
		//开始进行排版
		public function layout(container:LayoutContainer):LayoutContainer
		{
			if(container == null)
			{
				return null;
			}
			else
			{
				var elements:Array = container.getElements();
				var numberElements:int = elements.length;
				
				if(elements == null || numberElements == 0)
				{
					return null;
				}
				else
				{
					var elementBounds:IElementBounds = container.getElementBounds();
					
					if(elementBounds == null)
					{
						return null;
					}
					else
					{
						_container = container;
						layoutInternal();
					}
				}
			}
				
				return container;
		}
		
		protected function layoutInternal():void
		{
			// Do something in sub class
		}
		
		//---------------------------------------------------------------------------------------------------------------------------------------------------
		// 线条
		//---------------------------------------------------------------------------------------------------------------------------------------------------
		
		//清除边界线条
		public function clearDrawBounds():Boolean
		{
			if(_container != null && _container.getDrawBoundsGraphics() != null)
			{
				_container.getDrawBoundsGraphics().clear();
				return true;
			}
			else 
			{
				return false;
			}
		}
		
		//画容器的边界线条
		protected function drawContainerBounds():Boolean
		{
			if(_container != null && _container.drawBounds)
			{
				var graphics:Graphics = _container.getDrawBoundsGraphics();
				
				if(graphics != null)
				{
					graphics.lineStyle(1, _container.boundsColor);
					graphics.drawRect(0, 0, _container.width, _container.height);
					return true;
				}
				else
				{
					return false;
				}
			}
			else
			{
				return false;
			}
		}
		
		//画元素的边界线条		
		protected function drawElementBounds(elementBounds:IElementBounds):Boolean
		{
			if(_container != null && _container.drawBounds && elementBounds != null)
			{
				var graphics:Graphics = _container.getDrawBoundsGraphics();
				
				if(graphics != null)
				{
					graphics.lineStyle(1, _container.boundsColor);
					graphics.drawRect(elementBounds.x, elementBounds.y, elementBounds.width, elementBounds.height);
					return true;
				}
				else
				{
					return false;
				}
			}
			else
			{
				return false;
			}
		}
		
		//---------------------------------------------------------------------------------------------------------------------------------------------------
		// 定位元素
		//---------------------------------------------------------------------------------------------------------------------------------------------------
		
		protected function positionElement(elementBounds:IElementBounds, element:DisplayObject):Boolean
		{
			if(elementBounds == null || _container == null || element == null)
			{
				return false;
			}
			else
			{
				var layoutType:int = _container.getElementLayoutType();
				
				if((layoutType & LayoutType.TOP) && (layoutType & LayoutType.LEFT))
				{
					element.x = elementBounds.x + _container.elementLeftMargin;
					element.y = elementBounds.y + _container.elementTopMargin;
				}
				else if((layoutType & LayoutType.TOP) && (layoutType & LayoutType.RIGHT))
				{
					element.x = elementBounds.x + elementBounds.width - element.width - _container.elementRightMargin;
					element.y = elementBounds.y + _container.elementTopMargin;
				}
				else if((layoutType & LayoutType.BOTTOM) && (layoutType & LayoutType.RIGHT))
				{
					element.x = elementBounds.x + elementBounds.width - element.width - _container.elementRightMargin;
					element.y = elementBounds.y + elementBounds.height - element.height - _container.elementBottomMargin;
				}
				else if((layoutType & LayoutType.BOTTOM) && (layoutType & LayoutType.LEFT))
				{
					element.x = elementBounds.x + _container.elementLeftMargin;
					element.y = elementBounds.y + elementBounds.height - element.height - _container.elementBottomMargin;
				}
				else if(layoutType & LayoutType.LEFT)
				{
					element.x = elementBounds.x + _container.elementLeftMargin;
					element.y = elementBounds.y + (elementBounds.height - element.height) * .5;
				}
				else if(layoutType & LayoutType.RIGHT)
				{
					element.x = elementBounds.x + elementBounds.width - _container.elementRightMargin - element.width;
					element.y = elementBounds.y + (elementBounds.height - element.height) * .5;
				}
				else if(layoutType & LayoutType.CENTER)
				{
					element.x = elementBounds.x + (elementBounds.width - element.width) * .5;
					element.y = elementBounds.y + (elementBounds.height - element.height) * .5;
				}
				else if(layoutType & LayoutType.TOP)
				{
					element.x = elementBounds.x + (elementBounds.width - element.width) * .5;
					element.y = elementBounds.y + _container.elementTopMargin;
				}
				else if(layoutType & LayoutType.BOTTOM)
				{
					element.x = elementBounds.x + (elementBounds.width - element.width) * .5;
					element.y = elementBounds.y + elementBounds.height - _container.elementBottomMargin - element.height;
				}
				else 
				{
					return false;
				}
				
				return true;
			}
		}
		
		//---------------------------------------------------------------------------------------------------------------------------------------------------
		// 获得总体的新边界
		//---------------------------------------------------------------------------------------------------------------------------------------------------
		
		protected function getNewBounds(bounds:Rectangle):Rectangle
		{
			if(bounds == null || _container == null)
			{
				return null;
			}
			else
			{
				var layoutType:int = _container.getLayoutType();
				
				if((layoutType & LayoutType.TOP) && (layoutType & LayoutType.LEFT))
				{
					bounds.x = _container.leftMargin;
					bounds.y = _container.topMargin;
				}
				else if((layoutType & LayoutType.TOP) && (layoutType & LayoutType.RIGHT))
				{
					bounds.x = _container.width - bounds.width - _container.rightMargin;
					bounds.y = _container.topMargin;
				}
				else if((layoutType & LayoutType.BOTTOM) && (layoutType & LayoutType.RIGHT))
				{
					bounds.x = _container.width - bounds.width - _container.rightMargin;
					bounds.y = _container.height - bounds.height - _container.bottomMargin;
				}
				else if((layoutType & LayoutType.BOTTOM) && (layoutType & LayoutType.LEFT))
				{
					bounds.x = _container.leftMargin;
					bounds.y = _container.height - bounds.height - _container.bottomMargin;
				}
				else if(layoutType & LayoutType.LEFT)
				{
					bounds.x = _container.leftMargin;
					bounds.y = (_container.height - bounds.height) * .5;
				}
				else if(layoutType & LayoutType.RIGHT)
				{
					bounds.x = _container.width - _container.rightMargin - bounds.width;
					bounds.y = (_container.height - bounds.height) * .5;
				}
				else if(layoutType & LayoutType.CENTER)
				{
					bounds.x = (_container.width - bounds.width) * .5;
					bounds.y = (_container.height - bounds.height) * .5;
				}
				else if(layoutType & LayoutType.TOP)
				{
					bounds.x = (_container.width - bounds.width) * .5;
					bounds.y = _container.topMargin;
				}
				else if(layoutType & LayoutType.BOTTOM)
				{
					bounds.x = (_container.width - bounds.width) * .5;
					bounds.y = _container.height - bounds.height - _container.bottomMargin;
				}
				else 
				{
					return null;
				}
				
				return bounds;
			}
		}
	}
}