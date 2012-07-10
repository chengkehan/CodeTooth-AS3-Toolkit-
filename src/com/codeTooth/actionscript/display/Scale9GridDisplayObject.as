package com.codeTooth.actionscript.display
{
	import com.codeTooth.actionscript.lang.utils.destroy.IDestroy;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	
	/**
	 * 9宫格显示对象缩放
	 */
	public class Scale9GridDisplayObject extends Sprite implements IDestroy
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
		public function Scale9GridDisplayObject(topLeft:DisplayObject = null, top:DisplayObject = null, topRight:DisplayObject = null, 
												left:DisplayObject = null, center:DisplayObject = null, right:DisplayObject = null, 
												bottomLeft:DisplayObject = null, bottom:DisplayObject = null, bottomRight:DisplayObject = null) 
		{
			_topLeft = topLeft;
			_top = top;
			_topRight = topRight;
			_left = left;
			_center = center;
			_right = right;
			_bottomLeft = bottomLeft;
			_bottom = bottom;
			_bottomRight = bottomRight;
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
		private var _topLeft:DisplayObject = null;
		
		/**
		 * 左上
		 */
		public function getTopLeft():DisplayObject 
		{ 
			return _topLeft; 
		}
		
		/**
		 * @private
		 */
		public function setTopLeft(obj:DisplayObject):void 
		{
			destroyTopLeft();
			_topLeft = obj;
			updateTopLeft();
		}
		
		private function updateTopLeft():void
		{
			if (_topLeft != null)
			{
				if(_topLeft.parent != this)
				{
					addChild(_topLeft);
				}
				_topLeft.width = _leftSize;
				_topLeft.height = _topSize;
			}
		}
		
		private function destroyTopLeft():void
		{
			if (_topLeft != null)
			{
				if(_topLeft.parent == this)
				{
					removeChild(_topLeft);
				}
				_topLeft = null;
			}
		}
		
		// Top
		private var _top:DisplayObject = null;
		
		/**
		 * 上
		 */
		public function getTop():DisplayObject 
		{ 
			return _top; 
		}
		
		/**
		 * @private
		 */
		public function setTop(obj:DisplayObject):void 
		{
			destroyTop();
			_top = obj;
			updateTop();
		}
		
		private function updateTop():void
		{
			if (_top != null)
			{
				if(_top.parent != this)
				{
					addChild(_top);
				}
				_top.width = _width - _leftSize - _rightSize;
				_top.height = _topSize;
				_top.x = _leftSize;
			}
		}
		
		private function destroyTop():void
		{
			if (_top != null)
			{
				if (_top.parent == this)
				{
					removeChild(_top);
				}
				_top = null;
			}
		}
		
		// TopRight
		private var _topRight:DisplayObject = null;
		
		/**
		 * 右上
		 */
		public function getTopRight():DisplayObject 
		{ 
			return _topRight; 
		}
		
		/**
		 * @private
		 */
		public function setTopRight(obj:DisplayObject):void 
		{
			destroyTopRight();
			_topRight = obj;
			updateTopRight();
		}
		
		private function updateTopRight():void
		{
			if (_topRight != null)
			{
				if(_topRight.parent != this)
				{
					addChild(_topRight);
				}
				_topRight.width = _rightSize;
				_topRight.height = _topSize;
				_topRight.x = _width - _rightSize;
			}
		}
		
		private function destroyTopRight():void
		{
			if (_topRight != null)
			{
				if (_topRight.parent == this)
				{
					removeChild(_topRight);
				}
				_topRight = null;
			}
		}
		
		// Left
		private var _left:DisplayObject = null;
		
		/**
		 * 左
		 */
		public function getLeft():DisplayObject 
		{ 
			return _left; 
		}
		
		/**
		 * @private
		 */
		public function setLeft(obj:DisplayObject):void 
		{
			destroyLeft();
			_left = obj;
			updateLeft();
		}
		
		private function updateLeft():void
		{
			if (_left != null)
			{
				if(_left.parent != this)
				{
					addChild(_left);
				}
				_left.width = _leftSize;
				_left.height = _height - _topSize - _bottomSize;
				_left.y = _topSize;
			}
		}
		
		private function destroyLeft():void
		{
			if (_left != null)
			{
				if(_left.parent == this)
				{
					removeChild(_left);
				}
				_left = null;
			}
		}
		
		// Center
		private var _center:DisplayObject = null;
		
		/**
		 * 中
		 */
		public function getCenter():DisplayObject 
		{ 
			return _center; 
		}
		
		/**
		 * @private
		 */
		public function setCenter(obj:DisplayObject):void 
		{
			destroyCenter();
			_center = obj;
			updateCenter();
		}
		
		private function updateCenter():void
		{
			if (_center != null)
			{
				if(_center.parent != this)
				{
					addChild(_center);
				}
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
				if(_center.parent == this)
				{
					removeChild(_center);
				}
				_center = null;
			}
		}
		
		// Right
		private var _right:DisplayObject = null;
		
		/**
		 * 右
		 */
		public function getRight():DisplayObject 
		{ 
			return _right; 
		}
		
		/**
		 * @private
		 */
		public function setRight(obj:DisplayObject):void 
		{
			destroyRight();
			_right = obj;
			updateRight();
		}
		
		private function updateRight():void
		{
			if (_right != null)
			{
				if(_right.parent != this)
				{
					addChild(_right);
				}
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
				if(_right.parent == this)
				{
					removeChild(_right);
				}
				_right = null;
			}
		}
		
		// BottomLeft
		private var _bottomLeft:DisplayObject = null;
		
		/**
		 * 左下
		 */
		public function getBottomLeft():DisplayObject 
		{ 
			return _bottomLeft; 
		}
		
		/**
		 * @private
		 */
		public function setBottomLeft(obj:DisplayObject):void 
		{
			destroyBottomLeft();
			_bottomLeft = obj;
			updateBottomLeft();
		}
		
		private function updateBottomLeft():void
		{
			if (_bottomLeft != null)
			{
				if(_bottomLeft.parent != this)
				{
					addChild(_bottomLeft);
				}
				_bottomLeft.width = _leftSize;
				_bottomLeft.height = _bottomSize;
				_bottomLeft.y = _height - _bottomSize;
			}
		}
		
		private function destroyBottomLeft():void
		{
			if (_bottomLeft != null)
			{
				if(_bottomLeft.parent == this)
				{
					removeChild(_bottomLeft);
				}
				_bottomLeft = null;
			}
		}
		
		// Bottom
		private var _bottom:DisplayObject = null;
		
		/**
		 * 下
		 */
		public function getBottom():DisplayObject 
		{ 
			return _bottom; 
		}
		
		/**
		 * @private
		 */
		public function setBottom(obj:DisplayObject):void 
		{
			destroyBottom();
			_bottom = obj;
			updateBottom();
		}
		
		private function updateBottom():void
		{
			if (_bottom != null)
			{
				if(_bottom.parent != this)
				{
					addChild(_bottom);
				}
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
				if(_bottom.parent == this)
				{
					removeChild(_bottom);
				}
				_bottom = null;
			}
		}
		
		// BottomRight
		private var _bottomRight:DisplayObject = null;
		
		/**
		 * 右下
		 */
		public function getBottomRight():DisplayObject 
		{ 
			return _bottomRight; 
		}
		
		/**
		 * @private
		 */
		public function setBottomRight(obj:DisplayObject):void 
		{
			destroyBottomRight();
			_bottomRight = obj;
			updateBottomRight();
		}
		
		private function updateBottomRight():void
		{
			if (_bottomRight != null)
			{
				if(_bottomRight.parent != this)
				{
					addChild(_bottomRight);
				}
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
				if(_bottomRight.parent == this)
				{
					removeChild(_bottomRight);
				}
				_bottomRight = null;
			}
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