package com.codeTooth.actionscript.game.map.element 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	
	/**
	 * 地图元素
	 */
	public class ElementBase extends Bitmap implements IElement
	{
		/**
		 * 构造函数
		 * 
		 * @param	id 元素的id
		 * @param	dataID 元素对应的数据的id
		 */
		public function ElementBase(id:Object, dataID:Object) 
		{
			_id = id;
			_dataID = dataID;
		}
		
		//-----------------------------------------------------------------------------------------------------------
		// 显示
		//-----------------------------------------------------------------------------------------------------------
		
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
		 * 获得显示的位图
		 * 
		 * @return
		 */
		public function getFacade():BitmapData
		{
			return bitmapData;
		}
		
		/**
		 * 设置显示的位图
		 * 
		 * @param 
		 */
		public function setFacade(bmpd:BitmapData):void
		{
			bitmapData = bmpd;
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
		
		//-----------------------------------------------------------------------------------------------------------
		// 实现 IUniqueObject 接口
		//-----------------------------------------------------------------------------------------------------------
		
		private var _id:Object = null;
		
		private var _dataID:Object = null;
		
		/**
		 * 获得地图元素的id
		 * 
		 * @return
		 */
		public function getUniqueID():*
		{
			return _id;
		}
		
		/**
		 * 获得地图元素对应的数据的id
		 * 
		 * @return
		 */
		public function getDataUniqueID():*
		{
			return _dataID;
		}
		
		//-----------------------------------------------------------------------------------------------------------
		// 实现 IDestroy 接口
		//-----------------------------------------------------------------------------------------------------------
		
		/**
		 * @inheritDoc
		 */
		public function destroy():void
		{
			bitmapData = null;
		}
	}

}