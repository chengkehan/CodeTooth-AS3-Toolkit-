package com.codeTooth.actionscript.game.action
{
	import com.codeTooth.actionscript.lang.utils.destroy.IDestroy;
	
	import flash.display.BitmapData;

	/**
	 * 剪辑帧数据
	 */
	public class ClipData implements IDestroy
	{
		// 切片x
		private var _x:int = 0;
		
		// 切片y
		private var _y:int = 0;
		
		// 切片宽度
		private var _width:int = 0;
		
		// 切片高度
		private var _height:int = 0;
		
		// 原始帧x
		private var _frameX:int = 0;
		
		// 原始帧y
		private var _frameY:int = 0;
		
		// 原始帧宽度
		private var _frameWidth:int = 0;
		
		// 原始帧高度
		private var _frameHeight:int = 0;
		
		private var _label:String = null;
		
		// 切片位图
		private var _bmpd:BitmapData = null;
		
		private var _name:String = null;
		
		public function ClipData(
			x:int, y:int, width:int, height:int, 
			frameX:int, frameY:int, frameWidth:int, frameHeight:int, 
			label:String = null, bmpd:BitmapData = null, name:String = null)
		{
			_x = x;
			_y = y;
			_width = width;
			_height = height;
			_frameX = frameX;
			_frameY = frameY;
			_frameWidth = frameWidth;
			_frameHeight = frameHeight;
			_label = label;
			_bmpd = bmpd;
			_name = name;
		}
		
		public function set name(value:String):void
		{
			_name = value;
		}
		
		public function get name():String
		{
			return _name;
		}
		
		public function get bitmapData():BitmapData
		{
			return _bmpd;
		}

		public function set bitmapData(value:BitmapData):void
		{
			_bmpd = value;
		}

		public function get label():String
		{
			return _label;
		}

		public function set label(value:String):void
		{
			_label = value;
		}

		public function get x():int
		{
			return _x;
		}

		public function get y():int
		{
			return _y;
		}

		public function get width():int
		{
			return _width;
		}

		public function get height():int
		{
			return _height;
		}
		
		public function get frameX():int
		{
			return _frameX;
		}
		
		public function get frameY():int
		{
			return _frameY;
		}
		
		public function get frameWidth():int
		{
			return _frameWidth;
		}
		
		public function get frameHeight():int
		{
			return _frameHeight;
		}
		
		public function clone():ClipData
		{
			return new ClipData(
				_x, _y, _width, _height, 
				_frameX, _frameY, _frameWidth, _frameHeight, 
				_label, _bmpd, _name
			);
		}
		
		public function destroy():void
		{
			_bmpd = null;
		}
	}
}