package com.codeTooth.actionscript.lang.exceptions
{
	/**
	 * 调用了非法的方法
	 */
	
	public class IllegalOperationException extends Error 
	{
		public function IllegalOperationException(message:*=null, id:*=0)
		{
			super(message, id);
			name = "IllegalOperationException";
		}
	}
}