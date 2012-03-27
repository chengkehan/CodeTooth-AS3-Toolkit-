package com.codeTooth.actionscript.dependencyInjection.core 
{
	import com.codeTooth.actionscript.lang.exceptions.IllegalParameterException;
	import com.codeTooth.actionscript.lang.exceptions.NoSuchObjectException;
	import com.codeTooth.actionscript.lang.exceptions.NullPointerException;
	import com.codeTooth.actionscript.lang.utils.destroy.DestroyUtil;
	import com.codeTooth.actionscript.lang.utils.destroy.IDestroy;
	import com.codeTooth.actionscript.patterns.iterator.ArrayIterator;
	import com.codeTooth.actionscript.patterns.iterator.IIterator;
	
	/**
	 * @private
	 * 
	 * 注入对象
	 */
	
	internal class DiObject implements IDestroy
	{
		/**
		 * 字符串类型
		 */		
		public static const STRING:String = "string";
		
		/**
		 * 数字类型
		 */		
		public static const NUMBER:String = "number";
		
		/**
		 * 属性类型
		 */		
		public static const PROPERTY1:String = "property1";
		public static const PROPERTY2:String = "property2";
		
		/**
		 * 方法类型
		 */		
		public static const METHOD:String = "method";
		
		//注入对象的类型
		private var _type:String = null;
		
		//注入的内容
		private var _content:String = null;
		
		//子注入项
		private var _children:Array/*of DiObject*/ = null;
		
		public function DiObject()
		{
			
		}
		
		/**
		 * 设置注入对象的类型
		 * 
		 * @param type
		 * 
		 * @throws com.codeTooth.actionscript.lang.exceptions.IllegalParameterException
		 * 设置非法的注入对象的类型
		 */		
		public function set type(type:String):void
		{
			if(type != STRING && type != NUMBER && type != PROPERTY1 && type != PROPERTY2 && type != METHOD)
			{
				throw new IllegalParameterException("Illegal type \"" + type + "\"");
			}
			
			_type = type;
		}
		
		/**
		 * @private
		 */		
		public function get type():String
		{
			return _type;
		}
		
		/**
		 * 注入内容
		 * 
		 * @param content
		 */		
		public function set content(content:String):void
		{
			_content = content;
		}
		
		/**
		 * @private
		 */		
		public function get content():String
		{
			return _content
		}
		
		/**
		 * 设置子注入项
		 * 
		 * @param children
		 * 
		 * @throws com.codeTooth.actionscript.lang.exceptions.NullPointerException
		 * 入参是null
		 */		
		public function set children(children:Array/*of DiObject*/):void
		{
			if(children == null)
			{
				throw new NullPointerException("Null children");
			}
			
			_children = children;
		}
		
		/**
		 * 获得子注入项迭代器
		 * 
		 * @throws com.codeTooth.actionscript.lang.exceptions.NoSuchObjectException 
		 * 不存在注入子项
		 * 
		 */		
		public function childrenIterator():IIterator/*of DiObject*/
		{
			if(!hasChildren())
			{
				throw new NoSuchObjectException("No children");
			}
			
			return new ArrayIterator(_children);
		}
		
		/**
		 * 判断是否有子注入项
		 * 
		 * @return
		 */		
		public function hasChildren():Boolean
		{
			return _children != null;
		}
		
		/**
		 * @inheritDoc
		 */		
		public function destroy():void
		{
			_type = null;
			_content = null;
			
			if(hasChildren())
			{
				DestroyUtil.destroyArray(_children);
				_children = null;
			}
		}
		
		/**
		 * @inherit
		 */		
		public function toString():String
		{
			return "[object DiObject(type:" + _type + ",content:" + _content + ",children:" + _children + ")]";
		}
	}
}