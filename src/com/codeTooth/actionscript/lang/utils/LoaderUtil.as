package com.codeTooth.actionscript.lang.utils 
{
	import com.codeTooth.actionscript.core.codeTooth_internal;
	import com.codeTooth.actionscript.lang.utils.collection.Collection;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.utils.Dictionary;
	
	/**
	 * Loader助手。自动销毁对象、添加、移除侦听
	 */
	public class LoaderUtil extends Collection
	{
		use namespace codeTooth_internal;
		
		// Loader 所有的事件类型
		private static var _eventTypes:Vector.<String> = Vector.<String>([Event.COMPLETE, IOErrorEvent.IO_ERROR, ProgressEvent.PROGRESS, Event.INIT, Event.OPEN, HTTPStatusEvent.HTTP_STATUS, Event.UNLOAD]);
		
		// 静态的 LoaderItem 集合
		private static var _loaderItems:Dictionary = new Dictionary();
		
		public function LoaderUtil() 
		{
			
		}
		
		/**
		 * @copy #createLoader()
		 */
		public static function createLoaderStatic(id:Object, autoDelete:Boolean = true, 
			completeHandler:Function = null, ioErrorHandler:Function = null, progressHandler:Function = null, 
			initHandler:Function = null, openHandler:Function = null, httpStatusHandler:Function = null, unloadHandler:Function = null):Loader
		{
			if (_loaderItems[id] != undefined)
			{
				return null;
			}
			else
			{
				var loaderItem:LoaderItem = new LoaderItem(id, deleteLoaderStatic, _eventTypes, autoDelete, 
					completeHandler, ioErrorHandler, progressHandler, 
					initHandler, openHandler, httpStatusHandler, unloadHandler
				);
				_loaderItems[id] = loaderItem;
				
				return loaderItem.getLoader();
			}
		}
		
		/**
		 * @copy #deleteLoader()
		 */
		public static function deleteLoaderStatic(id:Object):Boolean
		{
			if (_loaderItems[id] == undefined)
			{
				return false;
			}
			else
			{
				var loaderItem:LoaderItem = _loaderItems[id];
				loaderItem.destroy();
				delete _loaderItems[id];
				
				return true;
			}
		}
		
		/**
		 * @copy #getLoader()
		 */
		public static function getLoaderStatic(id:Object):Loader
		{
			if (_loaderItems[id] == undefined)
			{
				return null;
			}
			else
			{
				return _loaderItems[id].getLoader();
			}
		}
		
		/**
		 * @copy #containsLoader()
		 */
		public static function containsLoaderStatic(id:Object):Boolean
		{
			return _loaderItems[id] != undefined;
		}
		
		/**
		 * 创建一个Loader
		 * 
		 * @param	id	ID号，不能重复
		 * @param	autoDelete	是否自动清除Loader。如果设为true，当Loader触发Complete或者IOError事件时会自动清除Loader
		 * @param	completeHandler
		 * @param	ioErrorHandler
		 * @param	progressHandler
		 * @param	initHandler
		 * @param	openHandler
		 * @param	httpStatusHandler
		 * @param	unloadHandler
		 * 
		 * @return	返回成功创建的Loader对象。如果ID号重复那么返回null
		 */
		public function createLoader(id:Object, autoDelete:Boolean = true, 
			completeHandler:Function = null, ioErrorHandler:Function = null, progressHandler:Function = null, 
			initHandler:Function = null, openHandler:Function = null, httpStatusHandler:Function = null, unloadHandler:Function = null):Loader
		{
			if (containsItem(id))
			{
				return null;
			}
			else
			{
				return addItem(id, 
					new LoaderItem(id, deleteLoader, _eventTypes, autoDelete, 
						completeHandler, ioErrorHandler, progressHandler, 
						initHandler, openHandler, httpStatusHandler, unloadHandler
					)
				).getLoader();
			}
		}
		
		/**
		 * 删除指定ID的Loader
		 * 
		 * @param	id
		 * 
		 * @return	如果成功删除返回true。不存在指定ID的Loader返回false
		 */
		public function deleteLoader(id:Object):Boolean
		{
			if (containsItem(id))
			{
				removeItem(id).destroy();
				
				return true;
			}
			else
			{
				return false;
			}
		}
		
		/**
		 * 获得指定的Loader对象
		 * 
		 * @param	id
		 * 
		 * @return	没有找到返回null
		 */
		public function getLoader(id:Object):Loader
		{
			if (containsItem(id))
			{
				return getItem(id).getLoader();
			}
			else
			{
				return null;
			}
		}
		
		/**
		 * 判断是否包含指定ID的Loader
		 * 
		 * @param	id
		 * 
		 * @return
		 */
		public function containsLoader(id:Object):Boolean
		{
			return containsItem(id);
		}
	}

}


import com.codeTooth.actionscript.lang.utils.destroy.DestroyUtil;
import com.codeTooth.actionscript.lang.utils.destroy.IDestroy;
import com.codeTooth.actionscript.lang.utils.ListenerUtil;
import flash.display.Loader;
import flash.events.Event;
import flash.events.HTTPStatusEvent;
import flash.events.IOErrorEvent;
import flash.events.ProgressEvent;

class LoaderItem implements IDestroy
{
	private var _id:Object = null;
	
	private var _deleteFunc:Function = null;
	
	private var _eventTypes:Vector.<String> = null;
	
	private var _handlers:Vector.<Function> = null;
	
	private var _autoDelete:Boolean = false;
	
	private var _loader:Loader = null;
	
	private var _completeHanlder:Function = null;
	
	private var _ioErrorHandler:Function = null;
	
	private var _progressHandler:Function = null;
	
	private var _initHandler:Function = null;
	
	private var _openHandler:Function = null;
	
	private var _httpStatusHandler:Function = null;
	
	private var _unloadHandler:Function = null;
	
	public function LoaderItem(id:Object, deleteFunc:Function, eventTypes:Vector.<String>, autoDelete:Boolean,  
		pCompleteHandler:Function, pIOErrorHandler:Function, pProgressHandler:Function, 
		pInitHandler:Function, pOpenHandler:Function, pHttpStatusHandler:Function, pUnloadHandler:Function)
	{
		_id = id;
		_deleteFunc = deleteFunc;
		_eventTypes = eventTypes;
		_autoDelete = autoDelete;
		
		_loader = new Loader();
		
		_completeHanlder = pCompleteHandler;
		_ioErrorHandler = pIOErrorHandler;
		_progressHandler = pProgressHandler;
		_initHandler = pInitHandler;
		_openHandler = pOpenHandler;
		_httpStatusHandler = pHttpStatusHandler;
		_unloadHandler = pUnloadHandler;
		
		// 总是会对 Complete 和 IOError 这两个事件进行侦听，其他的事件则是可选的
		_handlers = Vector.<Function>([
			completeHandler, 
			ioErrorHandler, 
			pProgressHandler == null ? null : progressHandler, 
			pInitHandler == null ? null : initHandler, 
			pOpenHandler == null ? null : openHandler, 
			pHttpStatusHandler == null ? null : httpStatusHandler, 
			pUnloadHandler == null ? null : unloadHandler, 
		]);
		
		ListenerUtil.addListeners(_loader.contentLoaderInfo, _eventTypes, _handlers);
	}
	
	public function getLoader():Loader
	{
		return _loader;
	}
	
	private function deleteMe():void
	{
		if (_autoDelete)
		{
			_deleteFunc(_id);
		}
	}
	
	private function executeHandler(handler:Function, event:Event):void
	{
		if (handler != null)
		{
			handler.length == 0 ? handler() : handler(event);
		}
	}
	
	private function completeHandler(event:Event):void
	{
		executeHandler(_completeHanlder, event);
		deleteMe();
	}
	
	private function ioErrorHandler(event:IOErrorEvent):void
	{
		executeHandler(_ioErrorHandler, event);
		deleteMe();
	}
	
	private function progressHandler(event:ProgressEvent):void
	{
		executeHandler(_progressHandler, event);
	}
	
	private function initHandler(event:Event):void
	{
		executeHandler(_initHandler, event);
	}
	
	private function openHandler(event:Event):void
	{
		executeHandler(_openHandler, event);
	}
	
	private function httpStatusHandler(event:HTTPStatusEvent):void
	{
		executeHandler(_httpStatusHandler, event);
	}
	
	private function unloadHandler(event:Event):void
	{
		executeHandler(_unloadHandler, event);
	}
	
	public function destroy():void
	{
		if (_loader != null)
		{
			ListenerUtil.removeListeners(_loader.contentLoaderInfo, _eventTypes, _handlers);
			DestroyUtil.destroyObject(_loader);
			_loader = null;
			DestroyUtil.breakVector(_handlers);
			_handlers = null;
			_eventTypes = null;
			_id = null;
			_deleteFunc = null;
			_completeHanlder = null;
			_ioErrorHandler = null;
			_progressHandler = null;
			_initHandler = null;
			_openHandler = null;
			_httpStatusHandler = null;
			_unloadHandler = null;
		}
	}
}