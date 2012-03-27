package com.codeTooth.actionscript.game.role
{
	import com.codeTooth.actionscript.lang.utils.destroy.IDestroy;

	/**
	 * 动作剪辑
	 */
	public class ActionClip implements IDestroy
	{
		// 动作剪辑的方向
		public var direction:ClipDirection = null;
		
		// 剪辑中所有的帧
		public var frames:Vector.<ActionClipFrame> = null;
		
		public function ActionClip(direction:ClipDirection, frames:Vector.<ActionClipFrame> = null)
		{
			this.direction = direction;
			this.frames = frames;
		}
		
		//-------------------------------------------------------------------------------------------------------------------------------
		// 实现 IDestoy 接口
		//-------------------------------------------------------------------------------------------------------------------------------
		
		public function destroy():void
		{
			direction = null;
			frames = null;
		}
	}
}