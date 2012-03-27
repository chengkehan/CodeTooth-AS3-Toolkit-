package com.codeTooth.actionscript.lang.utils.compare 
{
	/**
	 * 比较对象助手
	 */
	public class CompareUtil
	{
		/**
		 * 相等
		 */
		public static const EQUAL:int = 0;
		
		/**
		 * 不相等
		 */
		public static const NOT_EQUAL:int = 2;
		
		/**
		 * 大于
		 */
		public static const LARGER_THAN:int = 1;
		
		/**
		 * 小于
		 */
		public static const LESS_THAN:int = -1;
		
		/**
		 * 无法比较
		 */
		public static const COMPARE_FAILURE:int = -2;
		
		/**
		 * 比较两个动态对象
		 * 
		 * @param	srcObj 源对象
		 * @param	destObj 目标对象
		 * 
		 * @return	相等返回EQUAL，
		 * 源对象是null返回LESS_THAN，
		 * 目标对象是null返回LARGER_THAN，
		 * 不相等返回非EQUAL
		 */
		public static function compareDynamicObject(srcObj:Object, destObj:Object):int
		{
			if (srcObj == destObj)
			{
				return EQUAL;
			}
			else if (srcObj == null)
			{
				return LESS_THAN;
			}
			else if (destObj == null)
			{
				return LARGER_THAN;
			}
			else
			{
				for (var pName:Object in srcObj)
				{
					if (srcObj[pName] != destObj[pName])
					{
						if (srcObj[pName] == null)
						{
							return LESS_THAN;
						}
						else if (destObj[pName] == null)
						{
							return LARGER_THAN;
						}
						else
						{
							return srcObj[pName] > destObj[pName] ? LARGER_THAN : LESS_THAN;
						}
						
						break;
					}
				}
				
				return EQUAL;
			}
		}
		
		/**
		 * 比较两个对象
		 * 
		 * @param	srcObj 源对象
		 * @param	destObj 目标对象
		 * 
		 * @return	相等返回EQUAL，
		 * 源对象是null返回LESS_THAN，
		 * 目标对象是null返回LARGER_THAN。
		 * 如果有一个是实现了IComparable接口，使用接口方法进行比较，
		 * 都没有实现IComparable接口，返回COMPARE_FAILURE
		 */
		public static function compareObject(srcObj:Object, destObj:Object):int
		{
			if (srcObj == destObj)
			{
				return EQUAL;
			}
			else if(srcObj == null)
			{
				return LESS_THAN;
			}
			else if (destObj == null)
			{
				return LARGER_THAN;
			}
			else
			{
				if (srcObj is IComparable)
				{
					return IComparable(srcObj).compare(destObj);
				}
				else if (destObj is IComparable)
				{
					return IComparable(destObj).compare(srcObj);
				}
				else
				{
					return COMPARE_FAILURE;
				}
			}
		}
	}

}