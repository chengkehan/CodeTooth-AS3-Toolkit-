package com.codeTooth.actionscript.reflect.core
{
	import com.codeTooth.actionscript.lang.utils.destroy.IDestroy;
	import com.codeTooth.actionscript.patterns.iterator.IIterator;
	
	/**
	 *反射对象 
	 */
	public class ReflectObject implements IDestroy 
	{	
		//类型
		private var _type:String = null;
		
		//基类类型
		private var _baseType:String = null;
		
		//是否是动态类
		private var _idDynamic:Boolean = false;
		
		//是否是最终类
		private var _isFinal:Boolean = false;
		
		//是类定义还是实例对象
		private var _isStatic:Boolean = false;
		
		//继承类型迭代器
		private var _extendsTypesIterator:IIterator = null;
		
		//继承类定义迭代器
		private var _extendsDefinitionsIterator:IIterator = null;
		
		//实现接口类型迭代器
		private var _implementsTypesIterator:IIterator = null;
		
		//实现接口类定义迭代器
		private var _implementsDefinitionsIterator:IIterator = null;
		
		//构造函数
		private var _constructor:Constructor = null;
		
		//静态常量迭代器
		private var _isStaticConstantsIterator:IIterator = null;
		
		//静态存取器迭代器
		private var _isStaticAccessorsIterator:IIterator = null;
		
		//静态方法迭代器
		private var _isStaticMethodsIterator:IIterator = null;
		
		//静态变量迭代器
		private var _isStaticVariablesIterator:IIterator = null;
		
		//常量迭代器
		private var _constantsIterator:IIterator = null;
		
		//存取器迭代器
		private var _accessorsIterator:IIterator = null;
		
		//方法迭代器
		private var _methodsIterator:IIterator = null;
		
		//变量迭代器
		private var _variablesIterator:IIterator = null;
		
		public function ReflectObject()
		{
			
		}
		
		/**
		 * 类型
		 * 
		 * @return
		 */		
		public function get type():String
		{
			return _type;
		}
		
		/**
		 * 类定义
		 * 
		 * @return
		 */		
		public function get definition():Class
		{
			return Reflect.getDefinitionInternal(_type);
		}
		
		/**
		 * 基类类型
		 *  
		 * @return
		 */		
		public function get baseType():String
		{
			return _baseType;
		}
		
		/**
		 * 基类类定义
		 * 
		 * @return
		 */		
		public function get baseDefinition():Class
		{
			return Reflect.getDefinitionInternal(_baseType);
		}
		
		/**
		 * 是否是动态类
		 * 
		 * @return
		 */		
		public function get isDynamic():Boolean
		{
			return _idDynamic;
		}
		
		/**
		 * 是否是最终类
		 * 
		 * @return
		 */		
		public function get isFinal():Boolean
		{
			return _isFinal;
		}
		
		/**
		 * 是否是最终类
		 * 
		 * @return
		 */		
		public function get isStatic():Boolean
		{
			return _isStatic;
		}
		
		/**
		 * 继承类型迭代器
		 * 
		 * @return
		 */		
		public function extendsTypesIterator():IIterator
		{
			return _extendsTypesIterator;
		}
		
		/**
		 * 获得继承类定义迭代器
		 * 
		 * @return
		 */
		public function extendsDefinitionsIterator():IIterator
		{
			return _extendsDefinitionsIterator;
		}
		
		/**
		 * 获得实现类型迭代器
		 * 
		 * @return
		 */
		public function implementsTypesIterator():IIterator
		{
			return _implementsTypesIterator;
		}
		
		/**
		 * 获得实现类定义迭代器
		 * 
		 * @return
		 */
		public function implementsDefinitionsIterator():IIterator
		{
			return _implementsDefinitionsIterator;
		}
		
		/**
		 * 获得构造函数对象
		 * 
		 * @return
		 */		
		public function get constructor():Constructor
		{
			return _constructor;
		}
		
		/**
		 * 静态常量迭代器
		 * 
		 * @return
		 */		
		public function staticConstantsIterator():IIterator
		{
			return _isStaticConstantsIterator;
		}
		
		/**
		 * 静态存取器迭代器
		 * 
		 * @return
		 */		
		public function staticAccessorsIterator():IIterator
		{
			return _isStaticAccessorsIterator;
		}
		
		/**
		 * 静态方法迭代器
		 * 
		 * @return
		 */		
		public function staticMethodsIterator():IIterator
		{
			return _isStaticMethodsIterator;
		}
		
		/**
		 * 静态变量
		 * 
		 * @return
		 */
		public function staticVariablesIterator():IIterator
		{
			return _isStaticVariablesIterator;
		}
		 
		/**
		 * 常量迭代器
		 * 
		 * @return
		 */		
		public function constantsIterator():IIterator
		{
			return _constantsIterator;
		}
		
		/**
		 * 存取器迭代器
		 * 
		 * @return
		 */		
		public function accessorsIterator():IIterator
		{
			return _accessorsIterator;
		}
		
		/**
		 * 方法迭代器
		 * 
		 * @return
		 */		
		public function methodsIterator():IIterator
		{
			return _methodsIterator;
		}
		
		/**
		 * 变量
		 */
		public function variablesIterator():IIterator
		{
			return _variablesIterator;
		}
		
		/**
		 * @iheritDoc
		 */
		public function destroy():void
		{
			if (_extendsTypesIterator != null)
			{
				_extendsTypesIterator.destroy();
				_extendsTypesIterator = null;
			}
		
			if (_extendsDefinitionsIterator != null)
			{
				_extendsDefinitionsIterator.destroy();
				_extendsDefinitionsIterator = null;
			}
		
			if (_implementsTypesIterator != null)
			{
				_implementsTypesIterator.destroy();
				_implementsTypesIterator = null;
			}
		
			if (_implementsDefinitionsIterator != null)
			{
				_implementsDefinitionsIterator.destroy();
				_implementsDefinitionsIterator = null;
			}
			
			if (_constructor != null)
			{
				_constructor.destroy();
				_constructor = null;
			}
			
			if (_isStaticAccessorsIterator != null)
			{
				_isStaticAccessorsIterator.destroy();
				_isStaticAccessorsIterator = null;
			}
		
			if (_isStaticMethodsIterator != null)
			{
				_isStaticMethodsIterator.destroy();
				_isStaticMethodsIterator = null;
			}
		
			if (_accessorsIterator != null)
			{
				_accessorsIterator.destroy();
				_accessorsIterator = null;
			}
		
			if (_methodsIterator != null)
			{
				_methodsIterator.destroy();
				_methodsIterator = null;
			}
		
			if (_isStaticVariablesIterator != null)
			{
				_isStaticVariablesIterator.destroy();
				_isStaticVariablesIterator = null;
			}
		
			if (_variablesIterator != null)
			{
				_variablesIterator.destroy();
				_variablesIterator = null;
			}
		
			if (_constantsIterator != null)
			{
				_constantsIterator.destroy();
				_constantsIterator = null;
			}
		
			if (_isStaticConstantsIterator != null)
			{
				_isStaticConstantsIterator.destroy();
				_isStaticConstantsIterator = null;
			}
		}
		
		/**
		 * @inheritDoc
		 */		
		public function toString():String
		{
			return "[object ReflectObject(type:" + _type + ")]";
		}
		
		//设置类型
		internal function set typeInternal(type:String):void
		{
			_type = type;
		}
		
		//设置基类类型
		internal function set baseTypeInternal(baseType:String):void
		{
			_baseType = baseType;
		}
		
		//设置是否是动态类
		internal function set dynamicInternal(bool:Boolean):void
		{
			_idDynamic = bool;
		}
		
		//设置是否是最终类
		internal function set finalInternal(bool:Boolean):void
		{
			_isFinal = bool;
		}
		
		//设置是类定义还是对象实例
		internal function set staticInternal(bool:Boolean):void
		{
			_isStatic = bool;
		}
		
		//设置继承类型迭代器
		internal function set extendsTypesIteratorInternal(extendsTypesIterator:IIterator):void
		{
			_extendsTypesIterator = extendsTypesIterator;
		}
		
		//设置继承类定义迭代器
		internal function set extendsDefinitionsIteratorInternal(extendsDefinitionsIterator:IIterator):void
		{
			_extendsDefinitionsIterator = extendsDefinitionsIterator;
		}
		
		//设置实现类型迭代器
		internal function set implementsTypesIteratorInternal(implementsTypesIterator:IIterator):void
		{
			_implementsTypesIterator = implementsTypesIterator;
		}
		
		//设置实现类定义迭代器
		internal function set implementsDefinitionsIteratorInternal(implementsDefinitionsIterator:IIterator):void
		{
			_implementsDefinitionsIterator = implementsDefinitionsIterator;
		}
		
		//设置构造函数
		internal function set constructorInternal(constructor:Constructor):void
		{
			_constructor = constructor;
		}
		
		//设置静态常量迭代器
		internal function set staticConstantsIteratorInternal(staticConstantsIterator:IIterator):void
		{
			_isStaticConstantsIterator = staticConstantsIterator
		}
		
		//设置静态变量迭代器
		internal function set staticVariablesIteratorInternal(staticVariablesIterator:IIterator):void
		{
			_isStaticVariablesIterator = staticVariablesIterator
		}
		
		//设置静态存取器迭代器
		internal function set staticAccessorsIteratorInternal(staticAccessorsIterator:IIterator):void
		{
			_isStaticAccessorsIterator = staticAccessorsIterator;
		}
		
		//设置静态方法迭代器
		internal function set staticMethodsIteratorInternal(staticMethodsIterator:IIterator):void
		{
			_isStaticMethodsIterator = staticMethodsIterator;
		}
		
		//设置常量迭代器
		internal function set constantsIteratorInternal(constantsIterator:IIterator):void
		{
			_constantsIterator = constantsIterator;
		}
		
		//设置变量迭代器
		internal function set variablesIteratorInternal(variablesIterator:IIterator):void
		{
			_variablesIterator = variablesIterator;
		}
		
		//设置存取器迭代器
		internal function set accessorsIteratorInternal(accessorsIterator:IIterator):void
		{
			_accessorsIterator = accessorsIterator;
		}
		
		//设置方法迭代器
		internal function set methodsIteratorInternal(methodsIterator:IIterator):void
		{
			_methodsIterator = methodsIterator;
		}
		
	}
}