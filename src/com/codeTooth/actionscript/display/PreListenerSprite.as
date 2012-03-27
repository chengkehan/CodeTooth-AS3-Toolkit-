package com.codeTooth.actionscript.display 
{
	import com.codeTooth.actionscript.lang.utils.destroy.IDestroy;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class PreListenerSprite extends Sprite 
										implements IDestroy
	{
		
		public function PreListenerSprite() 
		{
			initalizeListeners();
		}
		
		//----------------------------------------------------------------------------------------------------------------
		// 点击事件
		//----------------------------------------------------------------------------------------------------------------
		
		private var _clickHandler:Function = null;
		
		public function set clickHandler(handler:Function):void
		{
			_clickHandler = handler;
		}
		
		public function get clickHandler():Function
		{
			return _clickHandler;
		}
		
		private function clickHandlerInternal(event:MouseEvent):void
		{
			if (_clickHandler != null)
			{
				if (_clickHandler.length == 0)
				{
					_clickHandler();
				}
				else
				{
					_clickHandler(event);
				}
			}
		}
		
		//----------------------------------------------------------------------------------------------------------------
		// Listeners
		//----------------------------------------------------------------------------------------------------------------
		
		protected function addToStageExecute():void
		{
			addEventListener(MouseEvent.CLICK, clickHandlerInternal);
		}
		
		protected function removeFromStageExecute():void
		{
			removeEventListener(MouseEvent.CLICK, clickHandlerInternal);
		}
		
		private function addToStageHandler(event:Event):void 
		{
			addEventListener(Event.REMOVED_FROM_STAGE, removeFromStageHandler);
			addToStageExecute();
		}
		
		private function removeFromStageHandler(event:Event):void 
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, removeFromStageHandler);
			removeFromStageExecute();
		}
		
		private function initalizeListeners():void
		{
			addEventListener(Event.ADDED_TO_STAGE, addToStageHandler);
		}
		
		private function destroyListeners():void
		{
			removeEventListener(Event.ADDED_TO_STAGE, addToStageHandler);
			removeEventListener(Event.REMOVED_FROM_STAGE, removeFromStageHandler);
			removeFromStageExecute();
		}
		
		//----------------------------------------------------------------------------------------------------------------
		// 实现 IDestroy 接口
		//----------------------------------------------------------------------------------------------------------------
		
		public function destroy():void
		{
			destroyListeners();
			_clickHandler = null;
		}
	}

}