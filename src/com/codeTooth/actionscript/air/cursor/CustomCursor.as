package com.codeTooth.actionscript.air.cursor
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.ui.Mouse;
	import flash.ui.MouseCursorData;
	import flash.utils.Dictionary;

	public class CustomCursor
	{
		private static var _cursorNames:Dictionary = new Dictionary();
		
		public static function showCursor():void
		{
			Mouse.show();
		}
		
		public static function hideCursor():void
		{
			Mouse.hide();
		}
		
		public static function containsCursor(cursorName:String):Boolean
		{
			return _cursorNames[cursorName] != null || cursorName in Mouse;
		}
		
		public static function set cursor(cursorName:String):void
		{
			Mouse.cursor = cursorName;
		}
		
		public static function get cursor():String
		{
			return Mouse.cursor;
		}
		
		public static function get supportsCursor():Boolean
		{
			return Mouse.supportsCursor;
		}
		
		public static function get supportsNativeCursor():Boolean
		{
			return Mouse.supportsNativeCursor;
		}
		
		public static function addCursor(cursorName:String, images:Vector.<BitmapData>, frameRate:Number = NaN, hotSpot:Point = null):void
		{
			var cursor:MouseCursorData = new MouseCursorData();
			cursor.data = images;
			
			if(!isNaN(frameRate))
			{
				cursor.frameRate = frameRate;
			}
			
			if(hotSpot != null)
			{
				cursor.hotSpot = hotSpot;
			}
			
			Mouse.registerCursor(cursorName, cursor);
			
			_cursorNames[cursorName] = cursorName;
		}
		
		public static function removeCursor(cursorName:String):void
		{
			Mouse.unregisterCursor(cursorName);
			
			delete _cursorNames[cursorName];
		}
	}
}