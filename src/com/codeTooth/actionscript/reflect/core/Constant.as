package com.codeTooth.actionscript.reflect.core
{		
	import com.codeTooth.actionscript.lang.utils.destroy.IDestroy;
	
	/**
	 * 常量
	 */
	
	public class Constant implements IDestroy 
	{
		//常量名称
		private var _name:String = null;
		
		//常量类型
		private var _type:String = null;
		
		public function Constant()
		{
			
		}
		
		/**
		 * 常量名称
		 */		
		public function get name():String
		{
			return _name;
		}
		
		/**
		 * 常量类型
		 */		
		public function get type():String
		{
			return _type;
		}
		
		/**
		 * 常量类定义
		 */		
		public function get definition():Class
		{
			return Reflect.getDefinitionInternal(_type);
		}
		
		/**
		 * @inheritDoc
		 */		
		public function destroy():void
		{
			_name = null;
			_type = null;
		}
		
		/**
		 * @inheritDoc
		 */		
		public function toString():String
		{
			return "[object Constant(name:" + _name + ",type:" + _type + ")]";
		}
		
		internal function set nameInternal(name:String):void
		{
			_name = name;
		}
		
		internal function set typeInternal(type:String):void
		{
			_type = type;
		}
	}
}