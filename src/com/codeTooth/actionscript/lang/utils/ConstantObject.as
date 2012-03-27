package com.codeTooth.actionscript.lang.utils 
{
	import com.codeTooth.actionscript.lang.exceptions.IllegalOperationException;
	
	/**
	 * 常量对象。以对象形式来创建常量。子类继承
	 */
	public class ConstantObject 
	{
		private static var _allowInstance:Boolean = false;
		
		private var _type:Object = null;
		
		/**
		 * 创建常量对象
		 * 
		 * @param	type	字符串表示形式
		 * @param	definition	类定义
		 * 
		 * @return	返回创建的常量对象
		 */
		protected static function createInstance(type:Object = null, definition:Class = null):*
		{
			_allowInstance = true;
			var instance:ConstantObject = definition == null ? new ConstantObject() : new definition();
			instance._type = type;
			_allowInstance = false;
			
			return instance;
		}
		
		/**
		 * @private
		 */
		public function ConstantObject()
		{
			if (!_allowInstance)
			{
				throw new IllegalOperationException("Cannot createInstance");
			}
		}
		
		public function valueOf():Object
		{
			return _type;
		}
		
		public function toString():String
		{
			return "[object ConstantObject(type:" + _type + ")]";
		}
		
	}

}