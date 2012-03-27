package com.codeTooth.actionscript.reflect.core
{
	import com.codeTooth.actionscript.lang.utils.destroy.IDestroy;
	
	/**
	 * 变量
	 */
	public class Variable implements IDestroy 
	{
		//变量的名称
		private var _name:String = null;
		
		//变量的类型
		private var _type:String = null;
		
		public function Variable()
		{
			
		}
		
		/**
		 * 变量的名称
		 * 
		 * @return
		 */		
		public function get name():String
		{
			return _name;
		}
		
		/**
		 * 变量的类型
		 * 
		 * @return
		 */		
		public function get type():String
		{
			return _type;
		}
		
		/**
		 * 变量类型的类定义
		 * 
		 * @return
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
			return "[object Variable(name:" + _name + ",type:" + _type + ")]"; 
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