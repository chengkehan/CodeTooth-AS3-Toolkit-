package com.codeTooth.actionscript.air.menu
{
	import com.adobe.utils.StringUtil;
	
	import flash.display.NativeMenu;
	import flash.display.NativeMenuItem;
	import flash.display.NativeWindow;
	import flash.events.Event;
	
	/**
	 * 菜单。为AIR应用程序提供快速建立菜单的功能。
	 */
	public class Menu
	{
		private static var _menuXML:XML = null;
		
		private static var _nativeWindow:NativeWindow = null;
		
		private static var _context:Object = null;
		
		/**
		 * 构造函数
		 * 
		 * @param	menuXML 菜单XML数据
		 * @param	nativeWindow 相关联的窗口
		 * @param	context 菜单的上下文
		 * 
		 * @return	返回是否成功创建菜单
		 * 
		 * @example
		 * 输入的XML格式
		 * <listing>
		 * &lt;data&gt;
		 * 	&lt;item label="File" onClick=""&gt;
		 * 		&lt;item label="Open" onClick=""/&gt;
		 * 		&lt;item label="New" onClick=""/&gt;
		 * 	&lt;/item&gt;
		 * 	&lt;item label="Edit"&gt;
		 * 		&lt;item label="Copy" onClick=""/&gt;
		 * 		&lt;item label="Paste" onClick=""/&gt;
		 * 		&lt;item label="Level"&gt;
		 * 			&lt;item label="1" onClick=""/&gt;
		 * 			&lt;item label="2" onClick=""/&gt;
		 * 		&lt;/item&gt;
		 * 	&lt;/item&gt;
		 * &lt;/data&gt;
		 * </listing>
		 */
		public static function createMenu(menuXML:XML, nativeWindow:NativeWindow, context:Object = null):Boolean
		{
			_menuXML = menuXML;
			_nativeWindow = nativeWindow;
			_context = context;
			
			if(_nativeWindow != null && _menuXML != null && _menuXML.item != undefined)
			{
				var nativeMenu:NativeMenu = new NativeMenu();
				_nativeWindow.menu = nativeMenu;
				createSubMenu(nativeMenu, _menuXML.item);
				_menuXML = null;
				_nativeWindow = null;
				_context = null;
				
				return true;
			}
			else
			{
				_menuXML = null;
				_nativeWindow = null;
				_context = null;
				
				return false;
			}
		}
		
		private static function createSubMenu(parent:NativeMenu, itemsXMLList:XMLList):void
		{
			var menuItem:NativeMenuItem;
			var menu:NativeMenu;
			var attributesXMLList:XMLList;
			var name:String;
			
			for each(var itemXML:XML in itemsXMLList)
			{
				if(itemXML.item == undefined)
				{
					// Create menu item
					menuItem = new NativeMenuItem(itemXML.@label == undefined ? "" : String(itemXML.@label), 
																		StringUtil.toBoolean(itemXML.@isSeparator));
					parent.addItem(menuItem);
					
					if(itemXML.@onClick != undefined && _context != null)
					{
						menuItem.addEventListener(Event.SELECT, _context[String(itemXML.@onClick)]);
					}
				}
				else
				{
					// Create sub menu
					menu = new NativeMenu();
					parent.addSubmenu(menu, itemXML.@label == undefined ? "" : String(itemXML.@label));
					
					if(itemXML.@onClick != undefined && _context != null)
					{
						menuItem.addEventListener(Event.SELECT, _context[String(itemXML.@onCLick)]);
					}
					
					createSubMenu(menu, itemXML.item);
				}
			}
		}
	}
}