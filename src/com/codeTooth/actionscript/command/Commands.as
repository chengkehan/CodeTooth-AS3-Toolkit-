package com.codeTooth.actionscript.command
{
	import com.codeTooth.actionscript.lang.exceptions.NoSuchObjectException;
	import com.codeTooth.actionscript.lang.exceptions.NullPointerException;
	import com.codeTooth.actionscript.lang.utils.destroy.DestroyUtil;
	import com.codeTooth.actionscript.lang.utils.destroy.IDestroy;
	
	import flash.utils.Dictionary;

	public class Commands implements IDestroy
	{
		private var _commands:Dictionary = null;
		
		public function Commands()
		{
			_commands = new Dictionary();
		}
		
		public function addCommand(commandItem:CommandItem):void
		{
			if(commandItem == null)
			{
				throw new NullPointerException("Null commandItem");
			}
			
			_commands[commandItem.getCommandID()] = commandItem;
		}
		
		public function addCommandsCall(...commandItems):void
		{
			for each(var command:CommandItem in commandItems)
			{
				addCommand(command);
			}
		}
		
		public function addCommandsApply(commands:Vector.<CommandItem>):void
		{
			for each(var command:CommandItem in commands)
			{
				addCommand(command);
			}
		}
		
		public function removeCommand(commandID:Object):CommandItem
		{
			var command:CommandItem = _commands[commandID];
			delete _commands[commandID];
			
			return command;
		}
		
		public function removeCommandsCall(...commandIDs):void
		{
			for each(var commandID:Object in commandIDs)
			{
				removeCommand(commandID);
			}
		}
		
		public function removeCommandsApply(commandIDs:Vector.<Object>):void
		{
			for each(var commandID:Object in commandIDs)
			{
				removeCommand(commandID);
			}
		}
		
		public function executeCommand(commandID:Object, data:Object = null):*
		{
			var commandItem:CommandItem = _commands[commandID];
			if(commandItem == null)
			{
				throw new NoSuchObjectException("Has not the command \"" + commandID + "\"");
			}
			
			return commandItem.getCommand().execute(data);
		}
		
		public function getCommand(commandID:Object):CommandItem
		{
			return _commands[commandID];
		}
		
		public function containsCommand(commandID:Object):Boolean
		{
			return _commands[commandID] != null;
		}
		
		//----------------------------------------------------------------------------------------------------------------------------------
		// 实现 IDestroy 接口
		//----------------------------------------------------------------------------------------------------------------------------------
		
		public function destroy():void
		{
			DestroyUtil.breakMap(_commands);
			_commands = null;
		}
	}
}