package com.codeTooth.actionscript.game.role
{
	import com.codeTooth.actionscript.lang.utils.destroy.IDestroy;
	
	import flash.utils.Dictionary;

	/**
	 * 角色动作
	 */
	public class RoleAction implements IDestroy
	{
		// 动作的名称
		private var _name:String = null;
		
		// 动作所有的剪辑
		private var _clips:Dictionary/*key ClipDirection, value RoleActionClip*/ = null;
		
		public function RoleAction(name:String, clips:Dictionary)
		{
			_name = name;
			_clips = clips;
		}
		
		public function get name():String
		{
			return _name;
		}
		
		public function getClips():Dictionary
		{
			return _clips;
		}
		
		//--------------------------------------------------------------------------------------------------------------------------------
		// 实现 IDestroy 接口
		//--------------------------------------------------------------------------------------------------------------------------------
		
		public function destroy():void
		{
			_clips = null;
		}
	}
}