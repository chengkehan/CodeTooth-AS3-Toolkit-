package com.codeTooth.actionscript.lang.exceptions 
{
	/**
	 * 带有数据对象的异常
	 */
	public class DataException extends Error 
	{
		public var data:* = null;
		
		public function DataException(message:* = null, data:Object = null, id:* = 0) 
		{
			super(message, id);
			this.data = data;
		}
		
	}

}