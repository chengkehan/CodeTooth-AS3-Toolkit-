package com.codeTooth.actionscript.layout
{
	import flash.geom.Rectangle;
	
	import flash.display.DisplayObject;
	import flash.display.Graphics;

	public class VLayout extends LayoutBase
	{
		public function VLayout()
		{
		}
		
		//---------------------------------------------------------------------------------------------------------------------------------------------------
		// 重写排版
		//---------------------------------------------------------------------------------------------------------------------------------------------------
		
		override protected function layoutInternal():void
		{
			// Get bonuds
			var bounds:Rectangle = new Rectangle();
			var vGap:Number = _container.vGap;
			var elements:Array = _container.getElements();
			var numberElements:int = elements.length;
			var elementBounds:IElementBounds = _container.getElementBounds();
			var element:DisplayObject;
			
			for each(element in elements)
			{
				bounds.width = Math.max(bounds.width, elementBounds.width);
				bounds.height += elementBounds.height + vGap;
			}
			bounds.height -= vGap;
			
			bounds = getNewBounds(bounds);
			
			// Draw container bounds
			if(_container.drawBounds)
			{
				var graphics:Graphics = _container.getDrawBoundsGraphics();
				if(graphics != null)
				{
					graphics.clear();
					drawContainerBounds();
				}
			}
			
			if(bounds != null)
			{
				// Position element
				var ty:Number = bounds.y;
				var willDrawBounds:Boolean = _container.drawBounds;
				
				for(var i:int = 0; i < numberElements; i++)
				{
					elementBounds.setElement(elements[i], _container);
					elementBounds.x = bounds.x;
					elementBounds.y = ty;
					positionElement(elementBounds, elements[i]);
					
					// Draw element bounds
					if(willDrawBounds)
					{
						drawElementBounds(elementBounds);
					}
					
					ty += elementBounds.height + vGap;
				}
			}
		}
	}
}