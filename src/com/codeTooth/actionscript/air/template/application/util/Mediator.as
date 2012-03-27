package com.codeTooth.actionscript.air.template.application.util
{
	import com.codeTooth.actionscript.air.cursor.CustomCursor;
	import com.codeTooth.actionscript.command.Commands;
	import com.codeTooth.actionscript.message.Messager;
	import com.codeTooth.actionscript.message.alert.Alert;
	import com.codeTooth.actionscript.message.alert.AlertMessage;
	import com.codeTooth.actionscript.message.alert.AlertNotifyData;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;
	
	import mx.core.IFlexModuleFactory;

	public class Mediator
	{
		//----------------------------------------------------------------------------------------------------------------------------------
		// Initialize
		//----------------------------------------------------------------------------------------------------------------------------------
		
		private static var _initialized:Boolean = false;
		
		public static function initialize(document:DisplayObject = null):void
		{
			if(_initialized)
			{
				return;
			}
			_initialized = true;
			
			initializeAlert();
			initializeDocument(document);
		}
		
		//----------------------------------------------------------------------------------------------------------------------------------
		// Commands
		//----------------------------------------------------------------------------------------------------------------------------------
		
		public static const commands:Commands = new Commands();
		
		//----------------------------------------------------------------------------------------------------------------------------------
		// Document
		//----------------------------------------------------------------------------------------------------------------------------------
		
		private static var _document:DisplayObject = null;
		
		public static function getDocument():DisplayObject
		{
			return _document;
		}
		
		private static function initializeDocument(doc:DisplayObject):void
		{
			_document = doc;
		}
		
		//----------------------------------------------------------------------------------------------------------------------------------
		// Messger
		//----------------------------------------------------------------------------------------------------------------------------------
		
		public static const messager:Messager = new Messager();
		
		//----------------------------------------------------------------------------------------------------------------------------------
		// Cursor
		//----------------------------------------------------------------------------------------------------------------------------------
		
		private static var _cursorName:String = MouseCursor.ARROW;
		
		private static var _useCursorAuto:Boolean = false;
		
		public static function set useCursorAuto(bool:Boolean):void
		{
			_useCursorAuto = bool;
		}
		
		public static function get useCursorAuto():Boolean
		{
			return _useCursorAuto;
		}
		
		public static function useCursor():void
		{
			Mouse.cursor = _cursorName;
		}
		
		public static function resetCursor():void
		{
			Mouse.cursor = MouseCursor.ARROW;
		}
		
		public static function set cursor(cursorName:String):void
		{
			_cursorName = cursorName;
			
			if(_useCursorAuto)
			{
				useCursor();
			}
		}
		
		public static function get cursor():String
		{
			return _cursorName;
		}
		
		//----------------------------------------------------------------------------------------------------------------------------------
		// Alert
		//----------------------------------------------------------------------------------------------------------------------------------
		
		private static var _alert:Alert = new Alert();
		
		public static function showAlert(text:String = "", title:String = "", flags:uint = 4, parent:Sprite = null, closeHandler:Function = null, iconClass:Class = null, defaultButtonFlag:uint = 4, moduleFactory:IFlexModuleFactory = null):void
		{
			messager.notify(AlertMessage.ALERT, new AlertNotifyData(text, title, flags, parent, closeHandler, iconClass, defaultButtonFlag, moduleFactory));
		}
		
		private static function initializeAlert():void
		{
			messager.addMessage(AlertMessage.ALERT);
			
			messager.followMessage(AlertMessage.ALERT, _alert);
		}
	}
}