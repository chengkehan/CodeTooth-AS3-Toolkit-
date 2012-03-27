package com.codeTooth.actionscript.lang.utils 
{
	import com.codeTooth.actionscript.lang.exceptions.IllegalParameterException;
	import com.codeTooth.actionscript.lang.exceptions.NullPointerException;
	
	/**
	 * 断言。
	 */
	public class Assert 
	{
		public static var switchOn:Boolean = true;
		
		/**
		 * 判断如果是null，则直接抛出异常。
		 * 
		 * @param	...args
		 */
		public static function checkNull(...args):void
		{
			if(!switchOn)
			{
				return;
			}
			
			for each(var arg:Object in args)
			{
				if (arg == null)
				{
					throw new NullPointerException("Null object");
				}
			}
		}
		
		public static function checkNotNull(...args):void
		{
			if(!switchOn)
			{
				return;
			}
			
			for each(var arg:Object in args)
			{
				if (arg != null)
				{
					throw new NullPointerException("Not null object");
				}
			}
		}
		
		public static function checkTrue(bool:Boolean):void
		{
			if(!switchOn)
			{
				return;
			}
			
			if(bool)
			{
				throw new IllegalParameterException("Assert is true");
			}
		}
		
		public static function checkFalse(bool:Boolean):void
		{
			if(!switchOn)
			{
				return;
			}
			
			if(!bool)
			{
				throw new IllegalParameterException("Assert is false");
			}
		}
	}

}