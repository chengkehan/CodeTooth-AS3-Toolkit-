package com.codeTooth.actionscript.lang.utils.collection
{		
	import com.codeTooth.actionscript.core.codeTooth_internal;
	import com.codeTooth.actionscript.lang.utils.ArrayUtil;
	import com.codeTooth.actionscript.lang.utils.destroy.DestroyUtil;
	import com.codeTooth.actionscript.lang.utils.destroy.IDestroy;
	import com.codeTooth.actionscript.patterns.iterator.IIterator;
	
	import flash.utils.Dictionary;
	
	/** 
	 *  无序对象集合。
	 */
	public class Collection implements IDestroy
	{
		use namespace codeTooth_internal;
		
		//存储所有收集的对象
		protected var _items:Dictionary = null;
		
		//收集的对象的数量
		private var _length:int = 0;
		
		public function Collection()
		{
			_items = new Dictionary();
			_length = 0;
		}
		
		/**
		 * @inheritDoc
		 */		
		public function destroy():void
		{
			if (_items != null)
			{
				DestroyUtil.breakMap(_items);
				_items = null;
				_length = 0;
			}
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
			return ArrayUtil.getValuesIteratorOfMap(_items);
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
			return ArrayUtil.getKeysIteratorOfMap(_items);
		}
		
		/**
		 * @private
		 * 
		 * 添加一个对象。如果存在同名的，将被覆盖。
		 * 
		 * @param itemName 名称。
		 * @param item 对象实例。
		 * 
		 * @return 
		 */		
		codeTooth_internal function addItem(itemName:Object, item:Object):*
		{	
			if(_items[itemName] == undefined)
			{
				_length++;
			}
			
			_items[itemName] = item;
			
			return item;
		}
		
		/**
		 * @private
		 * 
		 * 移除一个已添加的对象。
		 * 
		 * @param itemName 要删除对象的名称。
		 * 
		 * @return 返回被删除的对象。如果没有找到指定的对象，则返回null。
		 */		
		codeTooth_internal function removeItem(itemName:Object):*
		{
			var item:Object = null;
			if (_items[itemName] != undefined)
			{
				item = _items[itemName];
				delete _items[itemName];
				_length--;
			}
			
			return item;
		}
		
		/**
		 * 获得所有的元素。请勿修改集合
		 * 
		 * @return
		 */
		codeTooth_internal function getItems():Dictionary
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
		codeTooth_internal function getItem(itemName:Object):*
		{
			return _items[itemName];
		}
		
		/**
		 * @private
		 * 
		 * 判断是否存在相应的对象。
		 * 
		 * @param itemName 指定对象的名称。
		 * 
		 * @return
		 */		
		codeTooth_internal function containsItem(itemName:Object):Boolean
		{
			return _items[itemName] != undefined;
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
			DestroyUtil.breakMap(_items);
			_length = 0;
		}
	}
}