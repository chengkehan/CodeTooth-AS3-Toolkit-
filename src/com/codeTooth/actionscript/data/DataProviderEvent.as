package com.codeTooth.actionscript.data 
{
	import flash.events.Event;
	
	/**
	 * 数据源事件
	 */
	public class DataProviderEvent extends Event 
	{
		/**
		 * 设置数据
		 */
		public static const SET_DATA:String = "setData";
		
		/**
		 * 添加一条数据
		 */
		public static const ADD_ITEM_AT:String = "addItemAt";
		
		/**
		 * 删除一条数据
		 */
		public static const REMOVE_ITEM_AT:String = "removeItemAt";
		
		/**
		 * 设置一条数据
		 */
		public static const SET_ITEM_AT:String = "setItemAt";
		
		/**
		 * 排序
		 */
		public static const SORT_ON:String = "sortOn";
		
		/**
		 * 当前操作的数据源
		 */
		public var data:Array = null;
		
		/**
		 * 当前操作的一条数据
		 */
		public var itemData:Object = null;
		
		/**
		 * 当前操作的一条数据的索引
		 */
		public var index:int = 0;
		
		/**
		 * @inheritDoc
		 */
		public function DataProviderEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
			
		} 
		
		/**
		 * @inheritDoc
		 */
		public override function clone():Event 
		{ 
			var newEvent:DataProviderEvent = new DataProviderEvent(type, bubbles, cancelable);
			newEvent.data = data;
			newEvent.itemData = itemData;
			newEvent.index = index;
			
			return newEvent;
		} 
		
	}
	
}