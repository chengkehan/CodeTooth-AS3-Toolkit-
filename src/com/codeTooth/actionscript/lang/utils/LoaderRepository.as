package com.codeTooth.actionscript.lang.utils
{
	import com.codeTooth.actionscript.lang.utils.destroy.DestroyUtil;
	import com.codeTooth.actionscript.lang.utils.destroy.IDestroy;
	
	import flash.display.Loader;
	import flash.utils.Dictionary;
	import com.codeTooth.actionscript.lang.exceptions.NoSuchObjectException;
	
	/**
	 * Loader仓库。
	 * 使用这个类来确保一个url资源只加载一次，当需要使用相同url的资源的时候，使用上一次的加载结果。
	 */
	public class LoaderRepository implements IDestroy
	{
		// 存储所有的Loader
		private var _loadersMap:Dictionary/*key url, value LoaderItem*/ = null;
		
		public function LoaderRepository()
		{
			_loadersMap = new Dictionary();
		}
		
		/**
		 * 判断是否包含指定的资源
		 * 
		 * @param url
		 * @return 
		 */
		public function contains(url:String):Boolean
		{
			return _loadersMap[url] != null
		}
		
		/**
		 * 判断指定的资源是否加载完成
		 * 
		 * @param url
		 * @return 
		 */
		public function isComplete(url:String):Boolean
		{
			if(!contains(url))
			{
				throw new NoSuchObjectException("Has not the loader \"" + url + "\"");
			}
			
			var loaderItem:LoaderItem = LoaderItem(_loadersMap[url]);
			return loaderItem.complete;
		}
		
		/**
		 * 获得指定的loader
		 * 
		 * @param url
		 * @return 
		 */
		public function getLoader(url:String):Loader
		{
			if(!contains(url))
			{
				throw new NoSuchObjectException("Has not the loader \"" + url + "\"");
			}
			
			return LoaderItem(_loadersMap[url]).loader;
		}
		
		/**
		 * 加载一个资源
		 * 
		 * @param url 加载的路径
		 * @param completeCallback 加载成功后的回调，函数原型func(loader:Loader):void。回调函数的入参loader是加载指定url资源所对应的Loader对象
		 * @param ioErrorCallback 加载失败
		 * @param name 资源的名称，如果指定名称，那么以后获得资源将通过这个名称，否则通过url
		 */
		public function load(url:String, completeCallback:Function = null/*func(loader:Loader):void*/, ioErrorCallback:Function = null/*func(void):void*/, name:String = null):void
		{
			name = name == null ? url : name;
			
			var loader:LoaderItem = null;
			if(_loadersMap[name] == null)
			{
				loader = new LoaderItem();
				_loadersMap[name] = loader;
				if(completeCallback != null)
				{
					loader.addCompleteCallback(completeCallback);
				}
				if(ioErrorCallback != null)
				{
					loader.addIOErrorCallback(ioErrorCallback);
				}
				loader.load(url);
			}
			else
			{
				loader = _loadersMap[name];
				if(loader.complete)
				{
					if(completeCallback != null)
					{
						completeCallback(loader.loader);
					}
				}
				else if(loader.ioError)
				{
					if(ioErrorCallback != null)
					{
						ioErrorCallback();
					}
				}
				else
				{
					loader.addCompleteCallback(completeCallback);
				}
			}
		}
		
		//------------------------------------------------------------------------------------------------------------------------------
		// 实现 IDestroy 接口
		//------------------------------------------------------------------------------------------------------------------------------
		
		public function destroy():void
		{
			DestroyUtil.destroyMap(_loadersMap);
			_loadersMap = null;
		}
	}
}


import com.codeTooth.actionscript.lang.utils.destroy.IDestroy;

import flash.display.Loader;
import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.net.URLRequest;

class LoaderItem implements IDestroy
{
	private var _loader:Loader = null;
	
	private var _url:String = null;
	
	private var _completeCallbacks:Vector.<Function> = null;
	
	private var _ioErrorCallbacks:Vector.<Function> = null;
	
	private var _complete:Boolean = false;
	
	private var _ioError:Boolean = false;
	
	public function LoaderItem()
	{
		_completeCallbacks = new Vector.<Function>();
		_ioErrorCallbacks = new Vector.<Function>();
		
		_loader = new Loader();
		_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, completeHandler);
		_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
	}
	
	public function get loader():Loader
	{
		return _loader;
	}
	
	public function load(url:String):void
	{
		_url = url;
		_complete = false;
		_ioError = false;
		_loader.load(new URLRequest(_url));
	}
	
	public function addCompleteCallback(func:Function):void
	{
		_completeCallbacks.push(func);
	}
	
	public function addIOErrorCallback(func:Function):void
	{
		_ioErrorCallbacks.push(func);
	}
	
	public function get complete():Boolean
	{
		return _complete;
	}
	
	public function get ioError():Boolean
	{
		return _ioError;
	}
	
	private function completeHandler(event:Event):void
	{
		_complete = true;
		removeLoaderListeners();
		for each(var func:Function in _completeCallbacks)
		{
			func(_loader);
		}
		_completeCallbacks = null;
		_ioErrorCallbacks = null;
	}
	
	private function ioErrorHandler(event:IOErrorEvent):void
	{
		for each(var func:Function in _ioErrorCallbacks)
		{
			func();
		}
		removeLoaderListeners();
		_completeCallbacks = null;
		_ioErrorCallbacks = null;
		_ioError = true;
	}
	
	private function removeLoaderListeners():void
	{
		_loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, completeHandler);
		_loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
	}
	
	public function destroy():void
	{
		if(_loader != null)
		{
			_loader.unloadAndStop();
			removeLoaderListeners();
			_completeCallbacks = null;
			_ioErrorCallbacks = null;
			_loader = null;
		}
	}
}