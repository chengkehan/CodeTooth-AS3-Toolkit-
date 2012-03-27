package com.codeTooth.actionscript.interaction.drag 
{
	/**
	 * 拖动发起者
	 */
	public interface IDragInitiator 
	{
		/**
		 * 是否允许拖动
		 */
		function get dragEnabled():Boolean;
		
		/**
		 * 获得拖动的数据
		 * 
		 * @return
		 */
		function getDragData():DragData;
		
		/**
		 * 成功在目标上释放时的响应
		 * 
		 * @param	dragData
		 */
		function dropResponse(dragData:DragData):void;
		
		/**
		 * 发起者属于
		 */
		function get dragBelongTo():Object;
	}
	
}