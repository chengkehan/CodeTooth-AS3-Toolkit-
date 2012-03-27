package com.codeTooth.actionscript.reflect.core
{		
	import com.codeTooth.actionscript.lang.utils.destroy.IDestroy;

	/**
	 * 存取器 
	 */

	public class Accessor implements IDestroy 
	{
		/**
		 * 只读
		 */		
		public static const READ_ONLY:String = "readOnly";
		
		/**
		 * 只写 
		 */		
		public static const WRITE_ONLY:String = "writeOnly";
		
		/**
		 * 可读可写
		 */		
		public static const READ_WRITE:String = "readWrite";
		
		//名称
		private var _name:String = null;
		
		//访问类型
		private var _access:String = null;
		
		//存取器类型
		private var _type:String = null;
		
		//声明存取器的类定义的类型
		private var _declaredByType:String = null;
		
		public function Accessor()
		{
			
		}
		
		/**
		 *存取器名称名称
		 */		
		public function get name():String
		{
			return _name;
		}
		
		/**
		 * 存取器访问类型（READ_ONLY || WRITE_ONLY || READ_WRITE）
		 */
		public function get access():String
		{
			return _access;
		}
		
		/**
		 * 存取器类型
		 */
		public function get type():String
		{
			return _type;
		}
		
		/**
		 * 存取器类定义
		 */
		public function get definition():Class
		{
			return Reflect.getDefinitionInternal(_type);
		}
		
		/**
		 * 声明存取器的类定义的类型
		 */
		public function get declaredByType():String
		{
			return _declaredByType;
		}
		
		/**
		 * 声明存取器的类定义
		 */
		public function get declaredByDefinition():Class
		{
			return Reflect.getDefinitionInternal(_declaredByType);
		}
		
		/**
		 * @inheritDoc
		 */		
		public function destroy():void
		{
			_name = null;
			_access = null;
			_type = null;
			_declaredByType = null;
		}
		
		/**
		 * @inheritDoc
		 */		
		public function toString():String
		{
			return "[object Accessor(name:" + _name + ",type:" + _type + ")]";
		}
		
		//设置名称
		internal function set nameInternal(name:String):void
		{
			_name = name;
		}
		
		//设置存取器访问类型
		internal function set accessInternal(access:String):void
		{
			_access = access;
		}
		
		//设置存取器类型
		internal function set typeInternal(type:String):void
		{
			_type = type;
		}
		
		//设置声明存取器的类定义的类型
		internal function set declaredByTypeInternal(declaredByType:String):void
		{
			_declaredByType = declaredByType;
		}
	}
}