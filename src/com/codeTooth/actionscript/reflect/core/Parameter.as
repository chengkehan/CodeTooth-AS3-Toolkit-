package com.codeTooth.actionscript.reflect.core
{
	import com.codeTooth.actionscript.lang.utils.destroy.IDestroy;

	/**
	 * 构造函数方法入参参数
	 */	
	
	public class Parameter implements IDestroy 
	{
		//类型
		private var _type:String = null;
		
		//是否是可选的
		private var _optional:Boolean = false;
		
		// 第几个参数
		private var _index:int;
		
		public function Parameter()
		{
			
		}
		
		/**
		 * 获得类型
		 */		
		public function get type():String
		{
			return _type;
		}
		
		/**
		 * 获得类定义
		 */
		public function get definition():Class
		{
			return Reflect.getDefinitionInternal(_type);
		}
		
		/**
		 * 获得是否是可选的
		 */		
		public function get optional():Boolean
		{
			return _optional;
		}
		
		/**
		 * 获得是第几个参数
		 */
		public function get index():int
		{
			return _index;
		}
		
		/**
		 * @inheritDoc
		 */		
		public function destroy():void
		{
			_type = null;
		}
		
		/**
		 * @inheritDoc
		 */		
		public function toString():String
		{
			return "[object Parameter(type:" + _type + ",optional:" + _optional + ")]";
		}
		
		//设置类型
		internal function set typeInternal(type:String):void
		{
			_type = type;
		}
		
		//设置是否是可选的
		internal function set optionalInternal(value:Boolean):void
		{
			_optional = value;
		}

		// 设置是第几个参数
		internal function set indexInternal(value:int):void
		{
			_index = value;
		}
	}
}