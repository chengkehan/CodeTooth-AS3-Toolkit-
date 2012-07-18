package com.codeTooth.actionscript.display
{
	import flash.display.Shape;
	
	public class BoxSimple extends Shape
	{
		private var _color:uint = 0x000000;
		
		private var _alpha:Number = 1;
		
		private var _width:Number = 100;
		
		private var _height:Number = 16;
		
		public function BoxSimple(color:uint = 0x000000, alpha:Number = 1, width:Number = 100, height:Number = 16)
		{
			_color = color;
			_alpha = alpha;
			_width = width;
			_height = height;
			draw();
		}
		
		override public function set width(value:Number):void
		{
			_width = value;
			draw();
		}
		
		override public function get width():Number
		{
			return _width;
		}
		
		override public function set height(value:Number):void
		{
			_height = value;
			draw();
		}
		
		override public function get height():Number
		{
			return _height;
		}
		
		override public function set alpha(value:Number):void
		{
			_alpha = value;
			draw();
		}
		
		override public function get alpha():Number
		{
			return _alpha;
		}
		
		public function set color(color:uint):void
		{
			_color = color;
			draw();
		}
		
		public function get color():uint
		{
			return _color;
		}
		
		private function draw():void
		{
			graphics.clear();
			graphics.beginFill(_color, _alpha);
			graphics.drawRect(0, 0, _width, _height);
			graphics.endFill();
		}
	}
}