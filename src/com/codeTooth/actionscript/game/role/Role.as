package com.codeTooth.actionscript.game.role
{
	import com.codeTooth.actionscript.lang.utils.Common;
	import com.codeTooth.actionscript.lang.utils.destroy.DestroyUtil;
	import com.codeTooth.actionscript.lang.utils.destroy.IDestroy;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.utils.Dictionary;

	/**
	 * 角色
	 */
	public class Role extends Sprite implements IDestroy
	{
		/**
		 * 构造函数
		 * 
		 * @param actions	角色的所有动作
		 */
		public function Role(actions:Vector.<Action>)
		{
			setActions(actions);
			initializeCanvas();
			mouseChildren = false;
		}
		
		//-----------------------------------------------------------------------------------------------------------------------------------
		// Canvas
		//-----------------------------------------------------------------------------------------------------------------------------------
		
		private var _canvas:Bitmap = null;
		
		private function initializeCanvas():void
		{
			_canvas = new Bitmap();
			addChild(_canvas);
		}
		
		private function destroyCanvas():void
		{
			if(_canvas != null)
			{
				if(_canvas.parent == this)
				{
					removeChild(_canvas);
				}
				_canvas.bitmapData = null;
				_canvas = null;
			}
		}
		
		//-----------------------------------------------------------------------------------------------------------------------------------
		// RoleActions
		//-----------------------------------------------------------------------------------------------------------------------------------
		
		private var _actions:Dictionary/*key name, value RoleAction*/ = null;
		
		/**
		 * 播放一个动作
		 * 
		 * @param name	动作的名称
		 * @param direction	动作的方向
		 * 
		 * @return	返回是否成功播放
		 */
		public function playAction(name:String, direction:ClipDirection):Boolean
		{
			// 不存在指定名称的动作
			if(_actions[name] == null)
			{
				return false;
			}
			else
			{
				var action:RoleAction = _actions[name];
				var clips:Dictionary = action.getClips();
				if(clips == null || clips[direction] == null)
				{
					// 动作中没有剪辑，或，不存在指定方向的剪辑
					return false;
				}
				else
				{
					var clip:RoleActionClip = clips[direction];
					var frame:RoleActionClipFrame = clip.play();
					if(frame == null || frame.getBitmapData() == null)
					{
						_canvas.bitmapData = null;
						_canvas.x = 0;
						_canvas.y = 0;
					}
					else
					{
						_canvas.bitmapData = frame.getBitmapData();
						_canvas.x = -frame.standOnX;
						_canvas.y = -frame.standOnY;
					}
					
					return true;
				}
			}
		}
		
		/**
		 * 添加动作
		 * 
		 * @param action
		 * 
		 * @return	返回成功添加动作对象 
		 */
		public function addAction(action:Action):RoleAction
		{
			if(action == null)
			{
				return null;
			}
			else
			{
				var roleAction:RoleAction = RoleActionCreator.create(action);
				_actions[action.name] = roleAction;
				return roleAction;
			}
		}
		
		/**
		 * 删除动作
		 * 
		 * @param name	指定要删除的动作的名称
		 * 
		 * @return	返回成功删除的动作对象
		 */
		public function removeAction(name:String):RoleAction
		{
			var action:RoleAction = _actions[name];
			delete _actions[name];
			return action;
		}
		
		/**
		 * 获得一个动作
		 * 
		 * @param name	
		 * 
		 * @return 
		 */
		public function getAction(name:String):RoleAction
		{
			return _actions[name];
		}
		
		/**
		 * 判断是否包含指定的动作
		 * 
		 * @param name
		 * 
		 * @return 
		 */
		public function containsAction(name:String):Boolean
		{
			return _actions[name] != null;
		}
		
		/**
		 * 获得所有的动作
		 * 
		 * @return 
		 */
		public function getActions():Dictionary
		{
			return _actions;
		}
		
		/**
		 * 设置所有的动作
		 * 
		 * @param actions
		 * 
		 * @return 
		 */
		public function setActions(actions:Vector.<Action>):Boolean
		{
			DestroyUtil.breakMap(_actions);
			_actions = new Dictionary();
			
			if(actions != null && actions.length != 0)
			{
				var result:Boolean = false;
				for each(var action:Action in actions)
				{
					var roleAction:RoleAction = RoleActionCreator.create(action);
					if(action != null)
					{
						_actions[action.name] = roleAction;
						result = true;
					}
				}
				
				return result;
			}
			else
			{
				return false;
			}
		}
		
		private function destroyActions():void
		{
			DestroyUtil.breakMap(_actions);
			_actions = null;
		}
		
		//-----------------------------------------------------------------------------------------------------------------------------------
		// 实现 IDestroy 接口
		//-----------------------------------------------------------------------------------------------------------------------------------
		
		public function destroy():void
		{
			destroyCanvas();
			destroyActions();
		}
	}
}