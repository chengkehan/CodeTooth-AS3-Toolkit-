package com.codeTooth.actionscript.patterns.iterator
{
	import com.codeTooth.actionscript.lang.utils.destroy.IDestroy;

	/**
	 * 迭代器接口。
	 */
	
	public interface IIterator extends IDestroy
	{
		/**
		 * 判断迭代器中是否还有下一个元素。
		 * 
		 * @return
		 */		
		function hasNext():Boolean;
		
		/**
		 * 获得迭代器中的下一个元素
		 * 
		 * @throws com.codeTooth.actionscript.lang.exceptions.NoSuchObjectException 
		 * 迭代器中已经没有下一个元素
		 * 
		 * @return
		 */		
		function next():*;
		
		/**
		 * 删除当前的next返回的那个元素
		 * 
		 * @throws com.codeTooth.actionscript.lang.exceptions.IllegalStateException 
		 * 调用这个方法需要在调用next方法之后
		 * @thorws com.codeTooth.actionscript.lang.exceptions.UnsupportedException 
		 * 不支持这个方法
		 */
		function remove():void;
		
		/**
		 * 数据的数量
		 * 
		 * @return 
		 */
		function get length():int;
	}
}