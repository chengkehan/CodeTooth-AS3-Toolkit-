package com.codeTooth.actionscript.interaction.focus 
{
	import com.codeTooth.actionscript.lang.exceptions.NullPointerException;
	import com.codeTooth.actionscript.lang.utils.destroy.DestroyUtil;
	import com.codeTooth.actionscript.lang.utils.destroy.IDestroy;
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	
	/**
	 * 窗口焦点控制
	 */
	public class WindowFocus implements IDestroy
	{
		/**
		 * 构造函数
		 * 
		 * @param	container
		 * 
		 * @throws	com.codeTooth.actionscript.lang.exceptions.NullPointerException 
		 * 入参container是null
		 */
		public function WindowFocus(container:DisplayObjectContainer) 
		{
			if (container == null)
			{
				throw new NullPointerException();
			}
			
			initializeContainer(container);
			initializeWindows();
		}
		
		//----------------------------------------------------------------------------------------------------------------
		// 窗口
		//----------------------------------------------------------------------------------------------------------------
		
		private var _windows:Vector.<IWindowFocus> = null;
		
		private function initializeWindows():void
		{
			_windows = new Vector.<IWindowFocus>();
		}
		
		private function destroyWindows():void
		{
			if (_windows != null)
			{
				DestroyUtil.breakVector(_windows);
				_windows = null;
			}
		}
		
		/**
		 * 将一个窗口设为当前焦点窗口
		 * 
		 * @param	window
		 * 
		 * @return
		 */
		public function setTopWindow(window:IWindowFocus):IWindowFocus
		{
			if (window != null)
			{
				// 如果当前还没有焦点窗口，直接设置
				// 如果已经有焦点窗口，且新设置的窗口原来没有，直接设置
				// 如果已经有焦点窗口，且新设置的窗口原来就有，将这个窗口之后的其他窗口下降，将这个窗口置顶
				var numWindows:int = numberWindows;
				if (numWindows != 0)
				{
					var lastTopWindow:IWindowFocus = getTopWindow();
					lastTopWindow.deactive();
					
					var index:int = getWindowIndex(window);
					if (index != -1)
					{
						for (var i:int = index; i < numWindows - 1; i++)
						{
							_windows[i] = _windows[i + 1];
						}
						_windows[numWindows - 1] = window;
					}
					else
					{
						_windows[numWindows - 1].deactive();
						_windows.push(window);
					}
				}
				else
				{
					_windows.push(window);
				}
				window.active();
			}
			
			return window;
		}
		
		/**
		 * 获得当前的焦点窗口
		 * 
		 * @return
		 */
		public function getTopWindow():IWindowFocus
		{
			var numWindows:int = numberWindows;
			
			return numWindows == 0 ? null : _windows[numWindows - 1];
		}
		
		/**
		 * 删除当前的焦点窗口
		 * 
		 * @return
		 */
		public function removeTopWindow():IWindowFocus
		{
			return removeWindow(getTopWindow());
		}
		
		/**
		 * 删除指定的窗口
		 * 
		 * @param	window
		 * 
		 * @return
		 */
		public function removeWindow(window:IWindowFocus):IWindowFocus
		{
			if (window != null)
			{
				// 遍历所有的窗口，找到指定的窗口后，删除
				// 如果删除的正好是当前的焦点窗口，且还有窗口，找一个最上层的置顶
				var topWindow:IWindowFocus = getTopWindow();
				var numWindows:int = numberWindows;
				for (var i:int = 0; i < numWindows; i++)
				{
					if (_windows[i] == window)
					{
						_windows.splice(i, 1);
						window.deactive();
						
						numWindows--;
						if (window == topWindow && numWindows > 0)
						{
							_windows[numWindows - 1].active();
						}
						
						break;
					}
				}
			}
			
			return window;
		}
		
		/**
		 * 判断是否包含指定的窗口
		 * 
		 * @param	window
		 * @return
		 */
		public function contains(window:IWindowFocus):Boolean
		{
			var bool:Boolean = false;
			for each(var aWindow:IWindowFocus in _windows)
			{
				if (aWindow == window)
				{
					bool = true;
					break;
				}
			}
			
			return bool;
		}
		
		/**
		 * 得到当前窗口的数量
		 */
		public function get numberWindows():int
		{
			return _windows.length;
		}
		
		// 返回指定窗口的索引
		private function getWindowIndex(window:IWindowFocus):int
		{
			var index:int = -1;
			var numWindows:int = numberWindows;
			for (var i:int = 0; i < numWindows; i++)
			{
				if (_windows[i] == window)
				{
					index = i;
					break;
				}
			}
			
			return index;
		}
		
		private function containerMouseDownHandler(event:MouseEvent):void
		{
			// 窗口响应
			var target:Object = event.target;
			while(true)
			{
				if(target == null || target == _container)
				{
					target = null;
					break;
				}
				else
				{
					if(target is IWindowFocus)
					{
						break;
					}
					else
					{
						if(target.parent == null)
						{
							target = null;
							break;
						}
						else
						{
							target = target.parent;
						}
					}
				}
			}
			if (target != null)
			{
				setTopWindow(IWindowFocus(target));
			}
		}
		
		//----------------------------------------------------------------------------------------------------------------
		// 容器
		//----------------------------------------------------------------------------------------------------------------
		
		private var _container:DisplayObjectContainer = null;
		
		private function initializeContainer(container:DisplayObjectContainer):void
		{
			_container = container;
			_container.addEventListener(MouseEvent.MOUSE_DOWN, containerMouseDownHandler);
		}
		
		private function destroyContainer():void
		{
			if (_container != null)
			{
				DestroyUtil.breakVector(_windows);
				_windows = null;
				_container.removeEventListener(MouseEvent.MOUSE_DOWN, containerMouseDownHandler);
				_container = null;
			}
		}
		
		//----------------------------------------------------------------------------------------------------------------
		// 实现 IDestroy 接口
		//----------------------------------------------------------------------------------------------------------------
		
		public function destroy():void
		{
			destroyContainer();
			destroyWindows();
		}
	}

}