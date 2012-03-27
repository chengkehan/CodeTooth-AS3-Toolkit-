package com.codeTooth.actionscript.interaction.drag 
{
	import flash.display.DisplayObject;
	
	public class DragData
	{
		private var _data:Object = null;
		
		private var _sanpshot:DisplayObject = null;
		
		private var _offsetX:Number = 0;
		
		private var _offsetY:Number = 0;
		
		private var _dropSuccess:Boolean = false;
		
		private var _from:Object = null;
		
		private var _to:Object = null;
		
		public function DragData(data:Object = null, snapshot:DisplayObject = null, offsetX:Number = 0, offsetY:Number = 0) 
		{
			_data = data;
			_sanpshot = snapshot;
			_offsetX = offsetX;
			_offsetY = offsetY;
		}
		
		public function set from(obj:Object):void
		{
			_from = obj;
		}
		
		public function get from():Object
		{
			return _from;
		}
		
		public function set to(obj:Object):void
		{
			_to = obj;
		}
		
		public function get to():Object
		{
			return _to;
		}
		
		public function set data(data:Object):void
		{
			_data = data;
		}
		
		public function get data():Object
		{
			return _data;
		}
		
		public function set snapshot(obj:DisplayObject):void
		{
			_sanpshot = obj;
		}
		
		public function get snapshot():DisplayObject
		{
			return _sanpshot;
		}
		
		public function set offsetX(value:Number):void
		{
			_offsetX = value;
		}
		
		public function get offsetX():Number
		{
			return _offsetX;
		}
		
		public function set offsetY(value:Number):void
		{
			_offsetY = value;
		}
		
		public function get offsetY():Number
		{
			return _offsetY;
		}
		
		public function set dropSuccess(bool:Boolean):void
		{
			_dropSuccess = bool;
		}
		
		public function get dropSuccess():Boolean
		{
			return _dropSuccess;
		}
	}

}