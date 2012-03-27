package com.codeTooth.actionscript.patterns.iterator
{
	import com.codeTooth.actionscript.lang.exceptions.IllegalStateException;
	import com.codeTooth.actionscript.lang.exceptions.NoSuchObjectException;
	import com.codeTooth.actionscript.lang.exceptions.NullPointerException;
	import com.codeTooth.actionscript.lang.exceptions.UnsupportedException;
	
	/**
	 * 数组迭代器 
	 */
	
	public class ArrayIterator implements IIterator
	{
		//指定的数组
		private var _array:Array = null;
		
		//迭代器光标位置
		private var _cursor:uint = 0;
		
		private var _length:int = -1;
		
		// 调用next方法时的索引
		private var _indexNext:int = -1;
		
		private var _allowRemove:Boolean = false;
		
		/**
		 * 构造函数
		 * 
		 * @param array 指定的数组 。如果入参是null，表示一个空数组。
		 */		
		public function ArrayIterator(array:Array = null, allowRemove:Boolean = false)
		{
			_allowRemove = allowRemove;
			_array = array;
			_length = _array == null ? 0 : _array.length;
			_indexNext = -1;
		}
		
		/**
		 * @inheritDoc
		 */
		public function hasNext():Boolean
		{
			_indexNext = -1;
			return _cursor < _length;
		}
		
		/**
		 * @inheritDoc
		 */
		public function next():*
		{
			if(_cursor >= _length)
			{
				throw new NoSuchObjectException("Has not the element");
			}
			
			_indexNext = _cursor;
			return _array[_cursor++];
		}
		
		/**
		 * @inheritDoc
		 */
		public function destroy():void
		{
			_array = null;
		}
		
		/**
		 * 获得数组迭代器迭代的数组的长度
		 *  
		 * @return
		 */		
		public function get length():int
		{
			return _length;
		}
		
		/**
		 * @inheritDoc
		 */
		public function remove():void
		{
			if(!_allowRemove)
			{
				throw new UnsupportedException("Unsupport this function");
			}
			
			if(_indexNext == -1)
			{
				throw new IllegalStateException("Please incoke remove after next.");
			}
			
			_array.splice(_indexNext, 1);
			_cursor = _indexNext;
			_length--;
			
			_indexNext = -1;
		}
		
		/**
		 * 获得迭代的数组的一个浅拷贝
		 * 
		 * @return
		 */		
		public function toArray():Array
		{
			var array:Array = new Array();
			for each(var item:Object in _array)
			{
				array.push(item);
			}
			
			return array;
		}
	}
}