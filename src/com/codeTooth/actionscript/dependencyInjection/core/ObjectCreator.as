package com.codeTooth.actionscript.dependencyInjection.core 
{
	import com.codeTooth.actionscript.lang.exceptions.IllegalOperationException;
	import com.codeTooth.actionscript.lang.exceptions.IllegalParameterException;
	import com.codeTooth.actionscript.lang.exceptions.NoSuchObjectException;
	import com.codeTooth.actionscript.lang.exceptions.NullPointerException;
	import com.codeTooth.actionscript.lang.exceptions.UnknownTypeException;
	import com.codeTooth.actionscript.lang.utils.destroy.DestroyUtil;
	import com.codeTooth.actionscript.lang.utils.destroy.IDestroy;
	import com.codeTooth.actionscript.patterns.iterator.ArrayIterator;
	import com.codeTooth.actionscript.patterns.iterator.IIterator;
	
	import flash.system.ApplicationDomain;
	import flash.utils.Dictionary;
	
	/**
	 * @private
	 * 
	 * 注入对象创建器
	 */	
	internal class ObjectCreator implements IDestroy
	{
		//存储所有的item对象
		private var _items:Items = null;
		
		//存储所有以创建的的单例对象
		private var _singletons:Dictionary = null;
		
		//应用程序域
		private var _applicationDomain:ApplicationDomain = null;
		
		//存储当前this的指向
		private var _thisObjects:Array = null;
		
		//存储本地数据
		private var _local:Dictionary = null;
		
		public function ObjectCreator()
		{
			_items = new Items();
			_singletons = new Dictionary();
			_applicationDomain = ApplicationDomain.currentDomain;
			_thisObjects = new Array();
			_local = new Dictionary();
		}
		
		/**
		 * 设置应用程序域
		 * 
		 * @param applicationDomain
		 * 
		 * @throws com.codeTooth.actionscript.lang.exceptions.NullPointerException
		 * 指定的应用程序域是null
		 */		
		public function set applicationDomain(applicationDomain:ApplicationDomain):void
		{
			if(applicationDomain == null)
			{
				throw new NullPointerException("Null applicationDomain");
			}
			
			_applicationDomain = applicationDomain;
		}
		
		/**
		 * @private
		 */			
		public function get applicationDomain():ApplicationDomain
		{
			return _applicationDomain;
		}
		
		/**
		 * 添加一条本地数据
		 * 
		 * @param name 为本地数据指定一个名称
		 * @param object 对象实例
		 * 
		 * @throws com.codeTooth.actionscript.lang.exceptions.IllegalOperationException
		 * 添加本地数据时发生了重名
		 * @throws com.codeTooth.actionscript.lang.exceptions.NullPointerException
		 * 指定的名称是null
		 */		
		public function addLocal(name:String, object:Object):void
		{
			if(hasLocal(name))
			{
				throw new IllegalOperationException("Has had the local \"" + name + "\"");
			}
			
			if(name == null)
			{
				throw new NullPointerException("Null add local name");
			}
			
			_local[name] = object;
		}
		
		/**
		 * 移除一条本地数据
		 * 
		 * @param name 指定要移除的本地数据的名称
		 * 
		 * @throws com.codeTooth.actionscript.lang.exceptions.NoSuchObjectException
		 * 不存在指定名称的本地数据
		 */		
		public function removeLocal(name:String):void
		{
			if(!hasLocal(name))
			{
				throw new NoSuchObjectException("Has not the local \"" + name + "\"");
			}
			
			delete _local[name];
		}
		
		/**
		 * 获得一条本地数据
		 * 
		 * @param name 指定的本地数据的名称
		 * 
		 * @throws com.codeTooth.actionscript.lang.exceptions.NoSuchObjectException
		 * 不存在指定名称的本地数据
		 * 
		 * @return
		 */		
		public function getLocal(name:String):Object
		{
			if(!hasLocal(name))
			{
				throw new NoSuchObjectException("Has not the local \"" + name + "\"");
			}
			
			return _local[name];
		}
		
		/**
		 * 判断是否存在指定的本地数据
		 * 
		 * @param name 指定的本地数据的名称
		 * 
		 * @return
		 */		
		public function hasLocal(name:String):Boolean
		{
			return _local[name] != undefined
		}
		
		/**
		 * 开始创建一个对象
		 * 
		 * @param id 指定创建对象对应的id
		 *
		 * @throws com.codeTooth.actionscript.lang.exceptions.NoSuchObjectException
		 * 没有找到指定的id
		 *  
		 * @return 返回创建的对象实例
		 */		
		public function createObject(id:String):Object
		{
			var object:Object = null;
			
			if(!hasObject(id))
			{
				throw new NoSuchObjectException("No such object \"" + id + "\"");
			}
			
			//获得id对应的item对象实例
			var item:Item = _items.getItem(id);
			
			//如果是单例
			//并且已经被创建过
			//直接使用先前创建的对象
			if(item.isSingle && _singletons[id] != undefined)
			{
				object = _singletons[id];
			}
			//否则重新创建对象
			else
			{
				//构造函数创建
				if(item.constructorType == Item.CONSTRUCTOR_TYPE_NEW)
				{
					object = newConstruct(item);
				}
				//静态方法创建
				else
				{
					object = staticMethodConstruct(item);
				}
			}
			
			//添加一个当前this的指向
			_thisObjects.push(object);
			
			if(!item.isSingle || (item.isSingle && item.isReinject))
			{
				if(item.hasContents())
				{
					var contentsIterator:IIterator = item.contentsIterator;
					var content:Content = null;
					while(contentsIterator.hasNext())
					{
						content = Content(contentsIterator.next());
						//注入属性
						if(content.hasChild1() && content.hasChild2())
						{
							setProperty(content.child1, getObject(content.child2));
						}
						//注入方法
						else if(content.hasChild1() && !content.hasChild2())
						{
							getObject(content.child1)
						}
					}
					contentsIterator.destroy();
				}
			}
			
			//移除一个当前的this指向
			var thisObject:Object = _thisObjects.pop();
			//存储一个单例
			if(item.isSingle && _singletons[id] == undefined)
			{
				_singletons[id] = thisObject;
			}
			
			return object;
		}
		
		/**
		 * 判断是否存在指定的id
		 * 
		 * @param id
		 * 
		 * @return
		 */		
		public function hasObject(id:String):Boolean
		{
			return _items.hasItem(id);
		}
		
		/**
		 * 设置所有的item对象
		 * 
		 * @param items
		 */		
		public function setItems(items:Dictionary/*of Item*/):void
		{
			destroySingletons();
			_items.setItems(items);
		}
		
		/**
		 * 销毁所有已经存在的单例对象
		 */		
		public function destroySingletons():void
		{
			DestroyUtil.destroyMap(_singletons);
		}
		
		/**
		 * @inheritDoc
		 */		
		public function destroy():void
		{
			_items.destroy();
			_items = null;
			
			destroySingletons();
			_singletons = null;
			
			DestroyUtil.destroyArray(_thisObjects);
			_thisObjects = null;
			DestroyUtil.breakMap(_local);
			_local = null;
		}
		
		//获得解析后的对象
		private function getObjects(inputObjects:Array):Array
		{
			var objects:Array = new Array();
			for each(var object:DiObject in inputObjects)
			{
				objects.push(getObject(object));
			}
			
			return objects;
		}
		
		//获得解析后的对象
		//@exception	<UnknownTypeException>	未知的解析类型
		private function getObject(object:DiObject):Object
		{
			if(object.type == DiObject.NUMBER)
			{
				return getNumber(object);
			}
			else if(object.type == DiObject.STRING)
			{
				return getString(object);
			}
			else if(object.type == DiObject.PROPERTY1 || object.type == DiObject.PROPERTY2)
			{
				return getProperty(object);
			}
			else if(object.type == DiObject.METHOD)
			{
				return getMethod(object);
			}
			else
			{
				throw new UnknownTypeException("Unknown type \"" + object.type + "\"");
				return null;
			}
		}
		
		//获得解析后的数字
		//@exception	<UnknownTypeException>	非数字
		private function getNumber(object:DiObject):Number
		{
			var number:Number = Number(object.content);
			if(isNaN(number))
			{
				throw new UnknownTypeException("isNaN " + "\"" + number + "\"");
			}
			
			return number;
		}
		
		//获得解析后的字符串
		private function getString(object:DiObject):String
		{
			return object.content;
		}
		
		//获得解析后的属性
		private function getProperty(object:DiObject):Object
		{
			var content:String = object.content;
			var contentsBlocks:Array = content.split(".");
			var property:Object = null;
			var isLoop:Boolean = true;
			if(contentsBlocks[0] == "this")
			{
				property = _thisObjects[_thisObjects.length - 1];
			}
			else if(hasObject(contentsBlocks[0]))
			{
				property = createObject(contentsBlocks[0]);
			}
			else if(hasLocal(contentsBlocks[0]))
			{
				property = getLocal(contentsBlocks[0]);
			}
			else
			{
				property = getDefinition(content);
				isLoop = false;
			}
			
			if(isLoop)
			{
				var currentBlockIndex:int = 0;
				var numberBlocks:int = contentsBlocks.length;
				while(++currentBlockIndex < numberBlocks)
				{
					property = property[contentsBlocks[currentBlockIndex]];
				}
			}
			
			return property;
		}
		
		//设置属性
		private function setProperty(diObject:DiObject, object:Object):void
		{
			var content:String = diObject.content;
			var contentsBlocks:Array = content.split(".");
			var property:Object = null;
			if(contentsBlocks[0] == "this")
			{
				property = _thisObjects[_thisObjects.length - 1];
			}
			else if(hasObject(contentsBlocks[0]))
			{
				property = createObject(contentsBlocks[0]);
			}
			else
			{
				property = getLocal(contentsBlocks[0]);
			}
			
			var currentBlockIndex:int = 0;
			var numberBlocks:int = contentsBlocks.length;
			while(++currentBlockIndex < numberBlocks)
			{
				if(currentBlockIndex == numberBlocks - 1)
				{
					property[contentsBlocks[currentBlockIndex]] = object;
				}
				else
				{
					property = property[contentsBlocks[currentBlockIndex]];
				}
			}
		}
		
		//获得解析后的方法返回值
		private function getMethod(object:DiObject):Object
		{
			var content:String = object.content;
			var contentsBlocks:Array = content.split(".");
			var method:Object = null;
			var isLoop:Boolean = true;
			if(contentsBlocks[0] == "this")
			{
				method = _thisObjects[_thisObjects.length - 1];
			}
			else if(hasObject(contentsBlocks[0]))
			{
				method = createObject(contentsBlocks[0]);
			}
			else
			{
				method = getLocal(contentsBlocks[0]);
			}
			
			var currentBlockIndex:int = 0;
			var numberBlocks:int = contentsBlocks.length;
			while(++currentBlockIndex < numberBlocks)
			{
				method = method[contentsBlocks[currentBlockIndex]];
			}
			
			if(object.hasChildren())
			{
				var childrenIterator:ArrayIterator = ArrayIterator(object.childrenIterator());
				var children:Array = getObjects(childrenIterator.toArray());
				childrenIterator.destroy();
				return (method as Function).apply(null, children);
			}
			else
			{
				return (method as Function)();
			}
		}
		
		//构造函数构造
		//@exception	<IllegalParameterException>	构造函数参数过长
		private function newConstruct(item:Item):Object
		{
			var object:Object = null;
			var definition:Object = getDefinition(item.type);
			if(item.hasConstructorArguments())
			{
				var constructorArgumentsIterator:ArrayIterator = ArrayIterator(item.constructorArgumentsIterator());
				var constructorArguments:Array = getObjects(constructorArgumentsIterator.toArray());
				constructorArgumentsIterator.destroy();
				switch(constructorArguments.length)
				{
					case 1:
						object = new definition(constructorArguments[0]);
						break;
					case 2:
						object = new definition(constructorArguments[0], constructorArguments[1]);
						break;
					case 3:
						object = new definition(constructorArguments[0], constructorArguments[1], constructorArguments[2]);
						break;
					case 4:
						object = new definition(constructorArguments[0], constructorArguments[1], constructorArguments[2], constructorArguments[3]);
						break;
					case 5:
						object = new definition(constructorArguments[0], constructorArguments[1], constructorArguments[2], constructorArguments[3], constructorArguments[4]);
						break;
					case 6:
						object = new definition(constructorArguments[0], constructorArguments[1], constructorArguments[2], constructorArguments[3], constructorArguments[4], constructorArguments[5]);
						break;
					case 7:
						object = new definition(constructorArguments[0], constructorArguments[1], constructorArguments[2], constructorArguments[3], constructorArguments[4], constructorArguments[5], constructorArguments[6]);
						break;
					case 8:
						object = new definition(constructorArguments[0], constructorArguments[1], constructorArguments[2], constructorArguments[3], constructorArguments[4], constructorArguments[5], constructorArguments[6], constructorArguments[7]);
						break;
					case 9:
						object = new definition(constructorArguments[0], constructorArguments[1], constructorArguments[2], constructorArguments[3], constructorArguments[4], constructorArguments[5], constructorArguments[6], constructorArguments[7], constructorArguments[8]);
						break;
					default:
						throw new IllegalParameterException("Illegal length of constructor arguments " + "\"" + constructorArguments.length + "\"");
				}
			}
			else
			{
				object = new definition();
			}
			
			return object;
		}
		
		//静态方法构造
		private function staticMethodConstruct(item:Item):Object
		{
			var object:Object = null;
			var definition:Object = getDefinition(item.type);
			if(item.hasConstructorArguments())
			{
				var constructorArgumentsIterator:ArrayIterator = ArrayIterator(item.constructorArgumentsIterator);
				object = (definition[item.constructorType] as Function).apply(null, constructorArgumentsIterator.toArray());
				constructorArgumentsIterator.destroy();
			}
			else
			{
				object = definition[item.constructorType]();
			}
			
			return object;
		}
		
		//获得类定义
		private function getDefinition(type:String):Object
		{
			return _applicationDomain.getDefinition(type);
		}
	}
}