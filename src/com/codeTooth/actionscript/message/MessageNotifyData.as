package com.codeTooth.actionscript.message
{
	import com.codeTooth.actionscript.lang.utils.destroy.IDestroy;

	public class MessageNotifyData implements IDestroy
	{
		public var messageID:MessageID = null;
		
		public function MessageNotifyData()
		{
			// Do nothing
		}
		
		//------------------------------------------------------------------------------------------------------------------------------
		// 实现 IDestroy 接口
		//------------------------------------------------------------------------------------------------------------------------------
		
		public function destroy():void
		{
			messageID = null;
		}
	}
}