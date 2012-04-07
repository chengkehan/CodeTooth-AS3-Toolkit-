package com.codeTooth.actionscript.lang.utils.newUniqueObject
{
	/**
	 * 唯一标识。
	 */	
	
	public class UniqueID 
	{
		private static var _count:int = 0;
		
		/**
		 * 获得唯一标识。
		 * 
		 * @return
		 */		
		public static function getUniqueID():Number
		{
			return new Date().time + (++_count);
		}
	}
}