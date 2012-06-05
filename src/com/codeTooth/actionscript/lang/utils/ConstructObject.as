package com.codeTooth.actionscript.lang.utils
{
	import com.codeTooth.actionscript.lang.exceptions.IllegalParameterException;

	public class ConstructObject
	{
		public static function newConstructorApply(type:Class, args:Array):*
		{
			if(args == null)
			{
				return new type();
			}
			else
			{
				var obj:Object = null;
				switch(args.length)
				{
					case 0:
						obj = new type();
						break;
					case 1:
						obj = new type(args[0]);
						break;
					case 2:
						obj = new type(args[0], args[1]);
						break;
					case 3:
						obj = new type(args[0], args[1], args[2]);
						break;
					case 4:
						obj = new type(args[0], args[1], args[2], args[3]);
						break;
					case 5:
						obj = new type(args[0], args[1], args[2], args[3], args[4]);
						break;
					case 6:
						obj = new type(args[0], args[1], args[2], args[3], args[4], args[5]);
						break;
					case 7:
						obj = new type(args[0], args[1], args[2], args[3], args[4], args[5], args[6]);
						break;
					case 8:
						obj = new type(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7]);
						break;
					case 9:
						obj = new type(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8]);
						break;
					default:
						throw new IllegalParameterException("Illegal length of constructor arguments " + "\"" + args.length + "\", max length can be 9.");
				}
				return obj;
			}
		}
		
		public static function newConstructorCall(type:Class, ...args):*
		{
			return newConstructorApply(type, args);
		}
	}
}