package com.codeTooth.actionscript.display.displayAreas
{
	import com.codeTooth.actionscript.lang.exceptions.NullPointerException;
	import com.codeTooth.actionscript.lang.utils.destroy.IDestroy;
	
	import flash.display.DisplayObject;
	import flash.utils.Dictionary;

	internal class Element implements IDestroy
	{
		public function Element(element:DisplayObject)
		{
			if(element == null)
			{
				throw new NullPointerException("Null element");
			}
			
			_displayAreaIDs = new Dictionary();
			_element = element;
		}
		
		//----------------------------------------------------------------------------------------------------------------------------------
		// Element
		//----------------------------------------------------------------------------------------------------------------------------------
		
		private var _element:DisplayObject = null;
		
		public function getElement():DisplayObject
		{
			return _element;
		}
		
		//----------------------------------------------------------------------------------------------------------------------------------
		// DisplayAreaIDs
		//----------------------------------------------------------------------------------------------------------------------------------
		
		private var _displayAreaIDs:Dictionary/*key id, value id*/ = null;
		
		public function getDisplayAreaIDs():Dictionary
		{
			return _displayAreaIDs;
		}
		
		public function addDisplayAreaID(displayAreaID:Object):void
		{
			_displayAreaIDs[displayAreaID] = displayAreaID;
		}
		
		public function removeDisplayAreaID(displayAreaID:Object):void
		{
			delete _displayAreaIDs[displayAreaID];
		}
		
		public function containsDisplayAreaID(displayAreaID:Object):Boolean
		{
			return _displayAreaIDs[displayAreaID] != null;
		}
		
		//----------------------------------------------------------------------------------------------------------------------------------
		// 实现 IDestroy 接口
		//----------------------------------------------------------------------------------------------------------------------------------
		
		public function destroy():void
		{
			_element = null;
			_displayAreaIDs = null;
		}
	}
}