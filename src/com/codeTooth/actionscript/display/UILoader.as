package com.codeTooth.actionscript.display
{
	import com.codeTooth.actionscript.lang.utils.Align;
	import com.codeTooth.actionscript.lang.utils.destroy.IDestroy;
	import flash.geom.Rectangle;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	
	
	
	/**
	 * 图片加载器
	 */
	public class UILoader extends Sprite 
							implements IDestroy
	{
		public function UILoader()
		{
			initializeWidthHeight();
		}
		
		//---------------------------------------------------------------------------------------------------------------------------------------------------
		// 是否进行缩放
		//---------------------------------------------------------------------------------------------------------------------------------------------------
		
		private var _willScale:Boolean = true;
		
		/**
		 * 是否进行缩放
		 */
		public function set willScale(bool:Boolean):void
		{
			_willScale = bool;
			
			if(_complete)
			{
				resize();
			}
		}
		
		/**
		 * @private
		 */
		public function get willScale():Boolean
		{
			return _willScale;
		}
		
		//---------------------------------------------------------------------------------------------------------------------------------------------------
		// 按比例缩放
		//---------------------------------------------------------------------------------------------------------------------------------------------------
		
		private var _scaleAsRatio:Boolean = true;
		
		/**
		 * 是否按比例缩放
		 */
		public function set scaleAsRatio(bool:Boolean):void
		{
			_scaleAsRatio = bool;
			
			if(_complete)
			{
				resize();
			}
		}
		
		/**
		 * @private
		 */
		public function get scaleAsRatio():Boolean
		{
			return _scaleAsRatio;
		}
		
		//---------------------------------------------------------------------------------------------------------------------------------------------------
		// 重写宽高
		//---------------------------------------------------------------------------------------------------------------------------------------------------
		
		private var _origWidth:Number = 0;
		
		private var _origHeight:Number = 0;
		
		private var _width:Number = 0;
		
		private var _height:Number = 0;
		
		/**
		 * @inheritDoc
		 */
		override public function set width(value:Number):void
		{
			_width = value;
			
			if(_complete)
			{
				resize();
			}
		}
		
		/**
		 * @private
		 */
		override public function get width():Number
		{
			return isNaN(_width) ? 0 : _width;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function set height(value:Number):void
		{
			_height = value;
			
			if(_complete)
			{
				resize();
			}
		}
		
		/**
		 * @private
		 */
		override public function get height():Number
		{
			return isNaN(_height) ? 0 : _height
		}
		
		private function resize():void
		{
			if(isNaN(_width))
			{
				_width = _loader.width;
			}
			if(isNaN(_height))
			{
				_height = _loader.height;
			}
			
			if(_willScale)
			{
				if(_scaleAsRatio)
				{
					var scaleAsRatioRect:Rectangle = Align.rectScaleCenterAlign(Align.getRectangle(_loader), new Rectangle(0, 0, _width, _height));
					_loader.x = scaleAsRatioRect.x;
					_loader.y = scaleAsRatioRect.y;
					_loader.width = scaleAsRatioRect.width;
					_loader.height = scaleAsRatioRect.height;
				}
				else
				{
					_loader.width = _width;
					_loader.height = _height;
				}
			}
			else
			{
				if (_origWidth > _width || _origHeight > _height)
				{
					var newRect:Rectangle = Align.rectScaleCenterAlign(Align.getRectangle(_loader), new Rectangle(0, 0, _width, _height));
					_loader.x = newRect.x;
					_loader.y = newRect.y;
					_loader.width = newRect.width;
					_loader.height = newRect.height;
				}
				else
				{
					_loader.width = _origWidth;
					_loader.height = _origHeight;
					
					var alignRect:Rectangle = Align.rectCenterAlign(Align.getRectangle(_loader), new Rectangle(0, 0, _width, _height));
					_loader.x = alignRect.x;
					_loader.y = alignRect.y;
					_loader.width = alignRect.width;
					_loader.height = alignRect.height;
				}
			}
		}
		
		private function initializeWidthHeight():void
		{
			_width = NaN;
			_height = NaN;
		}
		
		//---------------------------------------------------------------------------------------------------------------------------------------------------
		// Loader
		//---------------------------------------------------------------------------------------------------------------------------------------------------
		
		// ProgressHandler
		private var _progressHandler:Function = null;
		
		/**
		 * 加载过程处理函数
		 */
		public function set progressHandler(handler:Function):void
		{
			_progressHandler = handler;
		}
		
		/**
		 * @private
		 */
		public function get progressHandler():Function
		{
			return _progressHandler;
		}
		
		private function loaderProgressHandler(event:ProgressEvent):void
		{
			if(_progressHandler != null)
			{
				if(_progressHandler.length == 0)
				{
					_progressHandler();
				}
				else
				{
					_progressHandler(event);
				}
			}
		}
		
		// CompleteHandler
		private var _completeHandler:Function = null;
		
		/**
		 * 加载结束处理函数
		 */
		public function get completeHandler():Function
		{
			return _completeHandler;
		}
		
		/**
		 * @private
		 */
		public function set completeHandler(value:Function):void
		{
			_completeHandler = value;
		}
		
		private function loaderCompleteHandler(event:Event):void
		{
			_complete = true;
			_origWidth = _loader.width;
			_origHeight = _loader.height;
			resize();
			
			if(_completeHandler != null)
			{
				if(_completeHandler.length == 0)
				{
					_completeHandler();
				}
				else
				{
					_completeHandler(event)
				}
			}
		}
		
		// IOErrorHandler
		private var _ioErrorHandler:Function = null;
		
		/**
		 * 加载IOError处理函数
		 */
		public function get ioErrorHandler():Function
		{
			return _ioErrorHandler;
		}
		
		/**
		 * @private
		 */
		public function set ioErrorHandler(value:Function):void
		{
			_ioErrorHandler = value;
		}
		
		private function loaderIOErrorHandler(event:IOErrorEvent):void
		{
			if(_ioErrorHandler != null)
			{
				if(_ioErrorHandler.length == 0)
				{
					_ioErrorHandler();
				}
				else
				{
					_ioErrorHandler(event);
				}
			}
		}
		
		// Loader
		private var _loader:Loader = null;
		
		private var _complete:Boolean = false;
		
		/**
		 * 加载位图
		 * 
		 * @param	request
		 * @param	context
		 */
		public function load(request:URLRequest, context:LoaderContext = null):void
		{
			if(_loader == null)
			{
				_loader = new Loader();
				addChild(_loader);
				_loader.mouseChildren = false;
				_loader.mouseEnabled = false;
				_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loaderCompleteHandler);
				_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, loaderIOErrorHandler);
				_loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, loaderProgressHandler);
			}
			
			unload();
			_complete = false;
			_loader.load(request, context);
		}
		
		/**
		 * 删除已经加载的位图
		 */
		public function unload():void
		{
			if (_loader != null)
			{
				_loader.unloadAndStop();
			}
		}
		
		private function destroyLoader():void
		{
			if(_loader != null)
			{
				try
				{
					_loader.close();
				}
				catch(error:Error)
				{
					// Do nothing
				}
				
				_loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, loaderCompleteHandler);
				_loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, loaderIOErrorHandler);
				_loader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, loaderProgressHandler);
				_loader.unloadAndStop();
				
				removeChild(_loader);
				_loader = null;
			}
		}
		
		//---------------------------------------------------------------------------------------------------------------------------------------------------
		// 重写 IDestroy 接口
		//---------------------------------------------------------------------------------------------------------------------------------------------------
		
		/**
		 * @inheritDoc
		 */
		public function destroy():void
		{
			destroyLoader();
		}
	}
}