package com.codeTooth.actionscript.lang.utils.newObjectPool
{
	import com.codeTooth.actionscript.adt.collection.Map;
	import com.codeTooth.actionscript.lang.utils.ConstructObject;
	import com.codeTooth.actionscript.lang.utils.destroy.DestroyUtil;
	import com.codeTooth.actionscript.lang.utils.destroy.IDestroy;
	import com.codeTooth.actionscript.lang.utils.newObjectPool.Item;
	
	import flash.utils.Dictionary;
	import flash.utils.getTimer;
	import com.codeTooth.actionscript.lang.exceptions.NullPointerException;

	internal class Pool implements IDestroy
	{
		private var _type:Class = null;
		
		private var _itemsInUsing:Map = null;
		
		private var _itemsFree:Map = null;
		
		private var _invokeAfterPut:Function = null;
		
		private var _invokeBeforeGet:Function = null;
		
		private var _invokeDisposeObject:Function = null;
		
		private var _alias:Object = null;
		
		public function Pool(type:Class, alias:Object = null, invokeAfterPut:Function = null, invokeBeforeGet:Function = null, invokeDisposeObject:Function = null)
		{
			if(type == null)
			{
				throw new NullPointerException("Null input type parameter.");
			}
			
			_alias = alias;
			_type = type;
			_itemsInUsing = new Map();
			_itemsFree = new Map();
			_invokeAfterPut = invokeAfterPut;
			_invokeBeforeGet = invokeBeforeGet;
			_invokeDisposeObject = invokeDisposeObject;
		}
		
		public function get size():int
		{
			return _itemsFree.size + _itemsInUsing.size;
		}
		
		public function get sizeInUsing():int
		{
			return _itemsInUsing.size;
		}
		
		public function get sizeFree():int
		{
			return _itemsFree.size;
		}
		
		public function resetObjectsDataForFree():void
		{
			var key:Object = null;
			var now:int = getTimer();
			var keys:Dictionary = null;
			var item:Item = null;
			
			keys = _itemsFree.getKeys();
			for each(key in keys)
			{
				item = _itemsFree.get(key);
				item.activeTimePoint = 0;
				item.usedTimes = 0;
			}
			keys = _itemsInUsing.getKeys();
			for each(key in keys)
			{
				item = _itemsInUsing.get(key);
				item.activeTimePoint = 0;
				item.usedTimes = 0;
			}
		}
		
		public function freeObjectsByInactiveTime(inactiveTime:int):void
		{
			var now:int = getTimer();
			var key:Object = null;
			var keys:Dictionary = _itemsFree.getKeys();
			var willDelKeys:Dictionary = new Dictionary();
			var item:Item = null;
			for each(key in keys)
			{
				item = _itemsFree.get(key);
				if(now - item.activeTimePoint > inactiveTime)
				{
					willDelKeys[item.object] = item.object;
				}
			}
			for each(key in willDelKeys)
			{
				item = _itemsFree.remove(key);
				if(_invokeDisposeObject != null)
				{
					_invokeDisposeObject(item.object);
				}
				item.destroy();
			}
		}
		
		public function freeObjectsByUsedTimes(usedTimes:int):void
		{
			var now:int = getTimer();
			var key:Object = null;
			var keys:Dictionary = _itemsFree.getKeys();
			var willDelKeys:Dictionary = new Dictionary();
			var item:Item = null;
			for each(key in keys)
			{
				item = _itemsFree.get(key);
				if(item.usedTimes < usedTimes)
				{
					willDelKeys[item.object] = item.object;
				}
			}
			for each(key in willDelKeys)
			{
				item = _itemsFree.remove(key);
				if(_invokeDisposeObject != null)
				{
					_invokeDisposeObject(item.object);
				}
				item.destroy();
			}
		}
		
		public function getAlias():Object
		{
			return _alias;
		}
		
		public function getType():Class
		{
			return _type;
		}
		
		public function getObject(args:Array = null):Object
		{
			var obj:Object = null;
			var item:Item = null;
			if(_itemsFree.isEmpty())
			{
				obj = ConstructObject.newConstructorApply(_type, args);
				item = new Item();
				item.object = obj;
			}
			else
			{
				var keys:Dictionary = _itemsFree.getKeys();
				for each(var key:Object in keys)
				{
					item = _itemsFree.remove(key);
					obj = item.object;
					break;
				}
			}
			item.activeTimePoint = getTimer();
			++item.usedTimes;
			_itemsInUsing.put(obj, item);
			
			if(_invokeBeforeGet != null)
			{
				_invokeBeforeGet(obj);
			}
			
			return obj;
		}
		
		public function putObject(obj:Object):void
		{
			if(_invokeAfterPut != null)
			{
				_invokeAfterPut(obj);
			}
			
			var item:Item = null;
			if(_itemsInUsing.containsKey(obj))
			{
				item = _itemsInUsing.remove(obj);
			}
			else
			{
				item = new Item();
				item.object = obj;
			}
			item.activeTimePoint = getTimer();
			_itemsFree.put(obj, item);
		}

		public function destroy():void
		{
			var item:Item = null;
			var keys:Dictionary = null;
			var key:Object = null;
			if(_itemsFree != null)
			{
				if(_invokeDisposeObject != null)
				{
					keys = _itemsFree.getKeys();
					for each(key in keys)
					{
						item = _itemsFree.get(key);
						_invokeDisposeObject(item.object);
					}
				}
				DestroyUtil.destroyObject(_itemsFree);
				_itemsFree = null;
			}
			if(_itemsInUsing != null)
			{
				if(_invokeDisposeObject != null)
				{
					keys = _itemsInUsing.getKeys();
					for each(key in keys)
					{
						item = _itemsInUsing.get(key);
						_invokeDisposeObject(item.object);
					}
				}
				DestroyUtil.destroyObject(_itemsInUsing);
				_itemsInUsing = null;
			}
			
			_type = null;
			_invokeAfterPut = null;
			_invokeBeforeGet = null;
			_invokeDisposeObject = null;
			_alias = null;
		}
	}
}