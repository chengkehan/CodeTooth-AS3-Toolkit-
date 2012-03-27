package com.codeTooth.actionscript.display
{
	import com.codeTooth.actionscript.lang.utils.destroy.IDestroy;
	
	import flash.display.BitmapData;
	import flash.geom.Rectangle;

	/**
	 * 把方向人物走动
	 */
	public class BitmapDataHumanClipD8 implements IDestroy
	{
		/**
		 * 构造函数
		 * 
		 * @param	humanBitmapData 八方向人物位图
		 * @param	clipWidth 剪辑宽度
		 * @param	clipHeight 剪辑高度
		 * @param	rowFirst 行主序
		 * @param	upDirection 人物上方向的行号
		 * @param	downDirection 人物下方向的行号
		 * @param	leftDirection 人物左方向的行号
		 * @param	rightDirection 人物右方向的行号
		 * @param	leftUpDirection 人物左上方向的行号
		 * @param	leftDownDirection 人物左下方向的行号
		 * @param	rightUpDirection 人物右上方向的行号
		 * @param	rightDownDirection 人物右下方向的行号
		 */
		public function BitmapDataHumanClipD8(humanBitmapData:BitmapData, clipWidth:uint, clipHeight:uint, rowFirst:Boolean = true,
												upDirection:uint = 3, downDirection:uint =0, leftDirection:uint = 1, rightDirection:uint = 2, 
												leftUpDirection:uint = 6, leftDownDirection:uint = 4, rightUpDirection:uint = 7, rightDownDirection:uint = 5)
		{
			_bitmapDataClip = new BitmapDataClip(humanBitmapData, clipWidth, clipHeight, rowFirst);
			_upDirection = upDirection;
			_downDirection = downDirection;
			_leftDirection = leftDirection;
			_rightDirection = rightDirection;
			_leftUpDirection = leftUpDirection;
			_leftDownDirection = leftDownDirection;
			_rightUpDirection = rightUpDirection;
			_rightDownDirection = rightDownDirection;
		}
		
		public function get clipWidth():uint
		{
			return _bitmapDataClip.clipWidth;
		}
		
		public function get clipHeight():uint
		{
			return _bitmapDataClip.clipHeight;
		}
		
		//---------------------------------------------------------------------------------------------------------------------------------------------------
		// Walk
		//---------------------------------------------------------------------------------------------------------------------------------------------------
		
		/**
		 * 向上走动
		 * 
		 * @params	播放第几帧，默认-1是依次播放每一帧
		 */
		public function walkUp(frame:int =-1):void
		{
			walk(_upDirection, frame);
		}
		
		/**
		 * 向下走动
		 * 
		 * @params	播放第几帧，默认-1是依次播放每一帧
		 */
		public function walkDown(frame:int =-1):void
		{
			walk(_downDirection, frame);
		}
		
		/**
		 * 向左走动
		 * 
		 * @params	播放第几帧，默认-1是依次播放每一帧
		 */
		public function walkLeft(frame:int =-1):void
		{
			walk(_leftDirection, frame);
		}
		
		/**
		 * 向右走动
		 * 
		 * @params	播放第几帧，默认-1是依次播放每一帧
		 */
		public function walkRight(frame:int =-1):void
		{
			walk(_rightDirection, frame);
		}
		
		/**
		 * 向左上走动
		 * 
		 * @params	播放第几帧，默认-1是依次播放每一帧
		 */
		public function walkLeftUp(frame:int =-1):void
		{
			walk(_leftUpDirection, frame);
		}
		
		/**
		 * 向左下走动
		 * 
		 * @params	播放第几帧，默认-1是依次播放每一帧
		 */
		public function walkLeftDown(frame:int =-1):void
		{
			walk(_leftDownDirection, frame);
		}
		
		/**
		 * 向右上走动
		 * 
		 * @params	播放第几帧，默认-1是依次播放每一帧
		 */
		public function walkRightUp(frame:int =-1):void
		{
			walk(_rightUpDirection, frame);	
		}
		
		/**
		 * 向右下走动
		 * 
		 * @params	播放第几帧，默认-1是依次播放每一帧
		 */
		public function walkRightDown(frame:int =-1):void
		{
			walk(_rightDownDirection, frame);	
		}
		
		private function walk(direction:uint, frame:int):void
		{
			var rowFirst:Boolean = _bitmapDataClip.rowFirst;
			// [frameFrom, frameTo] 闭区间
			var frameFrom:int = direction * (rowFirst ? _bitmapDataClip.cols : _bitmapDataClip.rows);
			var frameTo:int = frameFrom + (rowFirst ? _bitmapDataClip.cols : _bitmapDataClip.rows) - 1;
			
			if(frame == -1)
			{
				if(_bitmapDataClip.frame < frameFrom || _bitmapDataClip.frame > frameTo)
				{
					_bitmapDataClip.frame = frameFrom;
				}
				else
				{
					if(_bitmapDataClip.frame == frameTo)
					{
						_bitmapDataClip.frame = frameFrom;
					}
					else
					{
						_bitmapDataClip.nextFrame();
					}
				}
			}
			else
			{
				_bitmapDataClip.frame = Math.min(Math.max(frameFrom + frame, frameFrom), frameTo);
			}
		}
		
		//---------------------------------------------------------------------------------------------------------------------------------------------------
		// Direction
		//---------------------------------------------------------------------------------------------------------------------------------------------------
		
		// UpDirection
		private var _upDirection:uint;

		// DownDirection
		private var _downDirection:uint;

		// LeftDirection
		private var _leftDirection:uint;

		// RightDirection
		private var _rightDirection:uint;

		// LeftUpDirection
		private var _leftUpDirection:uint;

		// LeftDownDirection
		private var _leftDownDirection:uint;

		// RightUpDirection
		private var _rightUpDirection:uint;

		// RightDownDirection
		private var _rightDownDirection:uint;

		//---------------------------------------------------------------------------------------------------------------------------------------------------
		// BitmapDataClip
		//---------------------------------------------------------------------------------------------------------------------------------------------------
		
		private var _bitmapDataClip:BitmapDataClip = null;
		
		public function get clipRows():uint
		{
			return _bitmapDataClip.rows;
		}
		
		public function get clipCols():uint
		{
			return _bitmapDataClip.cols;
		}
		
		/**
		 * 人物位图
		 */
		public function getBitmapData():BitmapData
		{
			return _bitmapDataClip.bitmapData;
		}
		
		/**
		 * 剪辑矩形范围
		 */
		public function getClipRectangle():Rectangle
		{
			return _bitmapDataClip.clipRectangle;
		}
		
		//---------------------------------------------------------------------------------------------------------------------------------------------------
		// 实现 IDestroy 接口
		//---------------------------------------------------------------------------------------------------------------------------------------------------
		
		public function destroy():void
		{
			if (_bitmapDataClip != null)
			{
				_bitmapDataClip.destroy();
				_bitmapDataClip = null;
			}
		}
	}
}