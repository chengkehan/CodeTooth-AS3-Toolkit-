package com.codeTooth.actionscript.air.template.application.baby.core
{
	import com.codeTooth.actionscript.air.menu.Menu;
	import com.codeTooth.actionscript.air.template.application.baby.command.app.InitializeAppCommand;
	import com.codeTooth.actionscript.air.template.application.baby.command.app.SaveAppInitDataCommand;
	import com.codeTooth.actionscript.air.template.application.baby.util.exception.Exceptions;
	import com.codeTooth.actionscript.air.template.application.baby.util.log.Log;
	import com.codeTooth.actionscript.air.template.application.baby.util.notify.NotifyData;
	import com.codeTooth.actionscript.air.template.application.baby.view.ViewBase;
	import flash.geom.Rectangle;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.NativeWindowBoundsEvent;
	import flash.events.UncaughtErrorEvent;
	import flash.filesystem.File;
	
	
	/**
	 * AIR应用模板。
	 * 
	 * 条件编译
	 * CONFIG::DEBUG true/false 是否在输出窗口打印日志
	 */	
	public class Baby extends Sprite
	{
		/**
		 * 试图
		 */
		protected var _view:ViewBase = null;
		
		private var _appInitPath:String = null;
		
		private var _customWindowBounds:Boolean = false;
		
		private var _uncaughtErrorHandler:Function = null;
		
		/**
		 * 构造函数
		 * 
		 * @param	appInitPath 初始化文件相对路径
		 * @param	logPath 日志相对路径
		 * @param	menuContext 菜单上下文
		 * @param	uncaughtErrorHandle 未捕获异常的处理函数
		 */
		public function Baby(appInitPath:String = null, logPath:String = null, menuContext:Object = null, uncaughtErrorHandle:Function = null)
		{
			NotifyData;
			
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.nativeWindow.addEventListener("closing", closeWindowHandler);
			stage.nativeWindow.addEventListener(NativeWindowBoundsEvent.RESIZE, resizeWindowHandler);
			Bridge.initializeGlobalExceptionHandler(this);
			Log.path = logPath;
			
			initialize(appInitPath, menuContext);
			
			// 所有未捕获的异常记录日志
			_uncaughtErrorHandler = uncaughtErrorHandle;
			loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, uncaughtErrorHandler);
		}
		
		private function initialize(appInitPath:String, menuContext:Object):void
		{
			if(appInitPath != null)
			{
				_appInitPath = appInitPath;
				
				var data:Object = new InitializeAppCommand().execute({ path:resolvePath(appInitPath), 
																										resolvePathFunc:resolvePath, 
																										completeExecute:completeExecute});
				if(data != null)
				{
					if(data.windowBounds != null)
					{
						var windowBounds:Rectangle = data.windowBounds;
						stage.nativeWindow.x = windowBounds.x;
						stage.nativeWindow.y = windowBounds.y;
						stage.nativeWindow.width = windowBounds.width;
						stage.nativeWindow.height = windowBounds.height;
						_customWindowBounds = true;
					}
					
					if(data.menuXML != null)
					{
						try
						{
							Menu.createMenu(data.menuXML, stage.nativeWindow, menuContext);
						}
						catch(error:Error)
						{
							Bridge.throwGlobalException(Exceptions.CREATE_MENU_EXCEPTION, { error:error });
						}
					}
					
					if(data.execute != null)
					{
						data.execute();
					}
				}
			}
			else
			{
				completeExecute();
			}
		}
		
		/**
		 * 加载完配置文件后执行，子类覆盖这个方法。
		 */
		protected function completeExecute():void
		{
			// TODO Do something in sub class.
		}
		
		/**
		 * 更新调整试图的尺寸
		 */
		protected function updateViewSize():void
		{
			if(_view != null)
			{
				_view.width = stage.stageWidth;
				_view.height = stage.stageHeight;
			}
		}
		
		private function resolvePath(path:String):String
		{
			return File.applicationDirectory.resolvePath(path).nativePath;
		}
		
		private function closeWindowHandler(event:Event):void
		{
			if(_customWindowBounds && _appInitPath != null)
			{
				event.preventDefault();
				var windowBounds:Rectangle = new Rectangle();
				windowBounds.x = stage.nativeWindow.x;
				windowBounds.y = stage.nativeWindow.y;
				windowBounds.width = stage.nativeWindow.width;
				windowBounds.height = stage.nativeWindow.height;
				new SaveAppInitDataCommand().execute({ resolvePathFunc:resolvePath, windowBounds:windowBounds, path:_appInitPath });
			}
			
			stage.nativeWindow.close();
		}
		
		private function resizeWindowHandler(event:NativeWindowBoundsEvent):void
		{
			updateViewSize();
		}
		
		// 全局异常处理
		private function uncaughtErrorHandler(event:UncaughtErrorEvent):void
		{
			if (_uncaughtErrorHandler != null)
			{
				if (_uncaughtErrorHandler.length == 0)
				{
					_uncaughtErrorHandler();
				}
				else
				{
					_uncaughtErrorHandler(event);
				}
			}
			
			Bridge.throwGlobalException(Exceptions.UNCAUGHT_EXCEPTION, { error:event.error });
		}
	}
}