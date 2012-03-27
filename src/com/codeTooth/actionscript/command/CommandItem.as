package com.codeTooth.actionscript.command
{
	import com.codeTooth.actionscript.lang.exceptions.NullPointerException;
	import com.codeTooth.actionscript.lang.utils.destroy.IDestroy;

	public class CommandItem implements IDestroy
	{
		private var _commandID:CommandID = null;
		
		private var _command:ICommand = null;
		
		public function CommandItem(commandID:CommandID, command:ICommand)
		{
			if(commandID == null)
			{
				throw new NullPointerException("Null commandID");
			}
			if(command == null)
			{
				throw new NullPointerException("Null command");
			}
			
			_commandID = commandID;
			_command = command;
		}
		
		public function getCommandID():CommandID
		{
			return _commandID;
		}
		
		public function getCommand():ICommand
		{
			return _command;
		}
		
		//----------------------------------------------------------------------------------------------------------------------------------
		// 实现 IDestroy 接口
		//----------------------------------------------------------------------------------------------------------------------------------
		
		public function destroy():void
		{
			_commandID = null;
			_command = null;
		}
	}
}