package com.codeTooth.actionscript.patterns.observer
{	
	import com.codeTooth.actionscript.core.codeTooth_internal;
	import com.codeTooth.actionscript.lang.utils.collection.Collection;
	import com.codeTooth.actionscript.lang.utils.destroy.IDestroy;
	import flash.utils.Dictionary;
	
	/**
	 * 观察者订阅的主题
	 */	
	
	public class Subject extends Collection 
	{	
		use namespace codeTooth_internal
		
		public function Subject()
		{
			
		}
		
		/**
		 * 添加一个观察者
		 * 
		 * @param observer
		 * 
		 * @return 返会成功添加的观察者。如果指定的观察者是null，或者已经存在相同的观察者了，将添加失败返回null
		 */		
		public function addObserver(observer:IObserver):IObserver
		{
			if (observer == null || containsItem(observer))
			{
				return null;
			}
			else
			{
				return addItem(observer, observer);
			}
		}
		
		/**
		 * 移除一个观察者
		 * 
		 * @param observer
		 * 
		 * @param 返回成功删除的观察者。没有找到返回null
		 */		
		public function removeObserver(observer:IObserver):IObserver
		{
			return removeItem(observer);
		}
		
		/**
		 * 判断是否存在指定的观察者
		 * 
		 * @param observer
		 * 
		 * @return 
		 */		
		public function containsObserver(observer:IObserver):Boolean
		{
			return containsItem(observer);
		}
		
		/**
		 * 通知所有已经订阅该主题的观察者
		 * 
		 * @param data 指定通知的内容
		 */		
		public function notify(data:Object = null):void
		{
			for each(var item:IObserver in _items)
			{
				item.update(data);
			}
		}
		
		/**
		 * 获得所有的观察者。请勿修改集合
		 * 
		 * @return
		 */
		public function getObservers():Dictionary
		{
			return getItems();
		}
		
		/**
		 * 清空
		 */
		public function removeObservers():void
		{
			removeItems();
		}
	}
}