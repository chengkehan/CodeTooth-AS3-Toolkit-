package com.codeTooth.actionscript.game.role
{
	import com.codeTooth.actionscript.lang.utils.destroy.IDestroy;

	/**
	 * 角色动作剪辑
	 */
	public class RoleActionClip implements IDestroy
	{
		// 动作剪辑的方向
		private var _direction:ClipDirection = null;
		
		// 剪辑中所有的帧
		private var _frames:Vector.<RoleActionClipFrame> = null;
		
		// 当前的帧索引
		private var _currFrameIndex:uint = 0;
		
		public function RoleActionClip(direction:ClipDirection, frames:Vector.<RoleActionClipFrame>)
		{
			_direction = direction;
			_frames = frames;
		}
		
		public function play():RoleActionClipFrame
		{
			if(_frames == null || _frames.length == 0)
			{
				return null;
			}
			else
			{
				if(_currFrameIndex >= _frames.length)
				{
					_currFrameIndex = 0;
				}
				
				return _frames[_currFrameIndex++];
			}
		}
		
		public function getDirection():ClipDirection
		{
			return _direction;
		}
		
		public function getFrames():Vector.<RoleActionClipFrame>
		{
			return _frames;
		}
		
		//--------------------------------------------------------------------------------------------------------------------------------------
		// 实现 IDestroy 接口
		//--------------------------------------------------------------------------------------------------------------------------------------
		
		public function destroy():void
		{
			_direction = null;
			_frames = null;
		}
	}
}