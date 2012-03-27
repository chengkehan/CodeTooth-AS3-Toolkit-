package com.codeTooth.actionscript.layout
{
	import flash.geom.Rectangle;
	
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	
	public class GridsLayout extends LayoutBase
	{
		public function GridsLayout(amountPerRow:int = 4)
		{
			this.amountPerRow = amountPerRow;
		}
		
		//---------------------------------------------------------------------------------------------------------------------------------------------------
		// 每行的个数
		//---------------------------------------------------------------------------------------------------------------------------------------------------
		
		private var _amountPerRow:int = 4;
		
		public function set amountPerRow(value:int):void
		{
			if(value < 1)
			{
				value = 1;
			}
			_amountPerRow = value;
		}
		
		public function get amountPerRow():int
		{
			return _amountPerRow;
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
			var maxHeight:Number = 0;
			var tWidth:Number = 0;
			var count:int = 0;
			var i:int;
			
			for(i = 0; i < numberElements; i++)
			{
				tWidth += elementBounds.width + _container.hGap;
				maxHeight = Math.max(maxHeight, elementBounds.height);
				
				if(++count == _amountPerRow || i == numberElements - 1)
				{
					tWidth -= _container.hGap;
					count = 0;
					bounds.width = Math.max(bounds.width, tWidth);
					tWidth = 0;
					bounds.height += maxHeight + _container.vGap;
					maxHeight = 0;
				}
			}
			bounds.height -= _container.vGap;
			
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
				var ty:Number = bounds.y;
				var willDrawBounds:Boolean = _container.drawBounds;
				maxHeight = 0;
				count = 0;
				
				for(i = 0; i < numberElements; i++)
				{
					elementBounds.x = tx;
					elementBounds.y = ty;
					positionElement(elementBounds, elements[i]);
					
					// Draw element bounds
					if(willDrawBounds)
					{
						drawElementBounds(elementBounds);
					}
					
					maxHeight = Math.max(maxHeight, elementBounds.height);
					tx += elementBounds.width + _container.hGap;
					
					if(++count == _amountPerRow)
					{
						count = 0;
						tx = bounds.x;
						ty += maxHeight + _container.vGap;
						maxHeight = 0;
					}
				}
			}
		}
	}
}