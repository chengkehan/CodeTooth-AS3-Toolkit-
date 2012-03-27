package com.codeTooth.actionscript.lang.exceptions
{
	import com.codeTooth.actionscript.lang.utils.destroy.IDestroy;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	
	/**
	 * 全局异常
	 */
	public class GlobalExceptionHandler implements IDestroy
	{
		private var _eventDispatcher:Sprite = null;
		
		public function GlobalExceptionHandler()
		{
			_eventDispatcher = new Sprite();
		}
		
		/**
		 * 抛出全局异常
		 * 
		 * @param	exception 异常事件
		 */
		public function throwException(exception:GlobalExceptionEvent):void
		{
			_eventDispatcher.dispatchEvent(exception);
		}
		
		/**
		 * 侦听全局异常
		 * 
		 * @param	type 事件类型
		 * @param	handler 处理函数
		 */
		public function addEventListener(type:String, handler:Function):void
		{
			_eventDispatcher.addEventListener(type, handler);
		}
		
		/**
		 * 移除侦听的全局异常
		 * 
		 * @param	type 事件类型
		 * @param	handler 处理函数
		 */
		public function removeEventListener(type:String, handler:Function):void
		{
			_eventDispatcher.removeEventListener(type, handler);
		}
		
		/**
		 * 全局异常事件冒泡
		 * 
		 * @param	container 冒泡容器
		 * 
		 * @return
		 */
		public function startBubbles(container:DisplayObjectContainer):DisplayObjectContainer
		{
			if(container == null)
			{
				return null;
			}
			else
			{
				container.addChild(_eventDispatcher);
				
				return container;
			}
		}
		
		/**
		 * 停止异常事件冒泡
		 * 
		 * @return
		 */
		public function stopBubbles():DisplayObjectContainer
		{
			var parent:DisplayObjectContainer = _eventDispatcher.parent;
			
			if(parent != null)
			{
				parent.removeChild(_eventDispatcher);
			}
			
			return parent;
		}
		
		//--------------------------------------------------------------------------------------------------------------------------------
		// 实现 IDestroy 接口
		//--------------------------------------------------------------------------------------------------------------------------------
		
		public function destroy():void
		{
			if (_eventDispatcher != null)
			{
				if (_eventDispatcher.parent != null)
				{
					_eventDispatcher.parent.removeChild(_eventDispatcher);
				}
				_eventDispatcher = null;
			}
		}
	}
}