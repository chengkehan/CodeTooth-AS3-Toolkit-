package com.codeTooth.actionscript.lang.exceptions
{
	/**
	 * 指定的一个null
	 */
	
	public class NullPointerException extends Error 
	{
		public function NullPointerException(message:*=null, id:*=0)
		{
			super(message, id);
			name = "NullPointerException";
		}
	}
}