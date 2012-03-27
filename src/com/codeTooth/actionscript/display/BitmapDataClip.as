package com.codeTooth.actionscript.display
{
	import com.codeTooth.actionscript.lang.exceptions.IllegalParameterException;
	import com.codeTooth.actionscript.lang.exceptions.NullPointerException;
	import com.codeTooth.actionscript.lang.utils.destroy.IDestroy;
	
	import flash.display.BitmapData;
	import flash.geom.Rectangle;

	/**
	 * 位图剪辑
	 */
	public class BitmapDataClip implements IDestroy
	{
		/**
		 * 构造函数
		 * 
		 * @param	bitmapData 指定的位图
		 * @param	clipWidth 剪辑宽度
		 * @param	clipHeight 剪辑高度
		 * @param	rowFirst 行主序
		 * 
		 * @throws com.codeTooth.actionscript.lang.exceptions.NullPointerException 
		 * 没有指定位图
		 * @throws com.codeTooth.actionscript.lang.exceptions.IllegalParameterException 
		 * 不正确的剪辑宽度或高度
		 */
		public function BitmapDataClip(bitmapData:BitmapData, clipWidth:uint, clipHeight:uint, rowFirst:Boolean = true)
		{
			_bitmapData = bitmapData;
			_rowFirst = rowFirst;
			
			if(_bitmapData == null)
			{
				throw new NullPointerException("Null bitmapData");
			}
			
			if( clipWidth == 0 || 
				_bitmapData.width % clipWidth != 0)
			{
				throw new IllegalParameterException("Illegal sliceWidth \"" + clipWidth + "\"");
			}
			
			if( clipHeight == 0 || 
				_bitmapData.height % clipHeight != 0)
			{
				throw new IllegalParameterException("Illegal sliceHeight \"" + clipHeight + "\"");
			}
			
			_clipRectangle = new Rectangle(0, 0, clipWidth, clipHeight);
			_rows = _bitmapData.height / clipHeight;
			_cols = _bitmapData.width / clipWidth;
			_totalFrames = _rows * _cols;
			
			_clipWidth = clipWidth;
			_clipHeight = clipHeight;
		}
		
		//---------------------------------------------------------------------------------------------------------------------------------------------------
		// BitmapData
		//---------------------------------------------------------------------------------------------------------------------------------------------------
		
		private var _clipRectangle:Rectangle = null;
		
		private var _bitmapData:BitmapData = null;
		
		private var _rowFirst:Boolean;
		
		private var _rows:uint;
		
		private var _cols:uint;
		
		private var _row:int = 0;
		
		private var _col:int = 0;
		
		/**
		 * 位图
		 */
		public function get bitmapData():BitmapData
		{
			return _bitmapData;
		}
		
		/**
		 * 剪辑矩形范围
		 */
		public function get clipRectangle():Rectangle
		{
			return _clipRectangle;
		}
		
		/**
		 * 剪辑总行数
		 */
		public function get rows():uint
		{
			return _rows;
		}
		
		/**
		 * 剪辑总列数
		 */
		public function get cols():uint
		{
			return _cols;
		}
		
		/**
		 * 行主序
		 */
		public function get rowFirst():Boolean
		{
			return _rowFirst;
		}
		
		private function updateClipRectangle():void
		{
			_clipRectangle.x = _col * _clipRectangle.width;
			_clipRectangle.y = _row * _clipRectangle.height;
		}
		
		//---------------------------------------------------------------------------------------------------------------------------------------------------
		// Operate
		//---------------------------------------------------------------------------------------------------------------------------------------------------
		
		private var _frame:int = 0;
		
		private var _totalFrames:int;
		
		private var _clipWidth:uint = 0;
		
		private var _clipHeight:uint = 0;
		
		public function get clipWidth():uint
		{
			return _clipWidth;
		}
		
		public function get clipHeight():uint
		{
			return _clipHeight;
		}
		
		/**
		 * 播放到指定的帧
		 */
		public function set frame(value:int):void
		{
			if(value < 0)
			{
				value = 0
			}
			else if(value > _totalFrames - 1)
			{
				value = _totalFrames - 1;
			}
			_frame = value;
			
			if(_rowFirst)
			{
				_row = _frame / _cols;
				_col = _frame - _row * _cols;
			}
			else
			{
				_col = _frame / _rows;
				_row = _frame - _col * _rows;
			}
			
			updateClipRectangle();
		}
		
		/**
		 * @private
		 */
		public function get frame():int
		{
			return _frame;
		}
		
		/**
		 * 总帧数
		 */
		public function get totalFrames():int
		{
			return _totalFrames;
		}
		
		/**
		 * 播放下一帧
		 * 
		 * @return 已经播放到最后返回false
		 */
		public function nextFrame():Boolean
		{
			if(_frame == _totalFrames - 1)
			{
				return false;
			}
			else
			{
				if(_rowFirst)
				{
					if(_col == _cols - 1)
					{
						_col = 0;
						_row++;
					}
					else
					{
						_col++;
					}
				}
				else
				{
					if(_row == _rows - 1)
					{
						_row = 0;
						_col++;
					}
					else
					{
						_row++;
					}
				}
				
				_frame++;
				updateClipRectangle();
				
				return true;
			}
		}
		
		/**
		 * 播放上一帧
		 * 
		 * @return 已经播放到第一帧返回false
		 */
		public function prevFrame():Boolean
		{
			if(_frame == 0)
			{
				return false;
			}
			else
			{
				if(_rowFirst)
				{
					if(_col == 0)
					{
						_col = _cols - 1;
						_row--;
					}
					else
					{
						_col--;
					}
				}
				else
				{
					if(_row == 0)
					{
						_row = _rows - 1;
						_col--;
					}
					else
					{
						_row--;
					}
				}
				
				_frame--;
				updateClipRectangle();
				
				return true;
			}
		}
		
		//---------------------------------------------------------------------------------------------------------------------------------------------------
		// 实现 IDestroy 接口
		//---------------------------------------------------------------------------------------------------------------------------------------------------
		
		public function destroy():void
		{
			if (_bitmapData != null)
			{
				_bitmapData = null;
				_clipRectangle = null;
			}
		}
	}
}