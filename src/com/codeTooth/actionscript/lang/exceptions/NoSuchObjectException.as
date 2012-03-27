package com.codeTooth.actionscript.lang.exceptions
{
	/**
	 * 没有找到指定的元素
	 */
	
	public class NoSuchObjectException extends Error 
	{
		public function NoSuchObjectException(message:*=null, id:*=0)
		{
			super(message, id);
			name = "NoSuchObjectException";
		}
	}
}