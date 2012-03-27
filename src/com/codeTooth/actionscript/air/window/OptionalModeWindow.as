package com.codeTooth.actionscript.air.window
{
	import flash.display.NativeWindow;
	import flash.display.NativeWindowInitOptions;
	import flash.events.Event;
	

	/**
	 * 可选的模态窗口基类
	 */
	public class OptionalModeWindow implements IWindow
	{
		
		/**
		 * 构造函数
		 * 
		 * @param nativeWindowInitOptions 窗口初始化参数
		 * @param mode 是否是模态窗口
		 */
		public function OptionalModeWindow(nativeWindowInitOptions:NativeWindowInitOptions, mode:Boolean = false)
		{
			nativeWindowInitOptions.minimizable = false;
			_window = new NativeWindow(nativeWindowInitOptions);
			_mode = mode;
		}
		
		public function get mode():Boolean
		{
			return _mode;
		}
		
		//----------------------------------------------------------------------------------------------------------------------------------
		// 显示的窗口
		//----------------------------------------------------------------------------------------------------------------------------------
		
		private var _window:NativeWindow = null;
		
		public function getWindow():NativeWindow
		{
			return _window;
		}
		
		//----------------------------------------------------------------------------------------------------------------------------------
		// 实现 IWindow 接口
		//----------------------------------------------------------------------------------------------------------------------------------
		
		private var _mode:Boolean = false;
		
		private var _modeListenerAdded:Boolean = false;
			
		public function show():void
		{
			if(_window != null)
			{
				_window.activate();
				_window.visible = true;
			}
			addModeListener();
		}
		
		public function hide():void
		{
			if(_window != null)
			{
				_window.visible = false;
			}
		}
		
		public function close():void
		{
			destroy();
		}
		
		// 添加模态窗口的侦听
		private function addModeListener():void
		{
			if(_window != null && _window.owner != null && _mode && !_modeListenerAdded)
			{
				_modeListenerAdded = true;
				_window.owner.addEventListener(Event.ACTIVATE, ownerActiveHandler);
			}
		}
		
		// 删除模态窗口的侦听
		private function removeModeListener():void
		{
			if(_window != null && _window.owner != null && _mode && _modeListenerAdded)
			{
				_modeListenerAdded = false;
				_window.owner.removeEventListener(Event.ACTIVATE, ownerActiveHandler);
			}
		}
		
		private function ownerActiveHandler(event:Event):void
		{
			_window.activate();
		}
		
		//----------------------------------------------------------------------------------------------------------------------------------
		// 实现 IDestroy 接口
		//----------------------------------------------------------------------------------------------------------------------------------
		
		public function destroy():void
		{
			removeModeListener();
			if(_window != null)
			{
				_window.close();
				_window = null;
			}
		}
	}
}