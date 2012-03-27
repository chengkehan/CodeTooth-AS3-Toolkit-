package com.codeTooth.actionscript.lang.utils
{		
	
	/**
	 * 构造函数动态传参。使构造函数拥有像普通函数一样的apply和call功能。
	 */
	
	public class DynamicConstruct 
	{
		/**
		 * 构造一个对象。可以看作是调用了构造函数的apply方法。
		 * 
		 * @param definition 创建对象的类定义。
		 * @param args 参数列表，默认的null或者长度为0的参数列表表示构造不需要参数列表。
		 * 
		 * @return 返回构造后的对象。如果definition是null，或者参数列表args的长度超过了9，那么将返回null。
		 */		
		public static function newApply(definition:Class, args:Array = null):Object
		{
			if (definition == null)
			{
				return null;
			}
			else
			{
				var numberArguments:int = args == null || args.length == 0 ? 0 : args.length;
				var object:Object = null;
				switch(numberArguments)
				{
					case 0:
						object = new definition();
						break;
					case 1:
						object = new definition(args[0]);
						break;
					case 2:
						object = new definition(args[0], args[1]);
						break;
					case 3:
						object = new definition(args[0], args[1], args[2]);
						break;
					case 4:
						object = new definition(args[0], args[1], args[2], args[3]);
						break;
					case 5:
						object = new definition(args[0], args[1], args[2], args[3], args[4]);
						break;
					case 6:
						object = new definition(args[0], args[1], args[2], args[3], args[4], args[5]);
						break;
					case 7:
						object = new definition(args[0], args[1], args[2], args[3], args[4], args[5], args[6]);
						break;
					case 8:
						object = new definition(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7]);
						break;
					case 9:
						object = new definition(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8]);
						break;
					default:
						// Do nothing
				}
				
				return object;
			}
		}
		
		/**
		 * 构造一个对象。可以看作是调用了构造函数的call方法。
		 * 
		 * @param definition 创建对象的类定义。
		 * @param args 参数列表。
		 * 
		 * @return 返回构造后的对象。如果definition是null，或者参数列表args的长度超过了9，那么将返回null。
		 */		
		public static function newCall(definition:Class, ...args):Object
		{
			return newApply(definition, args);
		}
	}
}