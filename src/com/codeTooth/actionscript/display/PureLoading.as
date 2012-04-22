package com.codeTooth.actionscript.display
{
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	public class PureLoading extends Sprite
	{
		private var _width:Number = 0;
		
		private var _height:Number = 0;
		
		private var _backgroundColor:uint = 0x000000;
		
		private var _backgroundAlpha:Number = 1;
		
		private var _bar:Shape = null;
		
		private var _barHeight:Number = 0;
		
		private var _barColor:uint = 0xFFFFFF;
		
		private var _barAlpha:Number = 1;
		
		private var _value:Number = 0;/*0-100*/
		
		private var _margin:Number = 0;
		
		private var _label:TextField = null;
		
		public function PureLoading(
			width:Number = 800, height:Number = 0, margin:Number = 0, 
			backgroundColor:uint = 0x000000, backgroundAlpha:Number = 1, 
			barHeight:int = 1, barColor:uint = 0xFFFFFF, barAlpha:Number = 1)
		{
			_barHeight = barHeight;
			_barColor = barColor;
			_barColor = barColor;
			
			_margin = margin;
			_width = width;
			_height = height;
			_backgroundColor = backgroundColor;
			_backgroundAlpha = backgroundAlpha;
			redrawBg();
			
			_bar = new Shape();
			addChild(_bar);
			redrawBar();
		}
		
		override public function set width(value:Number):void
		{
			_width = value;
			redrawBg();
			repositionLabel();
		}
		
		override public function get width():Number
		{
			return _width;
		}
		
		override public function set height(value:Number):void
		{
			_height = value;
			redrawBg();
			repositionLabel();
		}
		
		override public function get height():Number
		{
			return _height;
		}
		
		public function set label(value:String):void
		{
			if(_label == null)
			{
				_label = new TextField();
				_label.autoSize = TextFieldAutoSize.LEFT;
				_label.textColor = 0xFFFFFF;
				addChild(_label);
			}
			
			_label.text = value;
			repositionLabel();
		}
		
		public function get label():String
		{
			return _label == null ? null : _label.text;
		}
		
		public function set backgroundColor(value:uint):void
		{
			_backgroundColor = value;
			redrawBg();
		}
		
		public function get backgroundColor():uint
		{
			return _backgroundColor;
		}
		
		public function set backgroundAlpha(value:Number):void
		{
			_backgroundAlpha = value;
			redrawBg();
		}
		
		public function get backgroundAlpha():Number
		{
			return _backgroundAlpha;
		}
		
		public function set barColor(value:uint):void
		{
			_barColor = value;
			redrawBar();
		}
		
		public function get barColor():uint
		{
			return _barColor;
		}

		public function set barAlpha(value:Number):void
		{
			_barAlpha = value;
			redrawBar();
		}
		
		public function get barAlpha():Number
		{
			return _barAlpha;
		}
		
		public function set value(value:Number):void
		{
			_value = Math.min(Math.max(value, 0), 100);
			redrawBar();
		}
		
		public function get value():Number
		{
			return _value;
		}
		
		public function get margin():Number
		{
			return _margin;
		}
		
		public function set margin(value:Number):void
		{
			_margin = Math.min(Math.max(value, 0), 100);
		}
		
		private function redrawBg():void
		{
			graphics.clear();
			graphics.beginFill(_backgroundColor, _backgroundAlpha);
			graphics.drawRect(0, 0, _width, _height);
			graphics.endFill();
		}
		
		private function redrawBar():void
		{
			_bar.graphics.clear();
			_bar.graphics.beginFill(_barColor, _barAlpha);
			_bar.graphics.drawRect(_width * _margin * .01, 0, (_width - _width * _margin * .01 * 2) * _value * .01, _barHeight);
			_bar.y = (_height - _barHeight) * .5;
		}

		private function repositionLabel():void
		{
			if(_label != null)
			{
				_label.x = (_width - _label.width) * .5;
				_label.y = _bar.y - _label.height;
			}
		}
	}
}