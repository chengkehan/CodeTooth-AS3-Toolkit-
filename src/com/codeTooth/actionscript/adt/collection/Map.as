package com.codeTooth.actionscript.adt.collection
{
	import com.codeTooth.actionscript.lang.utils.destroy.DestroyUtil;
	import com.codeTooth.actionscript.lang.utils.destroy.IDestroy;
	
	import flash.utils.Dictionary;
	
	/**
	 * Map集合
	 */
	public class Map implements IDestroy
	{	
		private var _dic:Dictionary = null;
		
		private var _keys:Dictionary = null;
		private var _keysInit:Boolean = false;
		
		private var _size:int = 0;
		
		public function Map()
		{
			_dic = new Dictionary();
		}
		
		public function containsKey(key:Object):Boolean
		{
			return _dic[key] != null;
		}
		
		public function get(key:Object):*
		{
			return _dic[key];
		}
		
		public function isEmpty():Boolean
		{
			return _size == 0;
		}
		
		public function put(key:Object, value:Object):*
		{
			if(_dic[key] == null)
			{
				++_size;
			}
			var prev:Object = _dic[key];
			_dic[key] = value;
			
			if(_keys != null)
			{
				_keys[key] = key;
			}
			
			return prev;
		}
		
		public function remove(key:Object):*
		{
			if(_dic[key] != null)
			{
				--_size;
			}
			var v:Object = _dic[key];
			delete _dic[key];
			
			if(_keys != null)
			{
				delete _keys[key];
			}
			
			return v;
		}
		
		public function get size():int
		{
			return _size;
		}
		
		/**
		 * Map集合中的所有键，这个方法的返回值只是用来遍历查看的，请勿修改。
		 * 
		 * @return 
		 */
		public function getKeys():Dictionary
		{
			if(!_keysInit)
			{
				_keysInit = true;
				if(_keys == null)
				{
					_keys = new Dictionary();
				}
				for(var key:Object in _dic)
				{
					_keys[key] = key;
				}
			}
			
			return _keys;
		}
		
		public function clear():void
		{
			DestroyUtil.breakMap(_dic);
			DestroyUtil.breakMap(_keys);
			_keysInit = false;
			_size = 0;
		}
		
		public function destroy():void
		{
			clear();
			_keys = null;
			_dic = null;
		}
	}
}