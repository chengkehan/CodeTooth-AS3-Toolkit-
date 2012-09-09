package com.codeTooth.actionscript.lang.utils.ctLoader
{
	import com.codeTooth.actionscript.lang.utils.destroy.DestroyUtil;
	import com.codeTooth.actionscript.lang.utils.destroy.IDestroy;
	
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.system.LoaderContext;
	import flash.utils.Dictionary;

	public class CtLoader implements IDestroy
	{
		private var _loaderItems:Dictionary/*key url:String, value CtLoaderItem*/ = null;
		
		public function CtLoader()
		{
			_loaderItems = new Dictionary();
		}
		
		public function load(url:String, context:LoaderContext = null,
							 completeCallback:Function = null, ioErrorCallback:Function = null, 
							 binaryCompleteCallback:Function = null, binaryProgressCallback:Function = null, 
							 binaryIOErrorCallback:Function = null, binarySecurityErrorCallback:Function = null):CtLoaderItem
		{
			var loaderItem:CtLoaderItem = getLoaderItem(url);
			var result:Boolean = loaderItem.load(url, context, 
				completeCallback, ioErrorCallback, 
				binaryCompleteCallback, binaryProgressCallback, binaryIOErrorCallback, binarySecurityErrorCallback
			);
			
			return result ? loaderItem : null;
		}
		
		public function loadImage(url:String, context:LoaderContext = null, loadingPlaceholder:BitmapData = null, errorPlaceholder:BitmapData = null):DisplayObject
		{
			return new CtImage(this, url, context, loadingPlaceholder, errorPlaceholder);
		}
		
		public function destroy():void
		{
			DestroyUtil.destroyVector(_loaderItems);
			_loaderItems = null;
		}
		
		private function getLoaderItem(url:String):CtLoaderItem
		{
			if(_loaderItems[url] == null)
			{
				var item:CtLoaderItem = new CtLoaderItem();
				_loaderItems[url] = item;
				return item;
			}
			else
			{
				return _loaderItems[url];
			}
		}
	}
}