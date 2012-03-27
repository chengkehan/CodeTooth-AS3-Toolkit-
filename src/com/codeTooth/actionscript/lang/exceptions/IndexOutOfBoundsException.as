package com.codeTooth.actionscript.lang.exceptions
{
	/**
	 * 提供的索引超出了范围
	 */	
	
	public class IndexOutOfBoundsException extends Error 
	{
		public function IndexOutOfBoundsException(message:String=null, id:int=0)
		{
			super(message, id);
			name = "IndexOutOfBoundsException";
		}
		
	}
}