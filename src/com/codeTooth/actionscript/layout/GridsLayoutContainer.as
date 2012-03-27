package com.codeTooth.actionscript.layout
{
	import flash.display.DisplayObjectContainer;
	
	public class GridsLayoutContainer extends LayoutContainer
	{
		public function GridsLayoutContainer(container:DisplayObjectContainer = null, 
											 					elementWidth:Number = 40, elementHeight:Number = 40, 
																amountPerRow:int = 4)
		{
			super(container);
			setLayout(new GridsLayout(amountPerRow));
			setElementBounds(new NormalElementBounds(elementWidth, elementHeight));
		}
	}
}