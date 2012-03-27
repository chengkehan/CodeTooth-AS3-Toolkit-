package com.codeTooth.actionscript.game.map.element 
{
	import com.codeTooth.actionscript.display.GraphicsPen;
	import com.codeTooth.actionscript.display.HitAreaSprite;
	import com.codeTooth.actionscript.lang.utils.Common;
	import com.codeTooth.actionscript.lang.utils.destroy.DestroyUtil;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	/**
	 * 继承自Sprite地图元素。
	 * 相比继承自Bitmap的地图元素，这里增加了显示标记的功能。
	 */
	public class SpriteElement extends HitAreaSprite implements IElement
	{
		private var _flagColor:uint = 0x000000;
		
		public var g:Shape = null;
		
		/**
		 * 构造函数
		 * 
		 * @param	id	元素的id
		 * @param	dataID	元素数据的id
		 */
		public function SpriteElement(id:Object, dataID:Object) 
		{
			_id = id;
			_dataID = dataID;
			_bmp = new Bitmap();
			addChild(_bmp);
			_areaPoints = new Dictionary();
			g = new Shape();
			addChild(g);
		}
		
		//-----------------------------------------------------------------------------------------------------------
		// 重写 HitAreaSprite 中的抽象方法
		//-----------------------------------------------------------------------------------------------------------
		
		override protected function getSpriteBounds():Rectangle
		{
			return _bmp.getBounds(this);
		}
		
		override protected function inHitArea(mouseX:Number, mouseY:Number):Boolean
		{
			if (_bmp.bitmapData == null)
			{
				return false;
			}
			else
			{
				return _bmp.bitmapData.getPixel32(mouseX, mouseY) >>> 24 != 0x00;
			}
		}
		
		//----------------------------------------------------------------------------------------------------------------------------
		// 标记通用
		//----------------------------------------------------------------------------------------------------------------------------
		
		/**
		 * 标记颜色
		 */
		public function set flagColor(color:uint):void
		{
			_flagColor = color;
			drawLeftUpFlag();
			drawAreaPointsFlag();
		}
		
		/**
		 * @private
		 */
		public function get flagColor():uint
		{
			return _flagColor;
		}
		
		// 绘制一个标记
		private function drawFlag(graphics:Graphics):void
		{
			graphics.clear();
			graphics.beginFill(_flagColor);
			GraphicsPen.drawCross(graphics, 10, 5);
			graphics.endFill();
		}
		
		//----------------------------------------------------------------------------------------------------------------------------
		// 占位点
		//----------------------------------------------------------------------------------------------------------------------------
		
		private var _areaPoints:Dictionary/*key x_y(String), value Shape*/ = null;
		
		private var _areaPointsVisible:Boolean = true;
		
		public function showAreaPointFlags():void
		{
			if(_areaPointsVisible)
			{
				return;
			}
			_areaPointsVisible = true;
			
			for each(var flag:Shape in _areaPoints)
			{
				if(flag.parent != this)
				{
					addChild(flag);
				}
			}
		}
		
		public function hideAreaPointFlags():void
		{
			if(!_areaPointsVisible)
			{
				return;
			}
			_areaPointsVisible = false;
			
			for each(var flag:Shape in _areaPoints)
			{
				if(flag.parent == this)
				{
					removeChild(flag);
				}
			}
		}
		
		/**
		 * 添加一个占位标记
		 * 
		 * @param	x	相对于左上角的x像素偏移量
		 * @param	y	相对于左上角的y像素偏移量
		 * 
		 * @return	返回是否成功添加。如果存在重复指定的行列值，返回false
		 */
		public function addAreaPointFlag(x:int, y:int):Boolean
		{
			var id:String = x + Common.DELIM + y;
			if (_areaPoints[id] == undefined)
			{
				var flag:Shape = new Shape();
				drawFlag(flag.graphics);
				flag.x = x;
				flag.y = y;
				
				if(_areaPointsVisible)
				{
					addChild(flag);
				}
				_areaPoints[id] = flag;
				
				return true;
			}
			else
			{
				return false;
			}
		}
		
		/**
		 * 删除一个占位标记
		 * 
		 * @param	x
		 * @param	y
		 * 
		 * @return	返回是否成功删除。在指定的行列中不存在占位标记，返回false
		 */
		public function removeAreaPointFlag(x:int, y:int):Boolean
		{
			var id:String = x + Common.DELIM + y;
			if (_areaPoints[id] == undefined)
			{
				return false;
			}
			else
			{
				var flag:Shape = _areaPoints[id];
				if(flag.parent == this)
				{
					removeChild(flag);
				}
				delete _areaPoints[id];
				
				return true;
			}
		}
		
		/**
		 * 删除所有显示的占位标记
		 */
		public function removeAreaPointFlags():void
		{
			for each(var flag:Shape in _areaPoints)
			{
				if (flag.parent == this)
				{
					removeChild(flag);
				}
			}
			DestroyUtil.breakMap(_areaPoints);
		}
		
		private function drawAreaPointsFlag():void
		{
			for each(var flag:Shape in _areaPoints)
			{
				drawFlag(flag.graphics);
			}
		}
		
		private function destroyAreaPoints():void
		{
			if (_areaPoints != null)
			{
				for each(var flag:Shape in _areaPoints)
				{
					removeChild(flag);
				}
				DestroyUtil.breakMap(_areaPoints);
				_areaPoints = null;
			}
		}
		
		//----------------------------------------------------------------------------------------------------------------------------
		// 左上角的点
		//----------------------------------------------------------------------------------------------------------------------------
		
		private var _leftUpFlag:Shape = null;
		
		/**
		 * 显示左上角的标记
		 * 
		 * @return
		 */
		public function showLeftUpFlag():Boolean
		{
			if (_leftUpFlag == null)
			{
				_leftUpFlag = new Shape();
				drawLeftUpFlag();
			}
			if (_leftUpFlag.parent != this)
			{
				addChild(_leftUpFlag);	
				return true;
			}
			else
			{
				return false;
			}
		}
		
		/**
		 * 隐藏左上角的标记
		 * 
		 * @return
		 */
		public function hideLeftUpFlag():Boolean
		{
			if (_leftUpFlag != null && _leftUpFlag.parent != null)
			{
				removeChild(_leftUpFlag);
				return true;
			}
			else
			{
				return false;
			}
		}
		
		private function drawLeftUpFlag():void
		{
			if (_leftUpFlag != null)
			{
				drawFlag(_leftUpFlag.graphics);
			}
		}
		
		private function destroyLeftUpFlag():void
		{
			if (_leftUpFlag != null)
			{
				if (_leftUpFlag.parent != null)
				{
					removeChild(_leftUpFlag);
				}
				_leftUpFlag = null;
			}
		}
		
		//----------------------------------------------------------------------------------------------------------------------------
		// 显示
		//----------------------------------------------------------------------------------------------------------------------------
		
		// 显示的位图
		private var _bmp:Bitmap = null;
		
		// 地图元素在现实列表中的索引值
		private var _indexInDisplayList:int = -1;
		
		/**
		 * @inheritDoc
		 */
		public function set indexInDisplayList(index:int):void
		{
			_indexInDisplayList = index;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get indexInDisplayList():int
		{
			return _indexInDisplayList;
		}
		
		/**
		 * 设置显示的位图
		 * 
		 * @param	bmpd
		 */
		public function setFacade(bmpd:BitmapData):void
		{
			_bmp.bitmapData = bmpd;
		}
		
		/**
		 * 获得显示的位图
		 * 
		 * @return
		 */
		public function getFacade():BitmapData
		{
			return _bmp.bitmapData;
		}
		
		private function destroyFacade():void
		{
			if (_bmp != null)
			{
				if (_bmp.parent != null)
				{
					removeChild(_bmp);
				}
				_bmp.bitmapData = null;
				_bmp = null;
			}
		}
		
		public function get boundsX():Number
		{
			return super.x;
		}
		
		public function get boundsY():Number
		{
			return super.y;
		}
		
		public function get boundsWidth():Number
		{
			return super.width;
		}
		
		public function get boundsHeight():Number
		{
			return super.height;
		}
		
		//----------------------------------------------------------------------------------------------------------------------------
		// 实现 IUniqueObject 接口
		//----------------------------------------------------------------------------------------------------------------------------
		
		private var _id:Object = null;
		
		private var _dataID:Object = null;
		
		public function getUniqueID():*
		{
			return _id;
		}
		
		public function getDataUniqueID():*
		{
			return _dataID;
		}
		
		//----------------------------------------------------------------------------------------------------------------------------
		// 实现 IDestroy 接口
		//----------------------------------------------------------------------------------------------------------------------------\
		
		override public function destroy():void
		{
			super.destroy();
			destroyFacade();
			destroyLeftUpFlag();
			destroyAreaPoints();
		}
	}

}