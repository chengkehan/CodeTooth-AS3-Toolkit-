package com.codeTooth.actionscript.lang.utils
{
	import com.codeTooth.actionscript.dependencyInjection.core.Item;
	import com.codeTooth.actionscript.lang.exceptions.NullPointerException;
	import com.codeTooth.actionscript.lang.utils.destroy.DestroyUtil;
	import com.codeTooth.actionscript.lang.utils.destroy.IDestroy;
	
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;

	public class ListenerHandler implements IDestroy
	{
		private var _target:IEventDispatcher = null;
		
		private var _items:Dictionary = null;
		
		public function ListenerHandler(target:IEventDispatcher)
		{
			if(target == null)
			{
				throw new NullPointerException("Null input target parameter.");
			}
			
			_target = target;
			_items = new Dictionary();
		}
		
		public function getTarget():IEventDispatcher
		{
			return _target;
		}
		
		public function addListener(type:String, listener:Function, useCapture:Boolean, priority:int = 0, useWeakReference:Boolean = false):void
		{
			var item:Item = new Item();
			item.type = type;
			item.listener = listener;
			item.useCapture = useCapture;
			_items[type] = item;
			_target.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}
		
		public function removeListener(type:String):Boolean
		{
			if(containsListener(type))
			{
				var item:Item = _items[type];
				delete _items[type];
				
				_target.removeEventListener(item.type, item.listener, item.useCapture);
				item.destroy();
				
				return true;
			}
			else
			{
				return false;
			}
		}
		
		public function removeAllListeners():void
		{
			for each(var item:Item in _items)
			{
				_target.removeEventListener(item.type, item.listener, item.useCapture);
			}
			DestroyUtil.destroyMap(_items);
		}
		
		public function containsListener(type:String):Boolean
		{
			return _items[type] != null;
		}
		
		public function destroy():void
		{
			if(_items != null)
			{
				removeAllListeners();
				_items = null;
				_target = null;
			}
		}
	}
}


import com.codeTooth.actionscript.lang.utils.destroy.IDestroy;

class Item implements IDestroy
{
	public var type:String = null;
	
	public var listener:Function = null;
	
	public var useCapture:Boolean = false;
	
	public function destroy():void
	{
		type = null;
		listener = null;
	}
}