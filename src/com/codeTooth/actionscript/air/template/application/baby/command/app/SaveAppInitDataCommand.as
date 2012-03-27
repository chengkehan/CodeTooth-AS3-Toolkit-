package com.codeTooth.actionscript.air.template.application.baby.command.app
{
	import com.codeTooth.actionscript.air.template.application.baby.command.ICommand;
	import com.codeTooth.actionscript.air.template.application.baby.core.Bridge;
	import com.codeTooth.actionscript.air.template.application.baby.util.exception.Exceptions;
	import flash.geom.Rectangle;
	
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	
	/**
	 * @private
	 * 
	 * 保存程序信息命令
	 */
	public class SaveAppInitDataCommand implements ICommand
	{
		public function SaveAppInitDataCommand()
		{
		}
		
		public function execute(data:Object=null):*
		{
			try
			{
				var windowBounds:Rectangle = data.windowBounds;	
				var resolvePathFunc:Function = data.resolvePathFunc;
			
				var file:File = new File(resolvePathFunc(data.path));
				var fileStream:FileStream = new FileStream();
				fileStream.open(file, FileMode.READ);
				var appInitXML:XML = XML(fileStream.readUTFBytes(fileStream.bytesAvailable));
				fileStream.close();
				
				appInitXML.window.@x = windowBounds.x;
				appInitXML.window.@y = windowBounds.y;
				appInitXML.window.@width = windowBounds.width;
				appInitXML.window.@height = windowBounds.height;
				
				fileStream = new FileStream();
				fileStream.open(file, FileMode.WRITE);
				fileStream.writeUTFBytes(appInitXML.toXMLString());
				fileStream.close();
			}
			catch(error:Error)
			{
				Bridge.throwGlobalException(Exceptions.SAVE_APP_INIT_DATA_EXCEPTION, { error:error });
			}
		}
	}
}