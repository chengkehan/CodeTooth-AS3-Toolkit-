package com.codeTooth.actionscript.data 
{
	[Event(name="setData", type="com.yunheng.xianyuan.component.data.DataProviderEvent")]
	
	[Event(name="addItemAt", type="com.yunheng.xianyuan.component.data.ADD_ITEM_AT")]
	
	[Event(name="removeItemAt", type="com.yunheng.xianyuan.component.data.REMOVE_ITEM_AT")]
	
	[Event(name="setItemAt", type="com.yunheng.xianyuan.component.data.SET_ITEM_AT")]
	
	[Event(name="sortOn", type="com.yunheng.xianyuan.component.data.SORT_ON")]
	
	import com.codeTooth.actionscript.lang.utils.ArrayUtil;
	import com.codeTooth.actionscript.lang.utils.compare.CompareUtil;
	import com.codeTooth.actionscript.lang.utils.destroy.DestroyUtil;
	import com.codeTooth.actionscript.lang.utils.destroy.IDestroy;
	import flash.events.EventDispatcher;
	
	/**
	 * 数据源
	 */
	public class DataProvider extends EventDispatcher 
									implements IDestroy
	{
		
		public function DataProvider() 
		{
			initializeData();
		}
		
		//-------------------------------------------------------------------------------------
		// Data
		//-------------------------------------------------------------------------------------
		
		private var _data:Array = null;
		
		private var _length:int = 0;
		
		private var _itemDataCompareFunc:Function = CompareUtil.compareObject;
		
		/**
		 * 数量
		 */
		public function get length():int
		{
			return _length;
		}
		
		/**
		 * 数据间的比较函数。在 removeItem 和 hasItem 函数中将会用到。
		 */
		public function set itemDataCompareFunc(func:Function):void
		{
			_itemDataCompareFunc = func == null ? CompareUtil.compareObject : func;
		}
		
		/**
		 * @private
		 */
		public function get itemDataCompareFunc():Function
		{
			return _itemDataCompareFunc;
		}
		
		/**
		 * 设置数据
		 * 
		 * @param	data
		 * 
		 * @return 返回设置的数据
		 */
		public function setData(data:Array):Array
		{
			_data = ArrayUtil.copyArray(data == null ? new Array() : data);
			_length = _data.length;
			dispatchEvent(new DataProviderEvent(DataProviderEvent.SET_DATA));
			
			return data;
		}
		
		/**
		 * 添加一条
		 * 
		 * @param	itemData
		 * 
		 * @return
		 */
		public function addItem(itemData:Object):*
		{
			_data.push(itemData);
			_length++;
			
			var newEvent:DataProviderEvent = new DataProviderEvent(DataProviderEvent.ADD_ITEM_AT);
			newEvent.itemData = itemData;
			newEvent.index = _length;
			dispatchEvent(newEvent);
			
			return itemData;
		}
		
		/**
		 * 在指定位置添加一条
		 * 
		 * @param	itemData
		 * @param	index
		 * 
		 * @return 返回成功添加到数据，如果指定位置超出范围返回null
		 */
		public function addItemAt(itemData:Object, index:int):*
		{
			if (index >= 0 && index <= _length)
			{
				_data.splice(index, 0, itemData);
				_length++;
				
				var newEvent:DataProviderEvent = new DataProviderEvent(DataProviderEvent.ADD_ITEM_AT);
				newEvent.itemData = itemData;
				newEvent.index = index;
				dispatchEvent(newEvent);
				
				return itemData;
			}
			else
			{
				return null;
			}
		}
		
		/**
		 * 删除一条
		 * 
		 * @param	itemData
		 * 
		 * @return 返回成功删除的数据。如果没有找到指定的数据返回null
		 */
		public function removeItem(itemData:Object):*
		{
			var aItemData:Object;
			for (var i:int = 0; i < _length; i++) 
			{
				aItemData = _data[i];
				if (_itemDataCompareFunc(aItemData, itemData) == CompareUtil.EQUAL)
				{
					var spliceItemData:Object = _data.splice(i, 1)[0];
					_length--;
					
					var newEvent:DataProviderEvent = new DataProviderEvent(DataProviderEvent.REMOVE_ITEM_AT);
					newEvent.index = i;
					dispatchEvent(newEvent);
					
					return spliceItemData;
				}
			}
			
			return null;
		}
		
		/**
		 * 删除指定位置的一条数据
		 * 
		 * @param	index
		 * 
		 * @return 返回成功删除的数据。如果指定位置超出范围返回null
		 */
		public function removeItemAt(index:int):*
		{
			if (index >= 0 && index < _length)
			{
				var spliceItemData:Object = _data.splice(index, 1)[0];
				_length--;
				
				var newEvent:DataProviderEvent = new DataProviderEvent(DataProviderEvent.REMOVE_ITEM_AT);
				newEvent.index = index;
				dispatchEvent(newEvent);
				
				return spliceItemData;
			}
			else
			{
				return null;
			}
		}
		
		/**
		 * 在指定位置设置一条数据
		 * 
		 * @param	itemData
		 * @param	index
		 * 
		 * @return 返回成功设置的数据。如果指定位置超出范围返回null
		 */
		public function setItemAt(itemData:Object, index:int):*
		{
			if (index >= 0 && index < _length)
			{
				var origItemData:Object = _data[index];
				_data[index] = itemData;
				
				var newEvent:DataProviderEvent = new DataProviderEvent(DataProviderEvent.SET_ITEM_AT);
				newEvent.index = index;
				newEvent.itemData = itemData;
				dispatchEvent(newEvent);
				
				return origItemData;
			}
			else
			{
				return null;
			}
		}
		
		/**
		 * 获得指定位置的一条数据
		 * 
		 * @param	index
		 * 
		 * @return 返回指定位置的数据。如果指定位置超出范围返回null
		 */
		public function getItemAt(index:int):*
		{
			if (index >= 0 && index < _length)
			{
				return _data[index];
			}
			else
			{
				return null;
			}
		}
		
		/**
		 * 判断是否存在指定的数据
		 * 
		 * @param	itemData
		 * 
		 * @return
		 */
		public function hasItem(itemData:Object):Boolean
		{
			var aItemData:Object;
			for (var i:int = 0; i < _length; i++) 
			{
				aItemData = _data[i];
				if (_itemDataCompareFunc(aItemData, itemData) == CompareUtil.EQUAL)
				{
					return true;
				}
			}
			
			return false;
		}
		
		/**
		 * 对所有的数据进行排序
		 * 
		 * @param	fieldName
		 * @param	options
		 * 
		 * @return
		 */
		public function sortOn(fieldName:Object, options:Object = null):Array
		{
			var sortOnResult:Array = _data.sortOn(fieldName, options);
			var newEvent:DataProviderEvent = new DataProviderEvent(DataProviderEvent.SORT_ON);
			newEvent.data = _data;
			dispatchEvent(newEvent);
			
			return sortOnResult;
		}
		
		private function initializeData():void
		{
			_data = new Array();
		}
		
		private function destroyData():void
		{
			if (_data != null)
			{
				_length = 0;
				DestroyUtil.breakArray(_data);
				_data = null;
			}
		}
		
		//-------------------------------------------------------------------------------------
		// 实现 IDestroy 接口
		//-------------------------------------------------------------------------------------
		
		/**
		 * @inheritDoc
		 */
		public function destroy():void
		{
			destroyData();
		}
	}

}