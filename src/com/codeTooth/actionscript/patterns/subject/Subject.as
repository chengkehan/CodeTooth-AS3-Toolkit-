package com.codeTooth.actionscript.patterns.subject
{
	import com.codeTooth.actionscript.lang.exceptions.NullPointerException;
	import com.codeTooth.actionscript.lang.utils.destroy.DestroyUtil;
	import com.codeTooth.actionscript.lang.utils.destroy.IDestroy;
	
	import flash.utils.Dictionary;

	public class Subject implements IDestroy
	{
		private var _observers:Dictionary/*key IObserver, value IObserver*/ = null;
		
		public function Subject()
		{
			_observers = new Dictionary();
		}
		
		public function addObserver(observer:IObserver):void
		{
			if(observer == null)
			{
				throw new NullPointerException("Null observer");
			}
			
			_observers[observer] = observer;
		}
		
		public function removeObserver(observer:IObserver):IObserver
		{
			var observer:IObserver = _observers[observer];
			delete _observers[observer];
			
			return observer;
		}
		
		public function containsObserver(observer:IObserver):Boolean
		{
			return _observers[observer] != null;
		}
		
		public function notify(data:INofityData = null):void
		{
			// 记录已经被update过的观察者
			// 如果在观察者的update方法中执行了removeObserver方法，就会发生某个obsever被update两次
			// 这个变量就是这个作用的，避免一个observer被重复update两次
			var alreadyUpdate:Dictionary = new Dictionary();
			
			for each(var observer:IObserver in _observers)
			{
				if(alreadyUpdate[observer] == null)
				{
					alreadyUpdate[observer] = observer;
					observer.update(data);
				}
			}
		}
		
		public function destroy():void
		{
			DestroyUtil.breakMap(_observers);
			_observers = null;
		}
	}
}