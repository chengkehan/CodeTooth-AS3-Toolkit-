package com.codeTooth.actionscript.lang.utils.clone
{
	/**
	 * 可以克隆对象实现的接口。
	 */	
	
	public interface ICloneable 
	{
		/**
		 * 克隆对象。
		 * 
		 * @return 返回当前对象的克隆。
		 */		
		function clone():*;
	}
}