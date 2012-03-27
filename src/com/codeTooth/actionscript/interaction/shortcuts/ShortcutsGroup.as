package com.codeTooth.actionscript.interaction.shortcuts 
{
	import com.codeTooth.actionscript.core.codeTooth_internal;
	import com.codeTooth.actionscript.lang.utils.collection.Collection;
	import com.codeTooth.actionscript.lang.utils.compare.CompareUtil;
	import com.codeTooth.actionscript.lang.utils.destroy.DestroyUtil;
	import com.codeTooth.actionscript.lang.utils.destroy.IDestroy;
	import com.codeTooth.actionscript.lang.utils.uniqueObject.IUniqueObject;
	import flash.utils.Dictionary;
	
	/**
	 * @private
	 */
	internal class ShortcutsGroup extends Collection 
									implements IUniqueObject
	{
		use namespace codeTooth_internal;
		
		public function ShortcutsGroup(id:Object) 
		{
			_id = id;
		}
		
		public function addShortcut(shortcut:Shortcut):Shortcut
		{
			if (shortcut == null)
			{
				return null;
			}
			else
			{
				return addItem(shortcut, shortcut);
			}
		}
		
		public function removeShortcut(shortcut:Shortcut):Shortcut
		{
			if (shortcut == null)
			{
				return null;
			}
			else
			{
				for each(var aShortcut:Shortcut in _items)
				{
					if (aShortcut.compare(shortcut) == CompareUtil.EQUAL)
					{
						return removeItem(aShortcut);
					}
				}
				
				return null;
			}
		}
		
		public function containsShortcut(shortcut:Shortcut):Boolean
		{
			if (shortcut == null)
			{
				return false;
			}
			else
			{
				for each(var aShortcut:Shortcut in _items)
				{
					if (aShortcut.compare(shortcut) == CompareUtil.EQUAL)
					{
						return true;
					}
				}
				
				return false;
			}
		}
		
		public function getShortcuts():Dictionary
		{
			return _items;
		}
		
		//-----------------------------------------------------------------------------------------------------------------------------------------
		// 实现 IUniqueObject 接口
		//-----------------------------------------------------------------------------------------------------------------------------------------
		
		private var _id:Object = null;
		
		public function getUniqueID():*
		{
			return _id;
		}
		
		//-----------------------------------------------------------------------------------------------------------------------------------------
		// 重写IDestroy 接口
		//-----------------------------------------------------------------------------------------------------------------------------------------
		
		override public function destroy():void
		{
			DestroyUtil.destroyMap(_items);
			_items = null;
		}
	}

}