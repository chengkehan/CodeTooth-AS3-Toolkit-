package com.codeTooth.actionscript.interaction.shortcuts 
{
	import com.codeTooth.actionscript.lang.exceptions.NullPointerException;
	import com.codeTooth.actionscript.lang.utils.destroy.DestroyUtil;
	import com.codeTooth.actionscript.lang.utils.destroy.IDestroy;
	
	import flash.display.Stage;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.text.TextField;
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;
	
	/**
	 * 快捷键管理类
	 */
	public class ShortcutsManager implements IDestroy
	{
		/**
		 * 构造函数
		 * 
		 * @param	stage	用来侦听键盘事件的舞台对象
		 * @param	autoDisabledWhenFocusInTextField	当焦点在文本框中时自动失效，以避免输入文字时的按键触发快捷键
		 * 
		 * @throws	com.codeTooth.actionscript.lang.exceptions.NullPointerException 
		 * 指定的舞台对象是null
		 */
		public function ShortcutsManager(stage:Stage, autoDisabledWhenFocusInTextField:Boolean = true) 
		{
			if (stage == null)
			{
				throw new NullPointerException();
			}
			
			_groups = new Dictionary();
			_keyDownThisTurn = new Dictionary();
			_globalBindingTarget = new GlobalBindingTarget();
			_autoDisabledWhenFocusInTextField = autoDisabledWhenFocusInTextField;
			initializeStage(stage);
		}
		
		//--------------------------------------------------------------------------------------------------------------------------------------------------
		// 启用
		// 失效
		//--------------------------------------------------------------------------------------------------------------------------------------------------
		
		// 启用
		private var _enabled:Boolean = true;
		
		/**
		 * 启用键盘侦听
		 */
		public function set enabled(bool:Boolean):void
		{
			_enabled = bool;
		}
		
		/**
		 * @private
		 */
		public function get enabled():Boolean
		{
			return _enabled;
		}
		
		private var _autoDisabledWhenFocusInTextField:Boolean = false;
		
		/**
		 * 当焦点在文本框中时自动失效，以避免输入文字时的按键触发快捷键
		 */
		public function get autoDisabledWhenFocusInTextField():Boolean
		{
			return _autoDisabledWhenFocusInTextField;
		}
		
		//--------------------------------------------------------------------------------------------------------------------------------------------------
		// ShortcutsGroups
		//--------------------------------------------------------------------------------------------------------------------------------------------------
		
		// 全局绑定对象
		private var _globalBindingTarget:GlobalBindingTarget = null;
		
		// 当前使用的绑定对象
		private var _currentBindingTarget:Object = null;
		
		// 快捷键组
		// 快捷键会被分组，绑定到同一对象上的快捷键会被分在一组中
		private var _groups:Dictionary = null;
		
		/**
		 * 获得全局绑定对象
		 * 
		 * @return
		 */
		public function getGlobalBindingTarget():*
		{
			return _globalBindingTarget;
		}
		
		/**
		 * 设置当前使用的绑定对象。使用绑定到当前绑定对象上的快捷键，或者，绑定到全局对象上的快捷键才会触发
		 * 
		 * @param	target
		 */
		public function setCurrentBindingTarget(target:Object):void
		{
			_currentBindingTarget = target;
		}
		
		/**
		 * 获得当前设置的绑定对象
		 * 
		 * @return
		 */
		public function getCurrentBindingTarget():Object
		{
			return _currentBindingTarget;
		}
		
		/**
		 * 添加一个快捷键
		 * 
		 * @param	shortcut	快捷键对象
		 * @param	bindingTarget	绑定到的对象。如果没有指定则自动绑定到全局对象
		 * 
		 * @return	返回被成功添加的快捷键
		 */
		public function addShortcut(shortcut:Shortcut, bindingTarget:Object = null):Shortcut
		{
			if (shortcut == null)
			{
				return null;
			}
			else
			{
				return getGroup(bindingTarget == null ? _globalBindingTarget : bindingTarget).addShortcut(shortcut);
			}
		}
		
		/**
		 * 删除一个快捷键
		 * 
		 * @param	shortcut
		 * @param	bindingTarget 指定删除的快捷键的绑定对象，没有指定的话会自动在全局对象上查找
		 * 
		 * @return	返回被成功删除的快捷键
		 */
		public function removeShortcut(shortcut:Shortcut, bindingTarget:Object = null):Shortcut
		{
			if (shortcut == null || _groups[bindingTarget] == undefined)
			{
				return null;
			}
			else
			{
				return getGroup(bindingTarget == null ? _globalBindingTarget : bindingTarget).removeShortcut(shortcut);
			}
		}
		
		/**
		 * 从所有绑定对象中删除指定的快捷键
		 * 
		 * @param	shortcut
		 * 
		 * @return	返回被成功删除快捷键
		 */
		public function removeShortcutFromShortcutsManager(shortcut:Shortcut):Shortcut
		{
			if (shortcut == null)
			{
				return null;
			}
			else
			{
				var removed:Shortcut = null;
				for each(var group:ShortcutsGroup in _groups)
				{
					removed = group.removeShortcut(shortcut);
				}
				
				return removed;
			}
		}
		
		/**
		 * 判断在指定的绑定对象上是否包含指定的快捷键
		 * 
		 * @param	shortcut
		 * @param	bindingTarget
		 * 
		 * @return
		 */
		public function containsShortcut(shortcut:Shortcut, bindingTarget:Object = null):Boolean
		{
			if (shortcut == null || _groups[bindingTarget] == undefined)
			{
				return false;
			}
			else
			{
				return getGroup(bindingTarget == null ? _globalBindingTarget : bindingTarget).containsShortcut(shortcut);
			}
		}
		
		/**
		 * 判断在所有绑定对象上是否能找到指定的快捷键
		 * 
		 * @param	shortcut
		 * 
		 * @return
		 */
		public function containsShortcutInShortcutsManager(shortcut:Shortcut):Boolean
		{
			if (shortcut == null)
			{
				return false;
			}
			else
			{
				for each(var group:ShortcutsGroup in _groups)
				{
					if (group.containsShortcut(shortcut))
					{
						return true;
					}
				}
				
				return false;
			}
		}
		
		/**
		 * 获得指定快捷键所有绑定到的对象
		 * 
		 * @param	shortcut
		 * 
		 * @return
		 */
		public function getShortcutBindingTargets(shortcut:Shortcut):Vector.<Object>
		{
			if (shortcut == null)
			{
				return null;
			}
			else
			{
				var bindingTargets:Vector.<Object> = new Vector.<Object>();
				for (var bindingTarget:Object in _groups)
				{
					if (_groups[bindingTarget].containsShortcut(shortcut))
					{
						bindingTargets.push(bindingTarget);
					}
				}
				
				return bindingTargets;
			}
		}
		
		/**
		 * 获得指定绑定对象中的所有快捷键
		 * 
		 * @param	bindingTarget
		 * 
		 * @return
		 */
		public function getShortcuts(bindingTarget:Object):Dictionary
		{
			if (_groups[bindingTarget] == undefined)
			{
				return null;
			}
			else
			{
				return getGroup(bindingTarget).getShortcuts();
			}
		}
		
		private function getGroup(id:Object):ShortcutsGroup
		{
			if (_groups[id] == undefined)
			{
				var group:ShortcutsGroup = new ShortcutsGroup(id);
				_groups[id] = group;
				
				return group;
			}
			else
			{
				return _groups[id];
			}
		}
		
		private function destroyGroups():void
		{
			DestroyUtil.destroyMap(_groups);
			_groups = null;
		}
		
		//--------------------------------------------------------------------------------------------------------------------------------------------------
		// Stage
		//--------------------------------------------------------------------------------------------------------------------------------------------------
		
		private var _stage:Stage = null;
		
		private var _keyStatus:int = 0;
		
		private var _keyDownThisTurn:Dictionary = null;
		
		private function stageKeyUpHandler(event:KeyboardEvent):void
		{
			if (_enabled)
			{
				groupsExecute(event, false);
				
				for each(var shortcut:Shortcut in _keyDownThisTurn)
				{
					shortcut.keyDownCount = 0;
				}
				DestroyUtil.breakMap(_keyDownThisTurn);
			}
		}
		
		private function stageKeyDownHandler(event:KeyboardEvent):void
		{
			if (_enabled)
			{
				groupsExecute(event, true);
			}
		}
		
		private function groupsExecute(event:KeyboardEvent, keyDown:Boolean):void
		{
			var shortcuts:Dictionary;
			for each(var group:ShortcutsGroup in _groups)
			{
				if (group.getUniqueID() == _globalBindingTarget || group.getUniqueID() == _currentBindingTarget)
				{
					shortcuts = group.getShortcuts();
					for each(var shortcut:Shortcut in shortcuts)
					{
						if (shortcut.keyDown == keyDown && shortcut.ctrlKey == event.ctrlKey && 
							shortcut.shiftKey == event.shiftKey && shortcut.altKey == event.altKey && 
							shortcut.keyCode == event.keyCode && shortcut.execute != null)
						{
							if ((shortcut.keyDownOnce && shortcut.keyDownCount == 0) || !shortcut.keyDownOnce)
							{
								_keyDownThisTurn[shortcut] = shortcut;
								shortcut.keyDownCount++;
								shortcut.execute();
							}
						}
					}
				}
			}
		}
		
		private function stageFocusInHandler(event:FocusEvent):void
		{
			if (event.target is TextField || 
				getQualifiedClassName(event.target) == "spark.components::RichEditableText")
			{
				_enabled = false;
			}
		}
		
		private function stageFocusOutHandler(event:FocusEvent):void
		{
			if (event.target is TextField || 
				getQualifiedClassName(event.target) == "spark.components::RichEditableText")
			{
				_enabled = true;
			}
		}
		
		private function initializeStage(stage:Stage):void
		{
			_stage = stage;
			_stage.addEventListener(KeyboardEvent.KEY_UP, stageKeyUpHandler);
			_stage.addEventListener(KeyboardEvent.KEY_DOWN, stageKeyDownHandler);
			
			if (_autoDisabledWhenFocusInTextField)
			{
				_stage.addEventListener(FocusEvent.FOCUS_IN, stageFocusInHandler);
				_stage.addEventListener(FocusEvent.FOCUS_OUT, stageFocusOutHandler);
			}
		}
		
		private function destroyStage():void
		{
			if (_stage != null)
			{
				if (_autoDisabledWhenFocusInTextField)
				{
					_stage.removeEventListener(FocusEvent.FOCUS_IN, stageFocusInHandler);
					_stage.removeEventListener(FocusEvent.FOCUS_OUT, stageFocusOutHandler);
				}
				
				_stage.removeEventListener(KeyboardEvent.KEY_UP, stageKeyUpHandler);
				_stage.removeEventListener(KeyboardEvent.KEY_DOWN, stageKeyDownHandler);
				_stage = null;
				
				DestroyUtil.breakMap(_keyDownThisTurn);
				_keyDownThisTurn = null;
			}
		}
		
		//--------------------------------------------------------------------------------------------------------------------------------------------------
		// 实现 IDestroy 接口
		//--------------------------------------------------------------------------------------------------------------------------------------------------
		
		public function destroy():void
		{
			destroyStage();
			destroyGroups();
		}
	}

}


class GlobalBindingTarget
{
	public function GlobalBindingTarget()
	{
		
	}
	
	public function toString():String
	{
		return "[object GlobalBindingTarget]";
	}
}