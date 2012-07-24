package com.codeTooth.actionscript.adt.collection
{
	import com.codeTooth.actionscript.lang.utils.Common;
	import com.codeTooth.actionscript.lang.utils.destroy.IDestroy;
	import com.codeTooth.actionscript.lang.exceptions.NoSuchObjectException;

	/**
	 * 链表
	 */
	public class LinkedList implements IDestroy
	{
		// 头
		private var _head:Node = null;
		
		// 尾
		private var _tail:Node = null;
		
		// 长度
		private var _length:int = 0;
		
		public function LinkedList()
		{
			_head = new Node();
			_tail = new Node();
			_head.next = _tail;
			_tail.prev = _head;
		}
		
		public function isEmpty():Boolean
		{
			return _length == 0;
		}
		
		public function get length():int
		{
			return _length;
		}
		
		/**
		 * 向最后追加一个元素
		 * 
		 * @param value
		 */
		public function push(value:Object):void
		{
			var node:Node = new Node(_tail, _tail.prev, value);
			node.prev.next = node;
			node.next.prev = node;
			++_length;
		}
		
		/**
		 * 删除第一个元素并返回这个被删除的元素
		 * 
		 * @return 
		 */
		public function shift():*
		{
			if(isEmpty())
			{
				throw new NoSuchObjectException("Empty LinkedList.");
			}
			
			var node:Node = _head.next;
			var value:Object = node.value;
			_head.next = node.next;
			_head.next.prev = _head;
			node.destroy();
			--_length;
			
			return value;
		}
		
		public function destroy():void
		{
			var node:Node = _head;
			var next:Node = null;
			while(node != null)
			{
				next = node.next;
				node.destroy();
				node = next;
			}
			_length = 0;
			_head = null;
			_tail = null;
		}
		
		public function toString():String
		{
			var str:String = Common.EMPTY_STRING;
			var node:Node = _head;
			while(node != null)
			{
				if(node == _head)
				{
					str += "LinkedList Head -> "
				}
				else if(node == _tail)
				{
					str += "LinkedList Tail."
				}
				else
				{
					str += node.value + " -> ";
				}
				node = node.next;
			}
			
			return str;
		}
	}
}


import com.codeTooth.actionscript.lang.utils.destroy.IDestroy;

class Node implements IDestroy
{
	public var next:Node = null;
	
	public var prev:Node = null;
	
	public var value:Object = null;
	
	public function Node(next:Node = null, prev:Node = null, value:Object = null)
	{
		this.next = next;
		this.prev = prev;
		this.value = value;
	}
	
	public function destroy():void
	{
		next = null;
		prev = null;
		value = null;
	}
}