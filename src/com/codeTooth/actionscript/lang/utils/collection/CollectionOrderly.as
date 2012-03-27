package com.codeTooth.actionscript.lang.utils.collection 
{
	import com.codeTooth.actionscript.core.codeTooth_internal;
	import com.codeTooth.actionscript.lang.utils.ArrayUtil;
	import com.codeTooth.actionscript.lang.utils.destroy.DestroyUtil;
	import com.codeTooth.actionscript.lang.utils.destroy.IDestroy;
	import com.codeTooth.actionscript.patterns.iterator.ArrayIterator;
	import com.codeTooth.actionscript.patterns.iterator.IIterator;
	
	/**
	 * 有序对象集合
	 */
	public class CollectionOrderly implements IDestroy
	{
		use namespace codeTooth_internal;
		
		// 存储对象
		protected var _items:Vector.<CollectionOrderlyItem> = null;
		
		// 长度
		protected var _length:int = 0;
		
		/**
		 * 构造函数
		 */
		public function CollectionOrderly() 
		{
			_items = new Vector.<CollectionOrderlyItem>();
		}
		
		/**
		 * @private
		 * 
		 * 获得收集对象的个数。
		 * 
		 * @return
		 */	
		codeTooth_internal function get length():int
		{
			return _length;
		}
		
		/**
		 * @private
		 * 
		 * 获得收集器值迭代器。
		 * 
		 * @return
		 */	
		codeTooth_internal function itemIterator():IIterator
		{
			var arr:Array = new Array();
			for each(var item:CollectionOrderlyItem in _items)
			{
				arr.push(item.data);
			}
			
			return new ArrayIterator(arr);
		}
		
		/**
		 * @private
		 * 
		 * 获得收集器键迭代器。
		 * 
		 * @return 
		 */
		codeTooth_internal function nameIterator():IIterator
		{
			var arr:Array = new Array();
			for each(var item:CollectionOrderlyItem in _items)
			{
				arr.push(item.name);
			}
			
			return new ArrayIterator(arr);
		}
		
		/**
		 * @private
		 * 
		 * 添加一个对象。如果存在同名的，将被覆盖。
		 * 
		 * @param name 名称。
		 * @param data 对象实例。
		 * 
		 * @return 
		 */	
		codeTooth_internal function addItem(name:Object, data:Object):*
		{
			var item:CollectionOrderlyItem = getItem(name);
			if (item == null)
			{
				_items.push(new CollectionOrderlyItem(name, data));
				_length++;
			}
			else
			{
				item.setData(data);
			}
			
			return data;
		}
		
		/**
		 * @private
		 * 
		 * 移除一个已添加的对象。
		 * 
		 * @param name 要删除对象的名称。
		 * 
		 * @return 返回被删除的对象。如果没有找到指定的对象，则返回null。
		 */
		codeTooth_internal function removeItem(name:Object):*
		{
			for (var i:int = 0; i < _length; i++)
			{
				if (_items[i].name == name)
				{
					var item:CollectionOrderlyItem = _items[i];
					_length--;
					_items.splice(i, 1);
					
					return item.data;
				}
			}
			
			return null;
		}
		
		/**
		 * 获得所有的元素。请勿修改集合
		 * 
		 * @return
		 */
		codeTooth_internal function getItems():Vector.<CollectionOrderlyItem>
		{
			return _items;
		}
		
		/**
		 * @private
		 * 
		 * 获得对象。
		 * 
		 * @param itemName 要获得的对象的名称。
		 * 
		 * @return 返回对象。如果没有找到指定的对象，则返回null。
		 */	
		codeTooth_internal function getItem(name:Object):*
		{
			for each(var item:CollectionOrderlyItem in _items)
			{
				if (item.name == name)
				{
					return item.data;
				}
			}
			
			return null;
		}
		
		/**
		 * @private
		 * 
		 * 判断是否存在相应的对象。
		 * 
		 * @param name 指定对象的名称。
		 * 
		 * @return
		 */	
		codeTooth_internal function containsItem(name:Object):Boolean
		{
			for each(var item:CollectionOrderlyItem in _items)
			{
				if (item.name == name)
				{
					return true;
				}
			}
			
			return false;
		}
		
		/**
		 * @private
		 * 
		 * 清空
		 * 
		 * @param
		 */
		codeTooth_internal function removeItems():void
		{
			DestroyUtil.breakVector(_items);
			_length = 0;
		}
		
		//-----------------------------------------------------------------------------------------------------------------------------------------------------------------------
		// 实现 IDestroy 接口
		//-----------------------------------------------------------------------------------------------------------------------------------------------------------------------
		
		/**
		 * @inheritDoc
		 */
		public function destroy():void
		{
			DestroyUtil.breakVector(_items);
			_items = null;
			_length = 0;
		}
	}

}