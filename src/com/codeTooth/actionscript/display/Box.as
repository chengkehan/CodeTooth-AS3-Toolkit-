package com.codeTooth.actionscript.display
{
	import flash.display.Sprite;
	
	/**
	 * 方块
	 */
	public class Box extends Sprite
	{
		/**
		 * 构造函数
		 * 
		 * @param	width 宽度
		 * @param	height 高度
		 * @param	color 颜色
		 * @param	alpha 透明度
		 * @param	border 边框
		 * @param	borderColor 边框色
		 * @param	borderWidth 边框宽度
		 * @param	borderAlpha 边框颜色
		 */
		public function Box(width:Number = 100, height:Number = 100, 
							color:uint = 0x000000, alpha:Number = 1, 
							border:Boolean = false, borderColor:uint =0x000000, 
							borderWidth:Number = 1, borderAlpha:Number = 1)
		{
			_width = width;
			_height = height;
			_color = color;
			_alpha = alpha;
			_border = border;
			_borderColor = borderColor;
			_borderWidth = borderWidth;
			_borderAlpha = borderAlpha;
			draw();
		}
		
		//---------------------------------------------------------------------------------------------------------------------------------------------------
		// 重写宽高
		//---------------------------------------------------------------------------------------------------------------------------------------------------
		
		private var _width:Number = 0;
		
		private var _height:Number = 0;
		
		/**
		 * @inheritDoc
		 */
		override public function set width(value:Number):void
		{
			_width = value;
			draw();
		}
		
		/**
		 * @private
		 */
		override public function get width():Number
		{
			return _width;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function set height(value:Number):void
		{
			_height = value;
			draw();
		}
		
		/**
		 * @private
		 */
		override public function get height():Number
		{
			return _height;
		}
		
		//---------------------------------------------------------------------------------------------------------------------------------------------------
		// 透明度
		//---------------------------------------------------------------------------------------------------------------------------------------------------
		
		private var _alpha:Number = 1;
		
		/**
		 * 透明度
		 */
		override public function set alpha(value:Number):void
		{
			_alpha = value;
			draw();
		}
		
		/**
		 * @private
		 */
		override public function get alpha():Number
		{
			return _alpha;
		}
		
		//---------------------------------------------------------------------------------------------------------------------------------------------------
		// 颜色
		//---------------------------------------------------------------------------------------------------------------------------------------------------
		
		private var _color:uint = 0x000000;

		/**
		 * 颜色
		 */
		public function get color():uint
		{
			return _color;
		}

		/**
		 * @private
		 */
		public function set color(value:uint):void
		{
			_color = value;
			draw();
		}

		//---------------------------------------------------------------------------------------------------------------------------------------------------
		// 边框
		//---------------------------------------------------------------------------------------------------------------------------------------------------
		
		// Border
		private var _border:Boolean = false;

		/**
		 * 边框
		 */
		public function get border():Boolean
		{
			return _border;
		}

		/**
		 * @private
		 */
		public function set border(value:Boolean):void
		{
			_border = value;
			draw();
		}
		
		// BorderWidth
		private var _borderWidth:Number = 1;

		/**
		 * 边框宽度
		 */
		public function get borderWidth():Number
		{
			return _borderWidth;
		}

		/**
		 * @private
		 */
		public function set borderWidth(value:Number):void
		{
			_borderWidth = value;
			draw();
		}
		
		// BorderAlpha
		private var _borderAlpha:Number = 1;

		/**
		 * 边框高度
		 */
		public function get borderAlpha():Number
		{
			return _borderAlpha;
		}

		/**
		 * @private
		 */
		public function set borderAlpha(value:Number):void
		{
			_borderAlpha = value;
			draw();
		}
		
		// BorderColor
		private var _borderColor:uint = 0x000000;

		/**
		 * 边框颜色
		 */
		public function get borderColor():uint
		{
			return _borderColor;
		}

		/**
		 * @private
		 */
		public function set borderColor(value:uint):void
		{
			_borderColor = value;
			draw();
		}
		
		//---------------------------------------------------------------------------------------------------------------------------------------------------
		// 绘制
		//---------------------------------------------------------------------------------------------------------------------------------------------------
		
		/**
		 * 重绘
		 */
		public function draw():void
		{
			graphics.clear();
			if(_border)
			{
				graphics.lineStyle(_borderWidth, _borderColor, _borderAlpha);
			}
			graphics.beginFill(_color, _alpha);
			graphics.drawRect(0, 0, _width, _height);
			graphics.endFill();
		}
	}
}