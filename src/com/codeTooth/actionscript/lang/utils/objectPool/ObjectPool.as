package com.codeTooth.actionscript.lang.utils.objectPool
{	
	import com.codeTooth.actionscript.lang.exceptions.IllegalOperationException;
	import com.codeTooth.actionscript.lang.exceptions.IllegalParameterException;
	import com.codeTooth.actionscript.lang.exceptions.NullPointerException;
	import com.codeTooth.actionscript.lang.exceptions.UnknownTypeException;
	import com.codeTooth.actionscript.lang.utils.DynamicConstruct;
	import com.codeTooth.actionscript.lang.utils.destroy.DestroyUtil;
	import com.codeTooth.actionscript.lang.utils.destroy.IDestroy;
	import com.codeTooth.actionscript.patterns.iterator.ArrayIterator;
	import com.codeTooth.actionscript.patterns.iterator.IIterator; 
	
	/**
	 * 对象池，目的是为了复用对象，避免昂贵的创建对象开销。
	 */
	
	public class ObjectPool implements IDestroy
	{
		//存放复用对象实例的容器
		private var _container:Array = null;
		
		//对象池中存储的对象类型
		private var _definition:Class = null;
		
		//容量
		private var _capability:uint = 0;
		
		//池溢出警告
		private var _overflowExceptionTurnOn:Boolean = false;
		
		//空池警告
		private var _emptyExceptionTurnOn:Boolean = false;
		
		// 强类型
		private var _stronglyTyped:Boolean = true;
		
		/**
		 * 构造函数，创建一个对象池
		 * 
		 * @param definition 对象池存储的对象类型。必须指定一个存储类型，以便在池空的情况下能创建对象。
		 * @param capability 容量，最大可复用对象的个数。必须大于0。
		 * @param overflowExceptionTurnOn 是否开启对象池溢出警告，
		 * 开启此设置后，当向池中放入超过池容量的可重用对象时，会抛出异常
		 * @param emptyExceptionTurnOn 是否开启空池异常，
		 * 开启此设置后，如果池中没有可重用对象，将抛出异常，
		 * 未开启此设置时，如果池中没有可重用对象，则会创建一个新的对象返回。
		 * @param stronglyType 是否使用强类型。使用了强类型的对象池，只能容纳一种类型的对象。
		 * 
		 * @throws com.codeTooth.actionscript.lang.exceptions.NullPointerException 
		 * 指定的池存储类型是null。
		 * @throws com.codeTooth.actionscript.lang.exceptions.IllegalParameterException 
		 * 指定的对象池容量小于0。
		 */		
		public function ObjectPool(definition:Class, capability:int, 
											 overflowExceptionTurnOn:Boolean = false,
											 emptyExceptionTurnOn:Boolean = false,
											 stronglyTyped:Boolean = true)
		{
			if(definition == null)
			{
				throw new NullPointerException("Null definition");
			}
			
			if(capability < 0)
			{
				throw new IllegalParameterException("Object pool's Capability is \"" + capability + "\", less than 0");
			}
			
			_capability = capability;
			_definition = definition;
			_overflowExceptionTurnOn = overflowExceptionTurnOn;
			_emptyExceptionTurnOn = emptyExceptionTurnOn;
			_stronglyTyped = stronglyTyped;
			_container = new Array();
		}
		
		/**
		 * 获得对象池的容量
		 * 
		 * @return
		 */		
		public function get capability():int
		{
			return _capability;
		}
		
		/**
		 * 对象池是否使用强类型
		 */
		public function get stronglyTyped():Boolean
		{
			return _stronglyTyped;
		}
		
		/**
		 * 获得对象池中可复用对象的数量
		 * 
		 * @return 
		 */		
		public function get numberObjects():int
		{
			return _container.length;
		}
		
		/**
		 * 判断对象池是否开启了溢出异常
		 * 
		 * @return 
		 */		
		public function get overflowExceptionTurnOn():Boolean
		{
			return _overflowExceptionTurnOn;
		}
		
		/**
		 * 判断对象池是否开启了空池异常
		 * 
		 * @return 
		 */		
		public function get emptyExceptionTurnOn():Boolean
		{
			return _emptyExceptionTurnOn;
		}
		
		/**
		 * 获得对象池中所有的对象
		 * 
		 * @return 
		 */		
		public function reuseableIterator():IIterator
		{
			return new ArrayIterator(_container);
		}
		
		/**
		 * 创建对象，
		 * 如果池中有可复用的，直接返回可复用的对象，
		 * 否则创建一个新的。
		 * 如果打开了空池警告，则当池中没有可重用对象时抛出异常。
		 * 
		 * @param args 创建对象构造函数的参数列表，
		 * null表示构造对象不需要参数列表。
		 * 
		 * @throws com.codeTooth.actionscript.lang.exceptions.IllegalOperationException 
		 * 开启了空池异常，并且池中没有可以重用的对象。
		 * 
		 * @return
		 */		
		public function createObject(args:Array = null):*
		{
			if(_container.length > 0)
			{
				return _container.pop();
			}
			else
			{
				if(_emptyExceptionTurnOn)
				{
					throw new IllegalOperationException("Objects pool is empty");
					return null;
				}
				else
				{
					return DynamicConstruct.newApply(_definition, args);
				}
			}
		}
		
		/**
		 * 将一个可重用对象放入池中，
		 * 如果对象实现了IReuseable接口，将调用其reuse方法。
		 * 
		 * @param object 指定的重用对象
		 * 
		 * @throws com.codeTooth.actionscript.lang.exceptions.NullPointerException 
		 * 指定的可重用对象是null
		 * @throws com.codeTooth.actionscript.lang.exceptions.UnknownTypeException 
		 * 当前池不容纳该类型的对象
		 * @throws com.codeTooth.actionscript.lang.exceptions.IllegalOperationException 
		 * 开启了池溢出异常并且池已经满了
		 * 
		 * @return 返回成功添加进去的对象。返回null表示没有成功添加，可能是对象池已满，或指定的对象是null。
		 */		
		public function reuse(object:Object):Object
		{
			if (object != null)
			{
				if(_stronglyTyped && !(object is _definition))
				{
					throw new UnknownTypeException("Reuse object is not the type of " + _definition)
				}
				
				if(object is IReuseable)
				{
					IReuseable(object).reuse();
				}
				
				//池满了
				if(_container.length >= _capability)
				{
					if(_overflowExceptionTurnOn)
					{
						throw new IllegalOperationException("The objects pool is full");
					}
					
					return null;
				}
				else
				{
					_container.push(object);
					
					return object;
				}
			}
			
			return null;
		}
		
		/**
		 * @inheritDoc
		 */		
		public function destroy():void
		{
			if (_container != null)
			{
				if(_container.length > 0)
				{
					DestroyUtil.breakArray(_container);
				}
				_container = null;
				_definition = null;
			}
		}
	}
}