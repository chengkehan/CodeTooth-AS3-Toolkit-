package com.codeTooth.actionscript.lang.utils.newObjectPool
{
	import com.codeTooth.actionscript.lang.exceptions.NullPointerException;
	import com.codeTooth.actionscript.lang.utils.destroy.DestroyUtil;
	import com.codeTooth.actionscript.lang.utils.destroy.IDestroy;

	internal class Pool implements IDestroy
	{
		private var _type:Class = null;
		
		private var _instances:Array = null;
		
		private var _maxSize:int = 0;
		
		private var _invokeAfterPut:Function = null;
		
		private var _invokeBeforeGet:Function = null;
		
		private var _disposeObject:Function = null;
		
		private var _alias:Object = null;
		
		public function Pool(type:Class, maxSize:int, alias:Object = null, invokeAfterPut:Function = null, invokeBeforeGet:Function = null, disposeObject:Function = null)
		{
			if(type == null)
			{
				throw new NullPointerException("Null input type parameter.");
			}
			
			_alias = alias;
			_type = type;
			_instances = new Array();
			_maxSize = maxSize;
			_invokeAfterPut = invokeAfterPut;
			_invokeBeforeGet = invokeBeforeGet;
			_disposeObject = disposeObject;
		}
		
		public function get alias():Object
		{
			return _alias;
		}
		
		public function get maxSize():int
		{
			return _maxSize;
		}
		
		public function getType():Class
		{
			return _type;
		}
		
		public function getObject():*
		{
			var obj:Object = null;
			if(isEmpty)
			{
				obj = new _type();
			}
			else
			{
				obj = _instances.pop();
			}
			if(_invokeBeforeGet != null)
			{
				_invokeBeforeGet(obj);
			}
			
			return obj;
		}
		
		public function putObject(obj:Object):Boolean
		{
			if(isFull)
			{
				return false;
			}
			else
			{
				if(_invokeAfterPut != null)
				{
					_invokeAfterPut(obj);
				}
				_instances.push(obj);
				
				return true;
			}
		}
		
		public function get isFull():Boolean
		{
			return _instances.length > _maxSize;
		}
		
		public function get isEmpty():Boolean
		{
			return _instances.length == 0;
		}

		public function destroy():void
		{
			if(_instances != null)
			{
				if(_disposeObject != null)
				{
					for each(var instance:Object in _instances)
					{
						_disposeObject(instance);
					}
					DestroyUtil.breakArray(_instances);
				}
				else
				{
					DestroyUtil.destroyArray(_instances);
				}
				_instances = null;
			}
			
			_type = null;
			_invokeAfterPut = null;
			_invokeBeforeGet = null;
			_disposeObject = null;
		}
	}
}