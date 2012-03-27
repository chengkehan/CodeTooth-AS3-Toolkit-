package com.codeTooth.actionscript.lang.utils.collection 
{
	import com.codeTooth.actionscript.core.codeTooth_internal;
	
	/**
	 * 有序集合相
	 */
	public class CollectionOrderlyItem 
	{
		use namespace codeTooth_internal;
		
		private var _name:Object = null;
	
		private var _data:Object = null;
		
		/**
		 * 构造函数
		 * 
		 * @param	name
		 * @param	data
		 */
		public function CollectionOrderlyItem(name:Object, data:Object) 
		{
			_name = name;
			_data = data;
		}
		
		/**
		 * 键
		 */
		public function get name():*
		{
			return _name;
		}
		
		/**
		 * 值
		 */
		public function get data():*
		{
			return _data;
		}
		
		codeTooth_internal function setName(name:Object):void
		{
			_name = name;
		}
		
		codeTooth_internal function setData(data:Object):void
		{
			_data = data;
		}
	}

}