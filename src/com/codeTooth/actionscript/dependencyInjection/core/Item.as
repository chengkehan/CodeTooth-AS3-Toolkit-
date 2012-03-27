package com.codeTooth.actionscript.dependencyInjection.core 
{
	import com.codeTooth.actionscript.lang.exceptions.NoSuchObjectException;
	import com.codeTooth.actionscript.lang.exceptions.NullPointerException;
	import com.codeTooth.actionscript.lang.utils.destroy.DestroyUtil;
	import com.codeTooth.actionscript.lang.utils.destroy.IDestroy;
	import com.codeTooth.actionscript.patterns.iterator.ArrayIterator;
	import com.codeTooth.actionscript.patterns.iterator.IIterator;
	
	/**
	 * @private
	 *  
	 * 注入项
	 */	
	internal class Item implements IDestroy
	{
		public static const CONSTRUCTOR_TYPE_NEW:String = "new";
		
		//注入id
		private var _id:String = null;
		
		//注入对象的类型
		private var _type:String = null;
		
		//构造类型
		//new构造类型将使用new操作符构造对象
		//其它类型的构造将使用相应的静态方法构造对象
		private var _constructorType:String = null;
		
		//是否是容器内单例
		private var _isSingle:Boolean = false;
		
		//是否重新注入
		//当是单例时有效
		private var _isReinject:Boolean = false;
		
		//构造参数
		//[object diObject, object diObject, object diObject]
		private var _constructorArguments:Array = null;
		
		//注入内容
		//[object Content, object Content, object Content]
		private var _contents:Array = null;
		
		public function Item()
		{
			
		}

		/**
		 * 注入id
		 * 
		 * @param id
		 */		
		public function set id(id:String):void
		{
			_id = id;
		}
		
		/**
		 * @private
		 */			
		public function get id():String
		{
			return _id;
		}
		
		/**
		 * 注入对象的类型
		 * 
		 * @param type
		 */		
		public function set type(type:String):void
		{
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
		 * 构造类型
		 */		
		public function set constructorType(constructorType:String):void
		{
			_constructorType = constructorType;
		}
		
		/**
		 * @private
		 */		
		public function get constructorType():String
		{
			return _constructorType;
		}
		
		/**
		 * 是否是容器内单例
		 */		
		public function set isSingle(bool:Boolean):void
		{
			_isSingle = bool;
		}
		
		/**
		 * @private
		 */		
		public function get isSingle():Boolean
		{
			return _isSingle;
		}
		
		/**
		 * 是否重新注入
		 */		
		public function set isReinject(bool:Boolean):void
		{
			_isReinject = bool;
		}
		
		/**
		 * @private
		 */		
		public function get isReinject():Boolean
		{
			return _isReinject;
		}
		
		/**
		 * 构造参数
		 * 
		 * @throws com.codeTooth.actionscript.lang.exceptions.NullPointerException
		 * 构造参数设置了null
		 */		
		public function set constructorArguments(constructorArguments:Array/*of DiObject*/):void
		{
			if(constructorArguments == null)
			{
				throw new NullPointerException("Null constructorArguments");
			}
			
			_constructorArguments = constructorArguments;
		}
		
		/**
		 * 获取构造参数迭代器
		 * 
		 * @throws com.codeTooth.actionscript.lang.exceptions.NoSuchObjectException 
		 * 当没有获取构造参数时获取构造参数
		 * 
		 * @return
		 */		
		public function constructorArgumentsIterator():IIterator
		{
			if(!hasConstructorArguments())
			{
				throw new NoSuchObjectException("No constructor arguments");
			}
			
			return new ArrayIterator(_constructorArguments);
		}
		
		/**
		 * 注入内容
		 * 
		 * @throws com.codeTooth.actionscript.lang.exceptions.NullPointerException 
		 * 注入内容设置了null
		 */		
		public function set contents(contents:Array/*of Content*/):void
		{
			if(contents == null)
			{
				throw new NullPointerException("Null content");
			}
			
			_contents = contents;
		}
		
		/**
		 * 获得注入内容迭代器
		 * 
		 * @throws com.codeTooth.actionscript.lang.exceptions.NoSuchObjectException
		 * 当没有注入内容时获取注入内容
		 * 
		 * @return
		 */		
		public function get contentsIterator():IIterator
		{
			if(!hasContents())
			{
				throw new NoSuchObjectException("No contents");
			}
			
			return new ArrayIterator(_contents);
		}
		
		/**
		 * 判断是否有构造参数
		 * 
		 * @return
		 */		
		public function hasConstructorArguments():Boolean
		{
			return _constructorArguments != null;
		}
		
		/**
		 * 判读是否有注入内容
		 * 
		 * @return
		 */		
		public function hasContents():Boolean
		{
			return _contents != null;
		}
		
		/**
		 * @inheritDoc
		 */		
		public function destroy():void
		{
			_id = null;
			_type = null;
			_constructorType = null;
			
			if(hasConstructorArguments())
			{
				DestroyUtil.destroyArray(_constructorArguments);
				_constructorArguments = null;
			}
			
			if(hasContents())
			{
				DestroyUtil.destroyArray(_contents);
				_contents = null;
			}
		}
		
		/**
		 * @inherit
		 */
		public function toString():String
		{
			return "[object Item(id:" + _id + ",type:" + _type + ",constructorType:" + _constructorType + 
											",isSingle:" + _isSingle + ",isReinject:" + _isReinject +  
											",constructorArguments:" + _constructorArguments + 
											",contents:" + _contents + ")]";
		}
	}
}