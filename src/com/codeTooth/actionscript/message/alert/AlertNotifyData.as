package com.codeTooth.actionscript.message.alert
{
	import com.codeTooth.actionscript.message.MessageNotifyData;
	
	import flash.display.Sprite;
	
	import mx.core.IFlexModuleFactory;
	
	public class AlertNotifyData extends MessageNotifyData
	{
		public var text:String = null;
		
		public var title:String = null;
		
		public var flags:uint = 4;
		
		public var parent:Sprite = null;
		
		public var closeHandler:Function = null;
		
		public var iconClass:Class = null;
		
		public var defaultButtonFlag:uint = 4;
		
		public var moduleFactory:IFlexModuleFactory = null;
		
		public function AlertNotifyData(text:String = "", title:String = "", flags:uint = 4, parent:Sprite = null, closeHandler:Function = null, iconClass:Class = null, defaultButtonFlag:uint = 4, moduleFactory:IFlexModuleFactory = null)
		{
			this.text = text;
			this.title = title;
			this.flags = flags;
			this.parent = parent;
			this.closeHandler = closeHandler;
			this.iconClass = iconClass;
			this.defaultButtonFlag = defaultButtonFlag;
			this.moduleFactory = moduleFactory;
		}
	}
}