package com.codeTooth.actionscript.air.template.application.baby.command.app
{
	import com.codeTooth.actionscript.air.template.application.baby.command.ICommand;
	
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	
	/**
	 * @private
	 * 
	 * 加载初始化数据命令
	 */
	public class LoadAppInitDataCommand implements ICommand
	{
		public function LoadAppInitDataCommand()
		{
		}
		
		public function execute(data:Object = null):*
		{
			var file:File = File.applicationDirectory.resolvePath(data.path);
			var fileStream:FileStream = new FileStream();
			fileStream.open(file, FileMode.READ);
			
			var appInitXML:XML = XML(fileStream.readUTFBytes(fileStream.bytesAvailable));
			fileStream.close();
			
			return appInitXML;
		}
	}
}