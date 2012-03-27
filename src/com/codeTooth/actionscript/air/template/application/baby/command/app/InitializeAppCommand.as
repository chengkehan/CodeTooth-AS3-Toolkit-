package com.codeTooth.actionscript.air.template.application.baby.command.app
{
	import com.codeTooth.actionscript.air.template.application.baby.command.ICommand;
	import com.codeTooth.actionscript.air.template.application.baby.core.Bridge;
	import com.codeTooth.actionscript.air.template.application.baby.util.exception.Exceptions;
	import flash.geom.Rectangle;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.system.ApplicationDomain;
	
	/**
	 * @private
	 * 
	 * 初始化模板命令
	 */
	public class InitializeAppCommand implements ICommand
	{
		private var _facadePath:String = null;
		
		private var _skinPath:String = null;
		
		private var _stylePath:String = null;
		
		private var _completeExecute:Function = null;
		
		private var _loadTotal:int = 0;
		
		private var _loadedAmount:int = 0;
		
		public function InitializeAppCommand()
		{
		}
		
		public function execute(data:Object=null):*
		{
			var appInitXML:XML = null;
			_completeExecute = data.completeExecute;
			
			// Load app init data
			try
			{
				appInitXML = new LoadAppInitDataCommand().execute({ path:data.path });
			}
			catch(error:Error)
			{
				Bridge.throwGlobalException(Exceptions.LOAD_APP_INIT_DATA_EXCEPTION, { error:error });
			}
			
			if(appInitXML != null)
			{
				trace("AppInitXML Okey!");
				
				var resolvePathFunc:Function = data.resolvePathFunc;
				
				// Create window bounds
				var windowBounds:Rectangle = null;
				if(appInitXML.window != undefined)
				{
					var windowXML:XML = appInitXML.window[0];
					windowBounds = new Rectangle();
					windowBounds.x = windowXML.@x == undefined ? 0 : int(windowXML.@x);
					windowBounds.y = windowXML.@y == undefined ? 0 : int(windowXML.@y);
					windowBounds.width = windowXML.@width == undefined ? 800 : int(windowXML.@width);
					windowBounds.height = windowXML.@height == undefined ? 600 : int(windowXML.@height);

					trace("WindowBounds Okey!");
				}
				
				// Menu xml
				var menuXML:XML = null;
				if(appInitXML.menu != undefined)
				{
					menuXML = appInitXML.menu[0];
					trace("MenuXML Okey!");
				}
				
				// DI path
				var diPath:String = appInitXML.di == undefined ? null : appInitXML.di[0];
				if(diPath != null)
				{
					Bridge.loadDI(resolvePathFunc(diPath), loadDICompleteHandler);
					_loadTotal++;
					trace("Di Okey!");
				}
				
				// Load commands
				if(appInitXML.command != undefined)
				{
					new LoadDefinitionCommand().execute({ path:String(appInitXML.command[0]),
																				resolvePathFunc:resolvePathFunc, 
																				completeHandler:loadCommandsCompleteHandler,
																				ioErrorHandler:loadCommandsIOErrorHandler,
																				securityErrorHandler:loadCommandsSecurityErrorHandler, 
																				applicationDomain:ApplicationDomain.currentDomain });
					_loadTotal++;
					
					trace("Commands Okey!");
				}
				
				return { menuXML:menuXML, 
								windowBounds:windowBounds, 
								execute:_loadTotal == 0 ? _completeExecute : null };
			}
			else
			{
				return null;
			}
		}
		
		private function checkComplete():void
		{
			if(++_loadedAmount == _loadTotal)
			{
				completeExecute();
			}
		}
		
		private function completeExecute():void
		{
			_completeExecute();
			_completeExecute = null;
		}
		
		// DI
		private function loadDICompleteHandler():void
		{
			checkComplete();
		}
		
		// Commands handler
		private function loadCommandsCompleteHandler(event:Event):void
		{
			// TODO Load commands complete.
			trace("Load Commands Okey!");
			checkComplete();
		}
		
		private function loadCommandsIOErrorHandler(event:IOErrorEvent):void
		{
			Bridge.throwGlobalException(Exceptions.LOAD_COMMANDS_IO_EXCEPTION, { event:event });
		}
		
		private function loadCommandsSecurityErrorHandler(event:SecurityErrorEvent):void
		{
			Bridge.throwGlobalException(Exceptions.LOAD_COMMANDS_SECURITY_EXCEPTION, { event:event });
		}
	}
}