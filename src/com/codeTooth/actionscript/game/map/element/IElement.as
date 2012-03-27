package com.codeTooth.actionscript.game.map.element 
{
	import com.codeTooth.actionscript.lang.utils.destroy.IDestroy;
	import com.codeTooth.actionscript.lang.utils.uniqueObject.IUniqueObject;
	import com.codeTooth.actionscript.nativeInterface.IDisplayObject;
	
	import flash.display.BitmapData;
	import flash.display.DisplayObjectContainer;
	
	/**
	 * 地图元素接口
	 */
	public interface IElement extends IUniqueObject, IDestroy, IDisplayObject
	{
		/**
		 * 设置地图元素的显示列表中的索引值（这个是为了在深度排序的时候避免重复的调用setChildIndex，以此来提高效率）
		 */
		function set indexInDisplayList(index:int):void;
		
		/**
		 * 获得地图元素在显示列表中的索引值
		 */
		function get indexInDisplayList():int;
		
		/**
		 * 设置显示的位图
		 * 
		 * @param	bmpd
		 */
		function setFacade(bmpd:BitmapData):void;
		
		/**
		 * 获得显示的位图
		 * 
		 * @return
		 */
		function getFacade():BitmapData;
		
		/**
		 * 数据的id号
		 * 
		 * @return
		 */
		function getDataUniqueID():*;
		
		/**
		 * 矩形边界左上角x
		 */
		function get boundsX():Number;
		
		/**
		 * 矩形边界左上角y
		 */
		function get boundsY():Number;
		
		/**
		 * 矩形边界宽度
		 */
		function get boundsWidth():Number;
		
		/**
		 * 矩形边界高度
		 */
		function get boundsHeight():Number;
	}
	
}