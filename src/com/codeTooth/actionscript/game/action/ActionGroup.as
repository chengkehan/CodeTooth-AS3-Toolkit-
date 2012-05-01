package com.codeTooth.actionscript.game.action
{
	import com.codeTooth.actionscript.lang.exceptions.NullPointerException;
	import com.codeTooth.actionscript.lang.exceptions.UnsupportedException;
	import com.codeTooth.actionscript.lang.utils.destroy.DestroyUtil;
	import com.codeTooth.actionscript.lang.utils.destroy.IDestroy;
	
	import flash.display.Sprite;

	public class ActionGroup extends Sprite implements IDestroy
	{
		private var _actions:Vector.<Action> = null;
		
		private var _refreshable:Boolean = false;
		
		public function ActionGroup(actionsData:Vector.<ActionData>)
		{
			if(actionsData == null)
			{
				throw new NullPointerException("Null input actionsData parameter.");
			}
			
			_actions = new Vector.<Action>(actionsData.length);
			var index:int = 0;
			for each(var actionData:ActionData in actionsData)
			{
				var action:Action = new Action(actionData);
				_actions[index++] = action;
				addChild(action);
			}
			
			mouseEnabled = false;
			_refreshable = true;
		}
		
		override public function set mouseChildren(enable:Boolean):void
		{
			throw new UnsupportedException("Unsupport function.");
		}
		
		override public function get mouseChildren():Boolean
		{
			return super.mouseChildren;
		}
		
		override public function set mouseEnabled(enabled:Boolean):void
		{
			super.mouseEnabled = enabled;
			super.mouseChildren = enabled;
		}
		
		override public function get mouseEnabled():Boolean
		{
			return super.mouseEnabled;
		}
		
		public function gotoClip(index:int):void
		{
			for each(var action:Action in _actions)
			{
				action.gotoClip(index);
			}
		}
		
		public function set refreshable(bool:Boolean):void
		{
			_refreshable = bool;
		}
		
		public function get refreshable():Boolean
		{
			return _refreshable;
		}
		
		public function refreshClip():void
		{
			if(!_refreshable)
			{
				return;
			}
			
			for each(var action:Action in _actions)
			{
				action.refreshClip();
			}
		}
		
		public function nextClip():void
		{
			for each(var action:Action in _actions)
			{
				action.nextClip();
			}
		}
		
		public function destroy():void
		{
			DestroyUtil.destroyVector(_actions);
			_actions = null;
		}
	}
}