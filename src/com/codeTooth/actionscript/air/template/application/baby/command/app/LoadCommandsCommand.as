package com.codeTooth.actionscript.air.template.application.baby.command.app
{
	import com.codeTooth.actionscript.air.template.application.baby.command.ICommand;
	
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;
	
	/**
	 * @private
	 * 
	 * 加载命令数据
	 */
	public class LoadCommandsCommand implements ICommand
	{
		private var _loader:Loader = null;
		
		private var _completeHandler:Function = null;
		
		private var _ioErrorHandler:Function = null;
		
		private var _securityErrorHandler:Function = null;
		
		public function LoadCommandsCommand()
		{
			
		}
		
		public function execute(data:Object=null):*
		{
			_completeHandler = data.completeHandler;
			_ioErrorHandler = data.ioErrorHandler;
			_securityErrorHandler = data.securityErrorHandler;
			
			var file:File = new File(File.applicationDirectory.resolvePath(data.path).nativePath);
			var fileStream:FileStream = new FileStream();
			var byteArray:ByteArray = new ByteArray();
			fileStream.open(file, FileMode.READ);
			fileStream.readBytes(byteArray, 0, fileStream.bytesAvailable);
			fileStream.close();
			
			var loaderContext:LoaderContext = new LoaderContext(false, ApplicationDomain.currentDomain);
			loaderContext.allowLoadBytesCodeExecution = true;
			_loader = new Loader();
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, completeHandler);
			_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			_loader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
			_loader.loadBytes(byteArray, loaderContext);
		}
		
		private function breakObject():void
		{
			_completeHandler = null;
			_ioErrorHandler = null;
			_securityErrorHandler = null;
			_loader = null;
		}
		
		private function removeListeners():void
		{
			_loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, completeHandler);
			_loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			_loader.contentLoaderInfo.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
		}
		
		private function completeHandler(event:Event):void
		{
			if(_completeHandler != null)
			{
				_completeHandler(event);
			}
			
			removeListeners();
			breakObject();
		}
		
		private function ioErrorHandler(event:IOErrorEvent):void
		{
			if(_ioErrorHandler != null)
			{
				_ioErrorHandler(event);
			}
			
			removeListeners();
			breakObject();
		}
		
		private function securityErrorHandler(event:SecurityErrorEvent):void
		{
			if(_securityErrorHandler != null)
			{
				_securityErrorHandler(event);
			}
			
			removeListeners();
			breakObject();
		}
	}
}