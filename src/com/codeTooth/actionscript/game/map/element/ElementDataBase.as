package com.codeTooth.actionscript.game.map.element 
{
	import com.codeTooth.actionscript.core.codeTooth_internal;
	import com.codeTooth.actionscript.lang.utils.destroy.DestroyUtil;
	import com.codeTooth.actionscript.lang.utils.destroy.IDestroy;
	import com.codeTooth.actionscript.lang.utils.uniqueObject.IUniqueObject;
	import flash.display.BitmapData;
	
	/**
	 * 地图元素对应的数据
	 */
	public class ElementDataBase implements IUniqueObject, IDestroy
	{
		use namespace codeTooth_internal;
		
		public function ElementDataBase(id:Object) 
		{
			_id = id;
			_areaPoints = new Vector.<int>();
		}
		
		//-----------------------------------------------------------------------------------------------------------------
		// 显示的位图
		//-----------------------------------------------------------------------------------------------------------------
		
		private var _bmpd:BitmapData = null;
		
		/**
		 * @private
		 */
		codeTooth_internal function setFacade(bmpd:BitmapData):void
		{
			_bmpd = bmpd;
		}
		
		/**
		 * 获得显示的位图
		 * 
		 * @return
		 */
		public function getFacade():BitmapData
		{
			return _bmpd;
		}
		
		//-----------------------------------------------------------------------------------------------------------------
		// 实现 IUniqueObject 接口
		//-----------------------------------------------------------------------------------------------------------------
		
		private var _id:Object = null;
		
		public function getUniqueID():*
		{
			return _id;
		}
		
		//-----------------------------------------------------------------------------------------------------------------
		// 左上角坐标
		//-----------------------------------------------------------------------------------------------------------------
		
		private var _x:int = 0;
		
		private var _y:int = 0;
		
		codeTooth_internal function setX(value:int):void
		{
			_x = value;
		}
		
		public function get x():int
		{
			return _x;
		}
		
		codeTooth_internal function setY(value:int):void
		{
			_y = value;
		}
		
		public function get y():int
		{
			return _y;
		}
		
		//-----------------------------------------------------------------------------------------------------------------
		// 地图占位点的最左和最右点
		//-----------------------------------------------------------------------------------------------------------------
	
		private var _minAreaPointY:Number = 0;
		
		private var _leftX:Number = 0;
		
		private var _leftY:Number = 0;
		
		private var _rightX:Number = 0;
		
		private var _rightY:Number = 0;
		
		private var _leftToRight:Number = 0;
		
		public function get minAreaPointY():Number
		{
			return _minAreaPointY;
		}
		
		public function get leftX():Number
		{
			return _leftX;
		}
		
		public function get leftY():Number
		{
			return _leftY;
		}
		
		public function get rightX():Number
		{
			return _rightX;
		}
		
		public function get rightY():Number
		{
			return _rightY;
		}
		
		public function updateSlope():void
		{
			var length:int = _areaPoints.length;
			if (length > 2)
			{
				_leftX = Number.MAX_VALUE;
				_rightX = Number.MIN_VALUE;
				_minAreaPointY = Number.MAX_VALUE;
				for (var i:int = 0; i < length; i += 2)
				{
					if (_areaPoints[i] < leftX)
					{
						_leftX = _areaPoints[i];
						_leftY = _areaPoints[i + 1];
					}
					if (_areaPoints[i] > rightX)
					{
						_rightX = _areaPoints[i];
						_rightY = _areaPoints[i + 1];
					}
					if (_areaPoints[i + 1] < _minAreaPointY)
					{
						_minAreaPointY = _areaPoints[i + 1];
					}
				}
			}
			else
			{
				_minAreaPointY = _areaPoints[1];
				_leftX = _areaPoints[0];
				_leftY = _areaPoints[1];
				_rightX = _areaPoints[0] + 10;
				_rightY = _areaPoints[1];
			}
		}
		
		//-----------------------------------------------------------------------------------------------------------------
		// 占位区域
		// 每个点的坐标值是相对于左上角点坐标的像素偏移量
		//-----------------------------------------------------------------------------------------------------------------
		
		private var _areaPoints:Vector.<int>/*[x, y, x, y, x, y]*/ = null;
		
		/**
		 * 获得占用的所有格数据.仅供遍历使用
		 * 
		 * @return	
		 */
		public function getAreaPoints():Vector.<int>
		{
			return _areaPoints;
		}
		
		/**
		 * 添加一个占用的格
		 * 
		 * @param	x
		 * @param	y
		 * 
		 * @return
		 */
		codeTooth_internal function addAreaPoint(x:int, y:int):Boolean
		{
			if (containsAreaPoint(x, y))
			{
				return false;
			}
			else
			{
				_areaPoints.push(x, y);
				return true;
			}
		}
		
		/**
		 * 删除一个占用的格
		 * 
		 * @param	x
		 * @param	y
		 */
		codeTooth_internal function removeAreaPoint(x:int, y:int):Boolean
		{
			var length:int = _areaPoints.length - 1;
			for (var i:int = 0; i < length; i += 2)
			{
				if (_areaPoints[i] == x && _areaPoints[i + 1] == y)
				{
					_areaPoints.splice(i, 2);
					return true;
				}
			}
			
			return false;
		}
		
		/**
		 * 判断是否占用了某一格
		 * 
		 * @param	x
		 * @param	y
		 * @return
		 */
		public function containsAreaPoint(x:int, y:int):Boolean
		{
			var length:int = _areaPoints.length - 1;
			for (var i:int = 0; i < length; i += 2)
			{
				if (_areaPoints[i] == x && _areaPoints[i + 1] == y)
				{
					return true;
				}
			}
			
			return false;
		}
		
		private function destroyAreaPoints():void
		{
			DestroyUtil.breakVector(_areaPoints);
			_areaPoints = null;
		}
		
		//-----------------------------------------------------------------------------------------------------------------
		// 实现 IDestroy 接口
		//-----------------------------------------------------------------------------------------------------------------
		
		public function destroy():void
		{
			_bmpd = null;
			destroyAreaPoints();
		}
	}

}