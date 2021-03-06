package com.codeTooth.actionscript.layout
{
	import flash.display.DisplayObject;
	
	public class NormalElementBounds implements IElementBounds
	{
		private var _x:Number = 0;
		
		private var _y:Number = 0;
		
		private var _width:Number = 0;
		
		private var _height:Number = 0;
		
		public function NormalElementBounds(width:Number = 40, height:Number = 40)
		{
			_width = width;
			_height = height;
		}
		
		public function get width():Number
		{
			return _width;
		}
		
		public function get height():Number
		{
			return _height;
		}
		
		public function get x():Number
		{
			return _x;
		}
		
		public function get y():Number
		{
			return _y;
		}
		
		public function set x(value:Number):void
		{
			_x = value;
		}
		
		public function set y(value:Number):void
		{
			_y = value;
		}
		
		public function setElement(element:DisplayObject, layoutContainer:LayoutContainer):void
		{
			// Do nothing.
		}
	}
}