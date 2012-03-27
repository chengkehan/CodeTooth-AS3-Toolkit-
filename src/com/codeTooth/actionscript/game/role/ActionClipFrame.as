package com.codeTooth.actionscript.game.role
{
	import com.codeTooth.actionscript.lang.utils.destroy.IDestroy;

	/**
	 * 动作剪辑帧
	 */
	public class ActionClipFrame implements IDestroy
	{
		// 帧上要显示的所有位图切片
		public var slices:Vector.<ActionClipFrameSlice> = null;
		
		public function ActionClipFrame(slices:Vector.<ActionClipFrameSlice> = null)
		{
			this.slices = slices;
		}
		
		//----------------------------------------------------------------------------------------------------------------------------------
		// 实现 IDestroy 接口
		//----------------------------------------------------------------------------------------------------------------------------------
		
		public function destroy():void
		{
			slices = null;
		}
	}
}