package com.codeTooth.actionscript.patterns.iterator
{
	import com.codeTooth.actionscript.lang.exceptions.IllegalStateException;
	import com.codeTooth.actionscript.lang.exceptions.NoSuchObjectException;
	import com.codeTooth.actionscript.lang.exceptions.UnsupportedException;

	public class VectorIterator implements IIterator
	{
		private var _vector:Object = null;
		
		private var _cursor:uint = 0;
		
		private var _length:int = -1;
		
		private var _indexNext:int = -1;
		
		private var _allowRemove:Boolean = false;
		
		public function VectorIterator(vector:Object, allowRemove:Boolean = false)
		{
			_allowRemove = allowRemove;
			_vector = vector;
			_length = _vector == null ? 0 : _vector.length;
			_indexNext = -1;
		}
		
		public function hasNext():Boolean
		{
			_indexNext = -1;
			return _cursor < _length;
		}
		
		public function next():*
		{
			if(_cursor >= _length)
			{
				throw new NoSuchObjectException("Has not the element");
			}
			
			_indexNext = _cursor;
			return _vector[_cursor++];
		}
		
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
			
			_vector.splice(_indexNext, 1);
			_cursor = _indexNext;
			_length--;
			
			_indexNext = -1;
		}
		
		/**
		 * 获得Vector迭代器迭代的Vector的长度
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
		public function destroy():void
		{
			_vector = null;
		}
	}
}