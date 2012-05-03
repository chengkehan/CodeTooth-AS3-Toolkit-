package com.codeTooth.actionscript.game.action
{
	import com.codeTooth.actionscript.lang.utils.destroy.DestroyUtil;
	import com.codeTooth.actionscript.lang.utils.destroy.IDestroy;
	import com.codeTooth.actionscript.lang.utils.newLoop.ISubLoop;
	
	import flash.utils.Dictionary;

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
		
		public function setAction(pAction:IAction):Boolean
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
		
		public function clearAction(pAction:IAction):Boolean
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