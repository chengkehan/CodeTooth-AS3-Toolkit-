package com.codeTooth.actionscript.game.action
{
	import com.codeTooth.actionscript.lang.exceptions.NullPointerException;
	import com.codeTooth.actionscript.lang.exceptions.UnsupportedException;
	import com.codeTooth.actionscript.lang.utils.destroy.DestroyUtil;
	import com.codeTooth.actionscript.lang.utils.destroy.IDestroy;
	
	import flash.display.Sprite;

	/**
	 * 帧动画组，可以同时播放多个帧动画
	 */
	public class ActionGroup extends Sprite implements IDestroy
	{
		// 所有需要同时播放的帧动画
		private var _actions:Vector.<Action> = null;
		
		// 是否可刷新
		private var _refreshable:Boolean = false;
		
		private var _actionsData:Vector.<ActionData> = null;
		
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
		
		public function getActionsData():Vector.<ActionData>
		{
			return _actionsData;
		}
		
		public function getActoins():Vector.<Action>
		{
			return _actions;
		}
		
		/**
		 * 播放到指定的一帧
		 * 
		 * @param index
		 */
		public function gotoClip(index:int):void
		{
			for each(var action:Action in _actions)
			{
				action.gotoClip(index);
			}
		}
		
		/**
		 * 是否可刷新
		 */
		public function set refreshable(bool:Boolean):void
		{
			_refreshable = bool;
		}
		
		/**
		 * @private
		 */
		public function get refreshable():Boolean
		{
			return _refreshable;
		}
		
		/**
		 * 刷新显示
		 */
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
		
		/**
		 * 跳转到下一帧
		 */
		public function nextClip():void
		{
			for each(var action:Action in _actions)
			{
				action.nextClip();
			}
		}
		
		//------------------------------------------------------------------------------------------------------------------------------
		// 重写鼠标交互
		//------------------------------------------------------------------------------------------------------------------------------
		
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
		
		//------------------------------------------------------------------------------------------------------------------------------
		// 实现 IDestroy 接口
		//------------------------------------------------------------------------------------------------------------------------------
		
		public function destroy():void
		{
			DestroyUtil.destroyVector(_actions);
			_actions = null;
			_actionsData = null;
		}
	}
}