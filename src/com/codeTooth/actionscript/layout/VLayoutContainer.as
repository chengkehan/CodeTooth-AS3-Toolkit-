package com.codeTooth.actionscript.layout
{
	import flash.display.DisplayObjectContainer;
	
	public class VLayoutContainer extends LayoutContainer
	{
		public function VLayoutContainer(container:DisplayObjectContainer = null, 
										 					elementWidth:Number = 40, elementHeight:Number = 40)
		{
			super(container);
			setLayout(new VLayout());
			setElementBounds(new NormalElementBounds(elementWidth, elementHeight));
		}
	}
}