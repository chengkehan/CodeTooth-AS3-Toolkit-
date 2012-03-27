package com.codeTooth.actionscript.interaction.drag 
{
	/**
	 * 拖动释放目标
	 */
	public interface IDropTarget 
	{
		/**
		 * 是否允许释放
		 */
		function dropEnabled(dragData:DragData):Boolean;
		
		/**
		 * 设置释放的数据
		 * 
		 * @param	dragData
		 * 
		 * @return 返回处理后的释放数据
		 */
		function setDragData(dragData:DragData):DragData;
		
		/**
		 * 是否打断释放。打断释放时会抛出事件，可以使用事件中提供的方法来决定继续进行释放还是终止这次的行为
		 * 
		 * @param	dragData
		 * 
		 * @return
		 */
		function interruptDrop(dragData:DragData):Boolean;
		
		/**
		 * 释放目标属于
		 */
		function get dropBelongTo():Object;
	}
	
}