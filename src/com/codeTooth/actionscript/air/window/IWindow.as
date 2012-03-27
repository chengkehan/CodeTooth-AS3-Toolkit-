package com.codeTooth.actionscript.air.window
{
	import com.codeTooth.actionscript.lang.utils.destroy.IDestroy;
	
	import flash.display.NativeWindow;

	/**
	 * 窗口接口
	 */
	public interface IWindow extends IDestroy
	{
		/**
		 * 显示窗口
		 */
		function show():void;
		
		/**
		 * 隐藏窗口。当不需要显示窗口的时候，应该隐藏窗口，而不是关闭窗口，关闭窗口相当于销毁掉窗口
		 */
		function hide():void;
		
		/**
		 * 关闭窗口
		 */
		function close():void;
	}
}