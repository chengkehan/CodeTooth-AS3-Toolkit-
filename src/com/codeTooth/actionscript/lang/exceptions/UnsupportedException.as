package com.codeTooth.actionscript.lang.exceptions 
{
	/**
	 * 调用了不支持的方法 
	 */
	public class UnsupportedException extends Error
	{
		
		public function UnsupportedException(message:* = null, id:* = 0) 
		{
			super(message, id);
			name = "UnsupportedException";
		}
		
	}

}