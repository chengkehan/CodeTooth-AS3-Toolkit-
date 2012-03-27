package com.codeTooth.actionscript.layout
{
	import flash.geom.Rectangle;
	
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	
	public class HLayout extends LayoutBase
	{
		public function HLayout()
		{
			
		}
		
		//---------------------------------------------------------------------------------------------------------------------------------------------------
		// 重写排版
		//---------------------------------------------------------------------------------------------------------------------------------------------------
		
		override protected function layoutInternal():void
		{
			// Get bonuds
			var bounds:Rectangle = new Rectangle();
			var hGap:Number = _container.hGap;
			var elements:Array = _container.getElements();
			var numberElements:int = elements.length;
			var elementBounds:IElementBounds = _container.getElementBounds();
			var element:DisplayObject;
			
			for each(element in elements)
			{
				bounds.height = Math.max(bounds.height, elementBounds.height);
				bounds.width += elementBounds.width + hGap;
			}
			bounds.width -= hGap;
			
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
				var tx:Number = bounds.x;
				var willDrawBounds:Boolean = _container.drawBounds;
				
				for(var i:int = 0; i < numberElements; i++)
				{
					elementBounds.x = tx;
					elementBounds.y = bounds.y;
					positionElement(elementBounds, elements[i]);
					
					// Draw element bounds
					if(willDrawBounds)
					{
						drawElementBounds(elementBounds);
					}
					
					tx += elementBounds.width + hGap;
				}
			}
		}
	}
}