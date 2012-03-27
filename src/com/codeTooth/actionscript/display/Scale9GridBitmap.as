package com.codeTooth.actionscript.display 
{
	import com.codeTooth.actionscript.lang.utils.destroy.IDestroy;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.PixelSnapping;
	import flash.display.Sprite;
	
	/**
	 * 9宫格位图缩放
	 */
	public class Scale9GridBitmap extends Sprite 
										implements IDestroy
	{
		/**
		 * 构造函数
		 * 
		 * @param	topLeft 左上
		 * @param	top 上
		 * @param	topRight 右上
		 * @param	left 左
		 * @param	center 中
		 * @param	right 右
		 * @param	bottomLeft 左下
		 * @param	bottom 下
		 * @param	bottomRight 右下
		 */
		public function Scale9GridBitmap(topLeft:BitmapData = null, top:BitmapData = null, topRight:BitmapData = null, 
											left:BitmapData = null, center:BitmapData = null, right:BitmapData = null, 
											bottomLeft:BitmapData = null, bottom:BitmapData = null, bottomRight:BitmapData = null) 
		{
			initializeBlocks();
			_topLeft.bitmapData = topLeft;
			_top.bitmapData = top;
			_topRight.bitmapData = topRight;
			_left.bitmapData = left;
			_center.bitmapData = center;
			_right.bitmapData = right;
			_bottomLeft.bitmapData = bottomLeft;
			_bottom.bitmapData = bottom;
			_bottomRight.bitmapData = bottomRight;
			updateBlocks();
		}
		
		//---------------------------------------------------------------------------------------------------------------------------------------------------
		// 重写宽高
		//---------------------------------------------------------------------------------------------------------------------------------------------------
		
		private var _width:Number = 120;
		
		private var _height:Number = 120;
		
		/**
		 * @inheritDoc
		 */
		override public function set width(value:Number):void
		{
			var minValue:Number = _leftSize + _rightSize;
			if (value < minValue)
			{
				value = minValue;
			}
			
			_width = value;
			updateBlocks();
		}
		
		/**
		 * @inheritDoc
		 */
		override public function set height(value:Number):void
		{
			var minValue:Number = _topSize + _bottomSize;
			if (value < minValue)
			{
				value = minValue;
			}
			
			_height = value;
			updateBlocks();
		}
		
		//---------------------------------------------------------------------------------------------------------------------------------------------------
		// Blocks
		//---------------------------------------------------------------------------------------------------------------------------------------------------
		
		// TopLeft
		private var _topLeft:Bitmap = null;
		
		/**
		 * 左上
		 */
		public function get topLeft():BitmapData 
		{ 
			return _topLeft.bitmapData; 
		}
		
		/**
		 * @private
		 */
		public function set topLeft(obj:BitmapData):void 
		{
			_topLeft.bitmapData = obj;
			updateTopLeft();
		}
		
		private function updateTopLeft():void
		{
			if (_topLeft.bitmapData != null)
			{
				_topLeft.width = _leftSize;
				_topLeft.height = _topSize;
			}
		}
		
		private function destroyTopLeft():void
		{
			if (_topLeft != null)
			{
				if (contains(_topLeft))
				{
					_topLeft.bitmapData = null;
					removeChild(_topLeft);
				}
				_topLeft = null;
			}
		}
		
		// Top
		private var _top:Bitmap = null;
		
		/**
		 * 上
		 */
		public function get top():BitmapData 
		{ 
			return _top.bitmapData; 
		}
		
		/**
		 * @private
		 */
		public function set top(obj:BitmapData):void 
		{
			_top.bitmapData = obj;
			updateTop();
		}
		
		private function updateTop():void
		{
			if (_top.bitmapData != null)
			{
				_top.width = _width - _leftSize - _rightSize;
				_top.height = _topSize;
				_top.x = _leftSize;
			}
		}
		
		private function destroyTop():void
		{
			if (_top != null)
			{
				if (contains(_top))
				{
					_top.bitmapData = null;
					removeChild(_top);
				}
				_top = null;
			}
		}
		
		// TopRight
		private var _topRight:Bitmap = null;
		
		/**
		 * 右上
		 */
		public function get topRight():BitmapData 
		{ 
			return _topRight.bitmapData; 
		}
		
		/**
		 * @private
		 */
		public function set topRight(obj:BitmapData):void 
		{
			_topRight.bitmapData = obj;
			updateTopRight();
		}
		
		private function updateTopRight():void
		{
			if (_topRight.bitmapData != null)
			{
				_topRight.width = _rightSize;
				_topRight.height = _topSize;
				_topRight.x = _width - _rightSize;
			}
		}
		
		private function destroyTopRight():void
		{
			if (_topRight != null)
			{
				if (contains(_topRight))
				{
					_topRight.bitmapData = null;
					removeChild(_topRight);
				}
				_topRight = null;
			}
		}
		
		// Left
		private var _left:Bitmap = null;
		
		/**
		 * 左
		 */
		public function get left():BitmapData 
		{ 
			return _left.bitmapData; 
		}
		
		/**
		 * @private
		 */
		public function set left(obj:BitmapData):void 
		{
			_left.bitmapData = obj;
			updateLeft();
		}
		
		private function updateLeft():void
		{
			if (_left.bitmapData != null)
			{
				_left.width = _leftSize;
				_left.height = _height - _topSize - _bottomSize;
				_left.y = _topSize;
			}
		}
		
		private function destroyLeft():void
		{
			if (_left != null)
			{
				if (contains(_left))
				{
					_left.bitmapData = null;
					removeChild(_left);
				}
				_left = null;
			}
		}
		
		// Center
		private var _center:Bitmap = null;
		
		/**
		 * 中
		 */
		public function get center():BitmapData 
		{ 
			return _center.bitmapData; 
		}
		
		/**
		 * @private
		 */
		public function set center(obj:BitmapData):void 
		{
			_center.bitmapData = obj;
			updateCenter();
		}
		
		private function updateCenter():void
		{
			if (_center.bitmapData != null)
			{
				_center.width = _width - _leftSize - _rightSize;
				_center.height = _height - _topSize - _bottomSize;
				_center.x = _leftSize;
				_center.y = _topSize;
			}
		}
		
		private function destroyCenter():void
		{
			if (_center != null)
			{
				if (contains(_center))
				{
					_center.bitmapData = null;
					removeChild(_center);
				}
				_center = null;
			}
		}
		
		// Right
		private var _right:Bitmap = null;
		
		/**
		 * 右
		 */
		public function get right():BitmapData 
		{ 
			return _right.bitmapData; 
		}
		
		/**
		 * @private
		 */
		public function set right(obj:BitmapData):void 
		{
			_right.bitmapData = obj;
			updateRight();
		}
		
		private function updateRight():void
		{
			if (_right.bitmapData != null)
			{
				_right.width = _rightSize;
				_right.height = _height - _topSize - _bottomSize;
				_right.x = _width - _rightSize;
				_right.y = _topSize;
			}
		}
		
		private function destroyRight():void
		{
			if (_right != null)
			{
				if (contains(_right))
				{
					_right.bitmapData = null;
					removeChild(_right);
				}
				_right = null;
			}
		}
		
		// BottomLeft
		private var _bottomLeft:Bitmap = null;
		
		/**
		 * 左下
		 */
		public function get bottomLeft():BitmapData 
		{ 
			return _bottomLeft.bitmapData; 
		}
		
		/**
		 * @private
		 */
		public function set bottomLeft(obj:BitmapData):void 
		{
			_bottomLeft.bitmapData = obj;
			updateBottomLeft();
		}
		
		private function updateBottomLeft():void
		{
			if (_bottomLeft.bitmapData != null)
			{
				_bottomLeft.width = _leftSize;
				_bottomLeft.height = _bottomSize;
				_bottomLeft.y = _height - _bottomSize;
			}
		}
		
		private function destroyBottomLeft():void
		{
			if (_bottomLeft != null)
			{
				if (contains(_bottomLeft))
				{
					_bottomLeft.bitmapData = null;
					removeChild(_bottomLeft);
				}
				_bottomLeft = null;
			}
		}
		
		// Bottom
		private var _bottom:Bitmap = null;
		
		/**
		 * 下
		 */
		public function get bottom():BitmapData 
		{ 
			return _bottom.bitmapData; 
		}
		
		/**
		 * @private
		 */
		public function set bottom(obj:BitmapData):void 
		{
			_bottom.bitmapData = obj;
			updateBottom();
		}
		
		private function updateBottom():void
		{
			if (_bottom.bitmapData != null)
			{
				_bottom.width = _width - _leftSize - _rightSize;
				_bottom.height = _bottomSize;
				_bottom.x = _leftSize;
				_bottom.y = _height - _bottomSize;
			}
		}
		
		private function destroyBottom():void
		{
			if (_bottom != null)
			{
				if (contains(_bottom))
				{
					_bottom.bitmapData = null;
					removeChild(_bottom);
				}
				_bottom = null;
			}
		}
		
		// BottomRight
		private var _bottomRight:Bitmap = null;
		
		/**
		 * 右下
		 */
		public function get bottomRight():BitmapData 
		{ 
			return _bottomRight.bitmapData; 
		}
		
		/**
		 * @private
		 */
		public function set bottomRight(obj:BitmapData):void 
		{
			_bottomRight.bitmapData = obj;
			updateBottomRight();
		}
		
		private function updateBottomRight():void
		{
			if (_bottomRight.bitmapData != null)
			{
				_bottomRight.width = _rightSize;
				_bottomRight.height = _bottomSize;
				_bottomRight.x = _width - _rightSize;
				_bottomRight.y = _height - _bottomSize;
			}
		}
		
		private function destroyBottomRight():void
		{
			if (_bottomRight != null)
			{
				if (contains(_bottomRight))
				{
					_bottomRight.bitmapData = null;
					removeChild(_bottomRight);
				}
				_bottomRight = null;
			}
		}
		
		// InitializeBlocks
		private function initializeBlocks():void
		{
			_topLeft = new Bitmap(null, PixelSnapping.ALWAYS);
			addChild(_topLeft);
			
			_top = new Bitmap(null, PixelSnapping.ALWAYS);
			addChild(_top);
			
			_topRight = new Bitmap(null, PixelSnapping.ALWAYS);
			addChild(_topRight);
			
			_left = new Bitmap(null, PixelSnapping.ALWAYS);
			addChild(_left);
			
			_center = new Bitmap(null, PixelSnapping.ALWAYS);
			addChild(_center);
			
			_right = new Bitmap(null, PixelSnapping.ALWAYS);
			addChild(_right);
			
			_bottomLeft = new Bitmap(null, PixelSnapping.ALWAYS);
			addChild(_bottomLeft);
			
			_bottom = new Bitmap(null, PixelSnapping.ALWAYS);
			addChild(_bottom);
			
			_bottomRight = new Bitmap(null, PixelSnapping.ALWAYS);
			addChild(_bottomRight);
		}
		
		// Update blocks
		private function updateBlocks():void
		{
			updateTopLeft();
			updateTop();
			updateTopRight();
			updateLeft();
			updateCenter();
			updateRight();
			updateBottomLeft();
			updateBottom();
			updateBottomRight();
		}
		
		//---------------------------------------------------------------------------------------------------------------------------------------------------
		// Size
		//---------------------------------------------------------------------------------------------------------------------------------------------------
		
		// TopSize
		private var _topSize:Number = 40;
		
		/**
		 * 上边三块的高度
		 */
		public function get topSize():Number 
		{ 
			return _topSize; 
		}
		
		/**
		 * @private
		 */
		public function set topSize(value:Number):void 
		{
			_topSize = value;
			updateBlocks();
		}
		
		// BottomSize
		private var _bottomSize:Number = 40;
		
		/**
		 * 下边三块的高度
		 */
		public function get bottomSize():Number 
		{ 
			return _bottomSize; 
		}
		
		/**
		 * @private
		 */
		public function set bottomSize(value:Number):void 
		{
			_bottomSize = value;
			updateBottomLeft();
			updateBottom();
			updateBottomRight();
		}
		
		// LeftSize
		private var _leftSize:Number = 40;
		
		/**
		 * 左边三块的宽度
		 */
		public function get leftSize():Number 
		{ 
			return _leftSize; 
		}
		
		/**
		 * @private
		 */
		public function set leftSize(value:Number):void 
		{
			_leftSize = value;
			updateBlocks();
		}
		
		// RightSize
		private var _rightSize:Number = 40;
		
		/**
		 * 右边三块的宽度
		 */
		public function get rightSize():Number 
		{ 
			return _rightSize; 
		}
		
		/**
		 * @private
		 */
		public function set rightSize(value:Number):void 
		{
			_rightSize = value;
			updateTopRight();
			updateRight();
			updateBottomRight();
		}
		
		//---------------------------------------------------------------------------------------------------------------------------------------------------
		// 实现 IDestroy 接口
		//---------------------------------------------------------------------------------------------------------------------------------------------------
		
		/**
		 * @inheritDoc
		 */
		public function destroy():void
		{
			destroyTopLeft();
			destroyTop();
			destroyTopRight();
			destroyLeft();
			destroyCenter();
			destroyRight();
			destroyBottomLeft();
			destroyBottom();
			destroyBottomRight();
		}
	}

}