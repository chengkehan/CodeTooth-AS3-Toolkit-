package com.codeTooth.actionscript.game.map.loader
{
	import com.codeTooth.actionscript.lang.exceptions.NullPointerException;
	import com.codeTooth.actionscript.lang.utils.destroy.DestroyUtil;
	import com.codeTooth.actionscript.lang.utils.destroy.IDestroy;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;

	internal class CellLoader implements IDestroy
	{
		private var _id:String = null;
		
		private var _url:String = null;
		
		private var _row:uint = 0;
		
		private var _col:uint = 0;
		
		private var _debug:Boolean = false;
		
		private var _loader:Loader = null;
		
		private var _completeCallback:Function = null;
		
		public function CellLoader(id:String, url:String, row:uint, col:uint, 
								   debug:Boolean, completeCallback:Function/*func(obj:CellLoader):void*/)
		{
			if(completeCallback == null)
			{
				throw new NullPointerException("Null completeCallback");
			}
			
			_id = id;
			_url = url;
			_row = row;
			_col = col;
			_debug = debug;
			_completeCallback = completeCallback;
			
			_loader = new Loader();
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, completeHandler);
			_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			_loader.load(new URLRequest(url));
		}
		
		public function get id():String
		{
			return _id;
		}
		
		public function get url():String
		{
			return _url;
		}
		
		public function get row():uint
		{
			return _row;
		}
		
		public function get col():uint
		{
			return _col;
		}
		
		public function getLoader():Loader
		{
			return _loader;
		}
		
		public function getBitmapData():BitmapData
		{
			return Bitmap(_loader.content).bitmapData;
		}
		
		private function removeLoaderListeners():void
		{
			_loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, completeHandler);
			_loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
		}
		
		private function completeHandler(event:Event):void
		{
			removeLoaderListeners();
			_completeCallback(this);
			
			if(_debug)
			{
				trace("Load cellLoader complete: \"" + _url + "\"");
			}
		}
		
		private function ioErrorHandler(event:IOErrorEvent):void
		{
			if(_debug)
			{
				trace("Load cellLoader ioError: \"" + _url + "\"");
			}
		}
		
		//----------------------------------------------------------------------------------------------------------------------------------
		// 实现 IDestroy 接口
		//----------------------------------------------------------------------------------------------------------------------------------
		
		public function destroy():void
		{
			if(_loader != null)
			{
				removeLoaderListeners();
				DestroyUtil.destroyObject(_loader);
				_loader = null;
			}
			_completeCallback = null;
		}
		
	}
}