package com.codeTooth.actionscript.ria.template.application.riaBaby.exception 
{
	import com.codeTooth.actionscript.lang.utils.destroy.IDestroy;
	
	public class ExceptionDataBase implements IDestroy
	{
		public var reason:String = null;
		
		public function ExceptionDataBase(reason:String) 
		{
			this.reason = reason;
		}
		
		public function destroy():void
		{
			// Do nothing
		}
	}

}