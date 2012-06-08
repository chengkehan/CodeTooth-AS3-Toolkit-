package com.codeTooth.actionscript.command
{
	import flash.utils.describeType;

	public function registerCommandID(clazzes:Vector.<Class>, commands:Commands):void
	{
		if(commands == null)
		{
			return;
		}
		
		for each(var clazz:Class in clazzes)
		{
			if(clazz == null)
			{
				continue;
			}
			
			var xml:XML = describeType(clazz);
			var constantXMLList:XMLList = xml.constant;
			for each(var constantXML:XML in constantXMLList)
			{
				var cmd:Object = clazz[String(constantXML.@name)];
				commands.addCommand(new CommandItem(cmd, ICommand(cmd)));
			}
		}
	}
}