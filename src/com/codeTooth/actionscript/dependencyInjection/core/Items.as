package com.codeTooth.actionscript.dependencyInjection.core 
{	
	import com.codeTooth.actionscript.lang.exceptions.NoSuchObjectException;
	import com.codeTooth.actionscript.lang.exceptions.NullPointerException;
	import com.codeTooth.actionscript.lang.utils.destroy.DestroyUtil;
	import com.codeTooth.actionscript.lang.utils.destroy.IDestroy;
	
	import flash.utils.Dictionary;
	
	
	/**
	 * @private
	 * 
	 * 注入项集合
	 */
	internal class Items implements IDestroy
	{
		//注入项集合
		private var _items:Dictionary/*of Item*/ = null;
		
		public function Items()
		{
			_items = new Dictionary();
		}
		
		/**
		 * 设置注入的项
		 * 
		 * @param items
		 * 
		 * @throws com.codeTooth.actionscript.lang.exceptions.NullPointerException
		 * 入参是null
		 */		
		public function setItems(items:Dictionary/*of Item*/):void
		{
			if(items == null)
			{
				throw new NullPointerException("Null items");
			}
			
			_items = items;
		}
		
		/**
		 * 获得一个注入项
		 * 
		 * @param id 注入项id
		 * 
		 * @throws com.codeTooth.actionscript.lang.exceptions.NoSuchObjectException
		 * 没有要找的注入项
		 * 
		 * @return
		 */		
		public function getItem(id:String):Item
		{
			if(!hasItem(id))
			{ 
				throw new NoSuchObjectException("No such item : " + id);
			}
			
			return _items[id];
		}
		
		/**
		 * 判断是否有此注入项
		 * 
		 * @param id	 注入项id
		 * 
		 * @return
		 */		
		public function hasItem(id:String):Boolean
		{
			return hasItems() &&  _items[id] != undefined;
		}
		
		public function hasItems():Boolean
		{
			return _items != null;
		}
			
		public function destroy():void
		{
			DestroyUtil.destroyMap(_items);
			_items = null;
		}
	}
}