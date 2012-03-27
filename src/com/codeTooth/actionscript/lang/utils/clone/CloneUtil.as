package com.codeTooth.actionscript.lang.utils.clone
{
	import com.codeTooth.actionscript.lang.utils.clone.ICloneable;
	
	import flash.utils.ByteArray;
	
	/**
	 * 克隆对象助手。
	 */	
	public class CloneUtil 
	{
		/**
		 * 把srcObj的动态属性赋给dstObj。
		 * 
		 * @param	srcObj
		 * @param	dstObj
		 * 
		 * @return 返回dstObj。如果如参有一个是null，则返回null
		 */
		public static function copyDynamicObject(srcObj:Object, dstObj:Object):*
		{
			if (srcObj == null || dstObj == null)
			{
				return null;
			}
			else
			{
				for(var pName:Object in srcObj)
				{
					dstObj[pName] = srcObj[pName];
				}
				
				return dstObj;
			}
		}
		
		/**
		 * 浅克隆一个对象。
		 * 如果对象中存储的不是简单数据类型，将直接复制引用。
		 * 如果传入的对象实现了ICloneabl接口，将直接返回ICloneable的clone方法的返回值
		 * 
		 * @param srcObj 要进行克隆的对象
		 * 
		 * @return 返回结果对象。如果入参是null，则返回null。
		 */		
		public static function shallowClone(srcObj:Object):*
		{
			if (srcObj == null)
			{
				return null;
			}
			else
			{
				if(srcObj is ICloneable)
				{
					return ICloneable(srcObj).clone();
				}
				else
				{
					var object:Object = new Object();
					
					for(var pName:Object in srcObj)
					{
						if (srcObj[pName] is ICloneable)
						{
							object[pName] = ICloneable(srcObj[pName]).clone();
						}
						else
						{
							object[pName] = srcObj[pName];
						}
					}
					
					return object;
				}
			}
		}
		
		/**
		 * 深克隆一个对象，将对传入的对象使用ByteArray做一个完全一样的拷贝，并且对结果对象的操作不会影响到原对象。
		 * 如果传入的对象实现了ICloneabl接口，将直接返回ICloneable的clone方法的返回值。
		 * 
		 * @param srcObj 要进行克隆的对象
		 * 
		 * @return 返回结果对象。如果入参是null，则返回null。
		 */		
		public static function deepClone(srcObj:Object):*
		{
			if (srcObj == null)
			{
				return null;
			}
			else
			{
				if(srcObj is ICloneable)
				{
					return ICloneable(srcObj).clone();
				}
				else
				{
					var byteArray:ByteArray = new ByteArray();
					byteArray.writeObject(srcObj);
					byteArray.position = 0;
					
					return byteArray.readObject();
				}
			}
		}
	}
}