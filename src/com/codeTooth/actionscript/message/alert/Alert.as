package com.codeTooth.actionscript.message.alert
{
	import com.codeTooth.actionscript.lang.exceptions.NullPointerException;
	import com.codeTooth.actionscript.message.IMessageObserver;
	import com.codeTooth.actionscript.message.alert.AlertNotifyData;
	
	import mx.controls.Alert;
	
	public class Alert implements IMessageObserver
	{
		public function Alert()
		{
			
		}
		
		public function update(pData:Object=null):void
		{
			if(pData == null)
			{
				throw new NullPointerException("Null data");
			}
			
			var data:AlertNotifyData = AlertNotifyData(pData);
			mx.controls.Alert.show(data.text, data.title, data.flags, data.parent, data.closeHandler, data.iconClass, data.defaultButtonFlag, data.moduleFactory);
		}
	}
}