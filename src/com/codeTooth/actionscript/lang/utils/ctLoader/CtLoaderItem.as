package com.codeTooth.actionscript.lang.utils.ctLoader
{
	import com.codeTooth.actionscript.lang.exceptions.IllegalParameterException;
	import com.codeTooth.actionscript.lang.utils.ConstructObject;
	import com.codeTooth.actionscript.lang.utils.destroy.IDestroy;
	import com.codeTooth.actionscript.lang.utils.newObjectPool.ObjectPool;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;

	public class CtLoaderItem implements IDestroy
	{
		public static const STATE_READY:int = 1;
		
		public static const STATE_LOADING_BINARY:int = 2;
		
		public static const STATE_LOADING_BINARY_IO_ERROR:int = 3;
		
		public static const STATE_LOADING_BINARY_SECURITY_ERROR:int = 4;
		
		public static const STATE_LOADING:int = 5;
		
		public static const STATE_LOADING_IO_ERROR:int = 6;
		
		public static const STATE_COMPLETE:int = 7;
		
		public static const STATE_DESTROY:int = 8;
		
		public static const TYPE_NORMAL:int = 1;
		
		public static const TYPE_BINARY:int = 2;
		
		private static var _objectPool:ObjectPool = null;
		
		private var _state:int = STATE_READY;
		
		private var _urlLoader:URLLoader = null;
		
		private var _loader:Loader = null;
		
		private var _url:String = null;
		
		private var _context:LoaderContext = null;
		
		private var _binaryCompleteCallbacks:Vector.<Function/*func(loader:CtLoaderItem)*/> = null;
		
		private var _binaryProgressCallbacks:Vector.<Function/*func(loader:CtLoaderItem):void*/> = null;
		
		private var _binaryIOErrorCallbacks:Vector.<Function/*func(loader:CtLoaderItem):void*/> = null;
		
		private var _binarySecurityErrorCallbacks:Vector.<Function/*func(loader:CtLoaderItem):void*/> = null;
		
		private var _completeCallbacks:Vector.<Function/*func(loader:CtLoaderItem):void*/> = null;
		
		private var _ioErrorCallbacks:Vector.<Function/*func(loader:CtLoaderItem):void*/> = null;
		
		private var _bytesLoaded:int = 0;
		
		private var _bytesTotal:int = 0;
		
		private var _loaderType:int = 0;
		
		public function CtLoaderItem()
		{
			if(_objectPool == null)
			{
				_objectPool = new ObjectPool();
				_objectPool.createPoolSafely(Vector.<Function>, null, objectPoolInvokeAfterPut);
			}
		}
		
		public function get loaderType():int
		{
			return _loaderType;
		}
		
		public function get url():String
		{
			return _url;
		}
		
		public function get bytesLoaded():int
		{
			return _bytesLoaded;
		}
		
		public function get bytesTotal():int
		{
			return _bytesTotal;
		}
		
		public function get state():int
		{
			return _state;
		}
		
		public function getBytes():ByteArray
		{
			return _urlLoader == null ? null : _urlLoader.data;
		}
		
		public function getContent():DisplayObject
		{
			return _loader == null ? null : _loader.content;
		}
		
		public function getBitmapData():BitmapData
		{
			if(_loader == null || !(_loader.content is Bitmap))
			{
				return null;
			}
			else
			{
				return Bitmap(_loader.content).bitmapData;
			}
		}
		
		public function getBitmap():Bitmap
		{
			var bmpd:BitmapData = getBitmapData();
			return bmpd == null ? null : new Bitmap(bmpd);
		}
		
		public function getClass(type:String):Class
		{
			if(_loader == null)
			{
				return null;
			}
			else
			{
				if(_loader.contentLoaderInfo.applicationDomain.hasDefinition(type))
				{
					return Class(_loader.contentLoaderInfo.applicationDomain.getDefinition(type));
				}
				else
				{
					return null;
				}
			}
		}
		
		public function getObject(type:String):*
		{
			var clazz:Class = getClass(type);
			return clazz == null ? null : new clazz();
		}
		
		public function getObjectByArgs(type:String, ...args):*
		{
			var clazz:Class = getClass(type);
			return clazz == null ? null : ConstructObject.newConstructorApply(clazz, args);
		}
		
		public function destroy():void
		{
			_state = STATE_DESTROY;
			releaseLoaders();
			releaseAllCallbacks();
		}
		
		internal function getLoader():Loader
		{
			return _loader;
		}
		
		internal function getURLLoader():URLLoader
		{
			return _urlLoader;
		}
		
		internal function load(url:String, context:LoaderContext = null, loaderType:int = 3, 
							   completeCallback:Function = null, ioErrorCallback:Function = null, 
							   binaryCompleteCallback:Function = null, binaryProgressCallback:Function = null, 
							   binaryIOErrorCallback:Function = null, binarySecurityErrorCallback:Function = null):Boolean
		{
			if(_url != null && _url != url)
			{
				return false;
			}
			else
			{
				if(_state == STATE_COMPLETE)
				{
					executeCallback(binaryCompleteCallback);
					executeCallback(completeCallback);
				}
				else if(_state == STATE_LOADING_BINARY)
				{
					addCallbacks(binaryCompleteCallback, binaryProgressCallback, 
						binaryIOErrorCallback, binarySecurityErrorCallback, 
						completeCallback, ioErrorCallback
					);
				}
				else if(_state == STATE_LOADING_BINARY_IO_ERROR)
				{
					executeCallback(binaryIOErrorCallback);
				}
				else if(_state == STATE_LOADING_BINARY_SECURITY_ERROR)
				{
					executeCallback(binarySecurityErrorCallback);
				}
				else if(_state == STATE_LOADING)
				{
					executeCallback(binaryCompleteCallback);
					addCallbacks(null, null, null, null, completeCallback, ioErrorCallback);
				}
				else if(_state == STATE_LOADING_IO_ERROR)
				{
					executeCallback(ioErrorCallback);
				}
				else if(_state == STATE_READY)
				{
					if(!(loaderType & TYPE_NORMAL) && !(loaderType & TYPE_BINARY))
					{
						throw new IllegalParameterException("Illegal loaderType parameter \"" + loaderType + "\".");
					}
					
					_binaryCompleteCallbacks = _objectPool.getObject(Vector.<Function>);
					_binaryProgressCallbacks = _objectPool.getObject(Vector.<Function>);
					_binaryIOErrorCallbacks = _objectPool.getObject(Vector.<Function>);
					_binarySecurityErrorCallbacks = _objectPool.getObject(Vector.<Function>);
					_completeCallbacks = _objectPool.getObject(Vector.<Function>);
					_ioErrorCallbacks = _objectPool.getObject(Vector.<Function>);
					
					_loaderType = loaderType;
					_context = context;
					_url = url;
					addCallbacks(binaryCompleteCallback, binaryProgressCallback, 
						binaryIOErrorCallback, binarySecurityErrorCallback, 
						completeCallback, ioErrorCallback
					);
					
					if(_loaderType & TYPE_BINARY)
					{
						_state = STATE_LOADING_BINARY;
						createURLLoader();
						_urlLoader.load(new URLRequest(url));
					}
					else
					{
						_state = STATE_LOADING;
						createLoader();
						_loader.load(new URLRequest(url), _context);
					}
				}
				else if(_state == STATE_DESTROY)
				{
					return false;
				}
				
				return true;
			}
		}
		
		private static function objectPoolInvokeAfterPut(funcs:Vector.<Function>):void
		{
			funcs.length = 0;
		}
		
		private function addCallbacks(binaryCompleteCallback:Function = null, binaryProgressCallback:Function = null, 
									  binaryIOErrorCallback:Function = null, binarySecurityErrorCallback:Function = null, 
									  completeCallback:Function = null, ioErrorCallback:Function = null):void
		{
			addCallback(_binaryCompleteCallbacks, binaryCompleteCallback);
			addCallback(_binaryIOErrorCallbacks, binaryIOErrorCallback);
			addCallback(_binaryProgressCallbacks, binaryProgressCallback);
			addCallback(_binarySecurityErrorCallbacks, binarySecurityErrorCallback);
			addCallback(_completeCallbacks, completeCallback);
			addCallback(_ioErrorCallbacks, ioErrorCallback);
		}
		
		private function addCallback(list:Vector.<Function>, callback:Function):void
		{
			callback != null ? list.push(callback) : null;
		}
		
		private function executeCallbacks(callbacks:Vector.<Function>):void
		{
			for each (var callback:Function in callbacks) 
			{
				callback(this);
			}
		}
		
		private function executeCallback(callback:Function):void
		{
			callback != null ? callback(this) : null;
		}
		
		private function close():void
		{
			if(_urlLoader != null)
			{
				try
				{
					_urlLoader.close();
				} 
				catch(error:Error) 
				{
					// Do nothing
				}
			}
			if(_loader != null)
			{
				try
				{
					_loader.close();
				} 
				catch(error:Error) 
				{
					// 
				}
			}
		}
		
		private function removeListeners():void
		{
			if(_urlLoader != null)
			{
				_urlLoader.removeEventListener(Event.COMPLETE, urlLoaderCompleteHandler);
				_urlLoader.removeEventListener(IOErrorEvent.IO_ERROR, urlLoaderIOErrorHandler);
				_urlLoader.removeEventListener(ProgressEvent.PROGRESS, urlLoaderProgressHandler);
				_urlLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, urlLoaderSecurityErrorHandler);
			}
			if(_loader != null)
			{
				_loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, loaderCompleteHandler);
				_loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, loaderIOErrorHandler);
			}
		}
		
		private function createURLLoader():void
		{
			if(_urlLoader == null)
			{
				_urlLoader = new URLLoader();
				_urlLoader.addEventListener(Event.COMPLETE, urlLoaderCompleteHandler);
				_urlLoader.addEventListener(IOErrorEvent.IO_ERROR, urlLoaderIOErrorHandler);
				_urlLoader.addEventListener(ProgressEvent.PROGRESS, urlLoaderProgressHandler);
				_urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, urlLoaderSecurityErrorHandler);
				_urlLoader.dataFormat = URLLoaderDataFormat.BINARY;
			}
		}
		
		private function createLoader():void
		{
			if(_loader == null)
			{
				_loader = new Loader();
				_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loaderCompleteHandler);
				_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, loaderIOErrorHandler);
			}
		}
		
		private function releaseLoaders():void
		{
			close();
			removeListeners();
			if(_loader != null)
			{
				_loader.unloadAndStop(false);
			}
			_loader = null;
			_urlLoader = null;
		}
		
		private function releaseCallbacks(callbacks:Vector.<Function>):void
		{
			if(callbacks != null)
			{
				_objectPool.putObject(callbacks, Vector.<Function>);
			}
		}
		
		private function releaseAllCallbacks():void
		{
			releaseCallbacks(_binaryCompleteCallbacks);
			releaseCallbacks(_binaryIOErrorCallbacks);
			releaseCallbacks(_binaryProgressCallbacks);
			releaseCallbacks(_binarySecurityErrorCallbacks);
			releaseCallbacks(_completeCallbacks);
			releaseCallbacks(_ioErrorCallbacks);
			_binaryCompleteCallbacks = null;
			_binaryIOErrorCallbacks = null;
			_binaryProgressCallbacks = null;
			_binarySecurityErrorCallbacks = null;
			_completeCallbacks = null;
			_ioErrorCallbacks = null;
		}
		
		private function urlLoaderCompleteHandler(event:Event):void
		{
			executeCallbacks(_binaryCompleteCallbacks);
			if(_loaderType & TYPE_NORMAL)
			{
				createLoader();
				_state = STATE_LOADING;
				_loader.loadBytes(_urlLoader.data, _context);
			}
			else
			{
				releaseAllCallbacks();
				removeListeners();
			}
		}
		
		private function urlLoaderProgressHandler(event:ProgressEvent):void
		{
			_bytesLoaded = event.bytesLoaded;
			_bytesTotal = event.bytesTotal;
			executeCallbacks(_binaryProgressCallbacks);
		}
		
		private function urlLoaderIOErrorHandler(event:IOErrorEvent):void
		{
			_state = STATE_LOADING_BINARY_IO_ERROR;
			executeCallbacks(_binaryIOErrorCallbacks);
			releaseLoaders();
			releaseAllCallbacks();
		}
		
		private function urlLoaderSecurityErrorHandler(event:SecurityErrorEvent):void
		{
			_state = STATE_LOADING_BINARY_SECURITY_ERROR;
			executeCallbacks(_binarySecurityErrorCallbacks);
			releaseLoaders();
			releaseAllCallbacks();
		}
		
		private function loaderCompleteHandler(event:Event):void
		{
			_state = STATE_COMPLETE;
			executeCallbacks(_completeCallbacks);
			releaseAllCallbacks();
			removeListeners();
		}
		
		private function loaderIOErrorHandler(event:IOErrorEvent):void
		{
			_state = STATE_LOADING_IO_ERROR;
			executeCallbacks(_ioErrorCallbacks);
			releaseLoaders();
			releaseAllCallbacks();
		}
	}
}