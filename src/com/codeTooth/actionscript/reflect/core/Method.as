package com.codeTooth.actionscript.reflect.core
{	
	import com.codeTooth.actionscript.lang.exceptions.NullPointerException;
	import com.codeTooth.actionscript.lang.utils.destroy.DestroyUtil;
	import com.codeTooth.actionscript.lang.utils.destroy.IDestroy;
	import com.codeTooth.actionscript.patterns.iterator.ArrayIterator;
	import com.codeTooth.actionscript.patterns.iterator.IIterator;

	/**
	 * 方法 
	 */

	public class Method implements IDestroy 
	{	
		//名称
		private var _name:String = null;
		
		//声明方法的类定义的类型
		private var _declaredByType:String = null;
		
		//返回值类型
		private var _returnType:String = null;
		
		//方法入参
		private var _parameters:Array = null;
		
		public function Method()
		{
			_parameters = new Array();
		}
		
		/**
		 * 方法的名称
		 *  
		 * @return
		 */		
		public function get name():String
		{
			return _name;
		}
		
		/**
		 * 声明此方法的类定义的类型
		 * 
		 * @return
		 */		
		public function get declaredByType():String
		{
			return _declaredByType;
		}
		
		/**
		 * 声明此方法的类定义
		 * 
		 * @return
		 */
		public function get declaredByDefinition():Class
		{
			return Reflect.getDefinitionInternal(_declaredByType);
		}
		
		/**
		 * 返回值的类型
		 * 
		 * @return
		 */		
		public function get returnType():String
		{
			return _returnType;
		}
		
		/**
		 * 返回值的类定义
		 * 
		 * @return
		 */
		public function get returnDefinition():Class
		{
			return Reflect.getDefinitionInternal(_returnType);
		}
		
		/**
		 * 获得入参的迭代器
		 * 
		 * @return
		 */		
		public function parametersIterator():IIterator
		{	
			if(hasParameters())
			{
				return new ArrayIterator(_parameters);
			}
			else
			{
				return null;
			}
		}
		
		/**
		 * 方法是否有参数
		 */
		public function hasParameters():Boolean
		{
			return _parameters != null;
		}
		
		/**
		 * @inheritDoc
		 */		
		public function destroy():void
		{
			if(_parameters != null)
			{
				DestroyUtil.breakArray(_parameters);
				_parameters = null;
			}
			
			_returnType = null;
			_name = null;
		}
		
		/**
		 * @inheritDoc
		 */		
		public function toString():String
		{
			return "[object Method(name:" + _name + ")]";
		}
		
		//设置方法的名称
		internal function set nameInternal(name:String):void
		{
			_name = name;
		}
		
		//设置声明此方法的类定义的类型
		internal function set declaredByTypeInternal(declaredByType:String):void
		{
			_declaredByType = declaredByType;
		}
		
		//设置返回值的类型
		internal function set returnTypeInternal(returnType:String):void
		{
			_returnType = returnType;
		}
		
		//设置入参
		internal function set parametersInternal(parameters:Array):void
		{	
			_parameters = parameters;
		}
	}
}