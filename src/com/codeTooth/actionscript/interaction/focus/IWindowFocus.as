package com.codeTooth.actionscript.interaction.focus 
{
	/**
	 * 焦点窗口实现的接口
	 */
	public interface IWindowFocus 
	{
		/**
		 * 激活窗口
		 */
		function active():void;
		
		/**
		 * 取消激活的窗口
		 */
		function deactive():void;
		
		/**
		 * 窗口默认执行的动作。比如，当一个窗口获得焦点时，按下回车键默认执行的动作等于用户按下确定按钮。
		 */
		function defaultExecute():void;
	}
	
}