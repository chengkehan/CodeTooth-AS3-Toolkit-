package com.codeTooth.actionscript.game.role
{
	import com.codeTooth.actionscript.lang.utils.destroy.IDestroy;
	
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	/**
	 * 动作剪辑帧切片
	 */
	public class ActionClipFrameSlice implements IDestroy
	{
		// 切片的位图对象
		public var bitmapData:BitmapData = null;
		
		// 切片的矩形
		public var rectangle:Rectangle = null;
		
		// 切片显示到的目标点
		public var destPoint:Point = null;
		
		// 切片显示的的深度
		public var depth:int = 0;
		
		public function ActionClipFrameSlice(bmpd:BitmapData, rect:Rectangle, destPoint:Point, depth:int)
		{
			this.bitmapData = bmpd;
			this.rectangle = rect;
			this.destPoint = destPoint;
			this.depth = depth;
		}
		
		//-------------------------------------------------------------------------------------------------------------------------------------
		// 实现 IDestroy 接口
		//-------------------------------------------------------------------------------------------------------------------------------------
		
		public function destroy():void
		{
			bitmapData = null;
			rectangle = null;
			destPoint = null;
		}
	}
}