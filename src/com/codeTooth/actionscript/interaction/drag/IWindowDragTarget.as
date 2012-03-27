package com.codeTooth.actionscript.interaction.drag 
{
	import flash.display.DisplayObject;
	
	/**
	 * 可拖动窗口对象实现的接口
	 */
	public interface IWindowDragTarget 
	{
		/**
		 * 当前是否可拖动
		 */
		function get dragable():Boolean;
		
		/**
		 * 鼠标的矩形响应区域
		 */
		function get hitAreas():Vector.<DisplayObject>;
		
		/**
		 * 绑定的对象。如果是null则表示拖动实现该接口本身的对象，如果指向另一个对象，则拖动指向的对象。
		 */
		function get bindingTarget():DisplayObject;
	}
	
}