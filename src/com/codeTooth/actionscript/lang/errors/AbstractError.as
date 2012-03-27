package com.codeTooth.actionscript.lang.errors
{
	/**
	 * 抽象错误
	 */	
	
	public class AbstractError extends Error 
	{
		public function AbstractError(message:String=null, id:int=0)
		{
			super(message, id);
			name = "AbstractError";
		}
		
	}
}