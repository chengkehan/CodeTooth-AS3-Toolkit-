package com.codeTooth.actionscript.lang.utils 
{
	import flash.events.IEventDispatcher;
	
	/**
	 * 侦听助手。一次添加和移除多个侦听
	 */
	public class ListenerUtil 
	{
		/**
		 * 添加侦听
		 * 
		 * @param	target	侦听对象
		 * @param	eventTypes 事件类型
		 * @param	handlers	事件处理
		 * 
		 * @return
		 */
		public static function addListeners(target:IEventDispatcher, eventTypes:Vector.<String>, handlers:Vector.<Function>):IEventDispatcher
		{
			listeners(target == null ? null : target.addEventListener, eventTypes, handlers);
			
			return target;
		}
		
		/**
		 * 移除侦听
		 * 
		 * @param	target	侦听对象
		 * @param	eventTypes	事件类型
		 * @param	handlers	事件处理
		 * 
		 * @return
		 */
		public static function removeListeners(target:IEventDispatcher, eventTypes:Vector.<String>, handlers:Vector.<Function>):IEventDispatcher
		{
			listeners(target == null ? null : target.removeEventListener, eventTypes, handlers);
			
			return target;
		}
		
		private static function listeners(execute:Function, eventTypes:Vector.<String>, handlers:Vector.<Function>):void
		{
			if (execute != null && eventTypes != null && handlers != null)
			{
				var length:int = Math.min(eventTypes.length, handlers.length);
				for (var i:int = 0; i < length; i++) 
				{
					if (eventTypes[i] != null && handlers[i] != null)
					{
						execute(eventTypes[i], handlers[i]);
					}
				}
			}
		}
	}

}