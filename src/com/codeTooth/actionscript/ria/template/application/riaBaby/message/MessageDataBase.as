package com.codeTooth.actionscript.ria.template.application.riaBaby.message 
{
	import com.codeTooth.actionscript.lang.utils.destroy.IDestroy;
	
	public class MessageDataBase implements IDestroy
	{
		public var reason:String = null;
		
		public function MessageDataBase(reason:String) 
		{
			this.reason = reason;
		}
		
		public function destroy():void
		{
			// Do nothing
		}
	}

}