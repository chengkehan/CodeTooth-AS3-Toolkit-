package com.codeTooth.actionscript.lang.utils.newObjectPool
{
	import com.codeTooth.actionscript.lang.exceptions.NoSuchObjectException;
	import com.codeTooth.actionscript.lang.utils.destroy.DestroyUtil;
	import com.codeTooth.actionscript.lang.utils.destroy.IDestroy;
	
	import flash.utils.Dictionary;

	/**
	 * 对象池
	 */
	public class ObjectPool implements IDestroy
	{
		// 各种对象池
		private var _pools:Dictionary/*key type, value Pool*/ = new Dictionary();
		
		/**
		 * 创建一个对象池
		 * 
		 * @param type 对象池的类型
		 * @param maxSize 对象池的最大尺寸
		 * @param alias 对象池的别名
		 * @param invokeAfterPut 在放入一个对象之后，对此对象调用的函数。原型func(obj:type):void
		 * @param invokeBeforeGet 在取出一个对象之前，对此对象调用的函数。原型func(obj:type):void
		 * @param disposeObject 销毁对象池时，对此对象调用的函数。原型func(obj:type):void
		 * 
		 * @return 返回是否成功创建了对象池。如果已经存在了返回false
		 */
		public function createPool(type:Class, maxSize:int, alias:Object = null, invokeAfterPut:Function = null, invokeBeforeGet:Function = null, disposeObject:Function = null):Boolean
		{
			if(containsPool(type))
			{
				return false;
			}
			else
			{
				var pool:Pool = new Pool(type, maxSize, alias, invokeAfterPut, invokeBeforeGet, disposeObject);
				_pools[type] = pool;
				return true;
			}
		}
		
		/**
		 * 向指定类型的对象池放入一个对象
		 * 
		 * @param instance 
		 * @param type 
		 * 
		 * @return 返回是否成功放入。如果池已满，则放入失败
		 * 
		 * @throws com.yheng.xianyuan.module.protocol.exception.NoSuchObjectException 不存在指定类型的对象池
		 */
		public function putObject(instance:Object, type:Class):Boolean
		{
			if(!containsPool(type))
			{
				throw new NoSuchObjectException("Cannot find the pool \"" + type + "\".");
			}
			
			var pool:Pool = _pools[type];
			return pool.putObject(instance);
		}
		
		/**
		 * 从指定类型的池中取出一个对象
		 * 
		 * @param type
		 * 
		 * @return 返回取出的对象。如果池已空，那么会new一个新对象返回。
		 * 
		 * @throws com.yheng.xianyuan.module.protocol.exception.NoSuchObjectException 不存在指定类型的对象池
		 */
		public function getObject(type:Class):*
		{
			if(!containsPool(type))
			{
				throw new NoSuchObjectException("Cannot find the pool \"" + type + "\".");
			}
			
			var pool:Pool = _pools[type];
			return pool.getObject();
		}
		
		/**
		 * 判断是否存在指定类型的池
		 * 
		 * @param type
		 * @return 
		 */
		public function containsPool(type:Class):Boolean
		{
			return _pools[type] != null;
		}
		
		/**
		 * 判断是否包含指定别名的池
		 * 
		 * @param alias
		 * @return 
		 */
		public function containsPoolByAlias(alias:Object):Boolean
		{
			for each(var pool:Pool in _pools)
			{
				if(pool.alias == alias)
				{
					return true;
				}
			}
			
			return false;
		}

		/**
		 * 销毁指定类型的对象池
		 * 
		 * @param type
		 */
		public function disposePool(type:Class):void
		{
			if(containsPool(type))
			{
				var pool:Pool = _pools[type];
				pool.destroy()();
				delete _pools[type];
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function destroy():void
		{
			if(_pools != null)
			{
				DestroyUtil.destroyMap(_pools);
				_pools = null;
			}
		}
	}
}