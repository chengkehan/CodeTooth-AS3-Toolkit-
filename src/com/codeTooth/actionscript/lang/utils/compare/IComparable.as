package com.codeTooth.actionscript.lang.utils.compare 
{
	/**
	 * 可比较对象实现的接口
	 */
	public interface IComparable 
	{
		/**
		 * 比较两个对象
		 * 
		 * @param	destObj 目标对象
		 * 
		 * @return 大于目标对象返回CompareUtil.LARGER_THAN，
		 * 等于目标对象返回CompareUtil.EQUAL，
		 * 小于目标对象返回CompareUtil.LESS_THAN，
		 * 如果只是表示不相等返回CompareUtil.NOT_EQUAL，
		 * 无法比较返回CompareUtil.COMPARE_FAILURE
		 * 
		 * @see com.codeTooth.actionscript.lang.utils.compare.CompareUtil
		 */
		function compare(destObj:Object):int;
	}
	
}