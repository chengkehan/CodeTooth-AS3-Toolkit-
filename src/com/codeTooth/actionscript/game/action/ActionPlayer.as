package com.codeTooth.actionscript.game.action
{
	import com.codeTooth.actionscript.lang.utils.destroy.DestroyUtil;
	import com.codeTooth.actionscript.lang.utils.destroy.IDestroy;
	import com.codeTooth.actionscript.lang.utils.newLoop.ISubLoop;
	
	import flash.utils.Dictionary;

	/**
	 * 动画播放器
	 */
	public class ActionPlayer implements ISubLoop, IDestroy
	{
		private var _actions:Dictionary/*key IAction, value ActionItem*/ = null;
		
		private var _running:Boolean = true;
		
		private var _destroied:Boolean = false;
		
		public function ActionPlayer()
		{
			_actions = new Dictionary();
		}
		
		public function set running(bool:Boolean):void
		{
			_running = bool;
		}
		
		public function get running():Boolean
		{
			return _running;
		}
		
		/**
		 * 添加一个需要播放的动画
		 * 
		 * @param pAction
		 * 
		 * @return 如果已经存在返回false
		 */
		public function addAction(pAction:IAction):Boolean
		{
			if(_actions[pAction] == null)
			{
				var actionItem:ActionItem = new ActionItem(pAction);
				actionItem.frameTime = 1000 / actionItem.action.fps;
				_actions[pAction] = actionItem;
				return true;
			}
			else
			{
				return false;
			}
		}
		
		/**
		 * 设置动画的fps
		 * 
		 * @param fps
		 * @param pAction 指定的设置的那个动画。如果传入默认的null，就表示设置当前的全部。
		 * 
		 * @return 
		 */
		public function setFPS(fps:uint, pAction:IAction = null):Boolean
		{
			var item:ActionItem = null;
			if(pAction == null)
			{
				for each(item in _actions)
				{
					item.frameTime = 1000 / fps;
				}
				
				return true;
			}
			else
			{
				if(_actions[pAction] == null)
				{
					return false;
				}
				else
				{
					item = _actions[pAction];
					item.frameTime = 1000 / fps;
					return true;
				}
			}
		}
		
		/**
		 * 删除一个不需要播放的动画
		 * 
		 * @param pAction
		 * 
		 * @return 如果不存在返回false
		 */
		public function removeAction(pAction:IAction):Boolean
		{
			if(_actions[pAction] == null)
			{
				return false;
			}
			else
			{
				var action:ActionItem = _actions[pAction];
				delete _actions[pAction];
				return true;
			}
		}
		
		public function containsAction(pAction:IAction):Boolean
		{
			return _actions[pAction] != null;
		}

		//------------------------------------------------------------------------------------------------------------------------------
		// 实现 ISubLoop 接口
		//------------------------------------------------------------------------------------------------------------------------------
		
		public function get canEnter():Boolean
		{
			return _running;
		}

		public function get canExit():Boolean
		{
			return _destroied;
		}

		public function loop(prevTime:int, currTime:int):void
		{
			for each(var action:ActionItem in _actions)
			{
				action.sumTime += currTime - prevTime;
				if(action.sumTime > action.frameTime)
				{
					action.action.refreshClip();
					action.action.nextClip();
					action.sumTime -= action.frameTime;
				}
			}
		}

		//------------------------------------------------------------------------------------------------------------------------------
		// 实现 IDetroy 接口
		//------------------------------------------------------------------------------------------------------------------------------
		
		public function destroy():void
		{
			_destroied = true;
			DestroyUtil.breakMap(_actions);
			_actions = null;
		}
	}
}


import com.codeTooth.actionscript.game.action.IAction;

class ActionItem
{
	public var action:IAction = null;
	
	public var sumTime:int = 0;
	
	public var frameTime:int = 0;
	
	public function ActionItem(action:IAction)
	{
		this.action = action;
	}
}