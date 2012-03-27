package com.codeTooth.actionscript.layout
{
	import flash.display.DisplayObjectContainer;
	
	public class HLayoutContainer extends LayoutContainer
	{
		public function HLayoutContainer(container:DisplayObjectContainer = null, 
										 					elementWidth:Number = 40, elementHeight:Number = 40)
		{
			super(container);
			setLayout(new HLayout());
			setElementBounds(new NormalElementBounds(elementWidth, elementHeight));
		}
	}
}