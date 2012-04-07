package com.codeTooth.actionscript.game.action
{
	import com.codeTooth.actionscript.lang.exceptions.IllegalOperationException;
	import com.codeTooth.actionscript.lang.utils.destroy.DestroyUtil;
	import com.codeTooth.actionscript.lang.utils.destroy.IDestroy;
	
	import flash.display.Sprite;
	import flash.utils.Dictionary;

	public class Actions extends Sprite implements IDestroy
	{
		private var _actions:Dictionary = null;
		
		private var _refreshable:Boolean = false;
		
		private var _prevAction:Action = null;
		
		public function Actions()
		{
			_actions = new Dictionary();
			_refreshable = true;
		}
		
		public function refresh(actionID:int, index:int = -1):void
		{
			if(!_refreshable)
			{
				return;
			}
			
			if(_actions[actionID] == null)
			{
				throw new IllegalOperationException("Repetitive actionID \"" + actionID + "\"");
			}
			
			var action:Action = _actions[actionID];
			if(_prevAction != action)
			{
				if(_prevAction != null && _prevAction.parent == this)
				{
					parent.removeChild(_prevAction);
				}
				_prevAction = action;
				if(_prevAction.parent != this)
				{
					addChild(_prevAction);
				}
			}
			if(index != -1)
			{
				_prevAction.gotoClip(index);
			}
			_prevAction.refreshClip();
		}
		
		public function set refreshable(bool:Boolean):void
		{
			_refreshable = bool;
		}
		
		public function get refreshable():Boolean
		{
			return _refreshable;
		}
		
		public function setAction(actionID:int, action:Action):void
		{
			if(containsAction(actionID))
			{
				throw new IllegalOperationException("Repetitive actionID \"" + actionID + "\"");
			}
			
			_actions[actionID] = action;
		}
		
		public function clearAction(actionID:int):Action
		{
			var action:Action = _actions[actionID];
			delete _actions[actionID];
			return action;
		}
		
		public function containsAction(actionID:int):Boolean
		{
			return _actions[actionID] != null;
		}
		
		public function getAction(actionID:int):Action
		{
			return _actions[actionID];
		}
		
		public function destroy():void
		{
			DestroyUtil.breakMap(_actions);
			_actions = null;
		}
	}
}