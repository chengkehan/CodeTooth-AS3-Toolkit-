package com.codeTooth.actionscript.lang.utils.ctLoader
{
	import com.codeTooth.actionscript.lang.utils.destroy.IDestroy;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.system.LoaderContext;
	
	public class CtIcon extends Bitmap implements IDestroy
	{
		private var _errorPlaceholder:BitmapData = null;
		
		public function CtIcon(ctLoader:CtLoader, url:String, context:LoaderContext = null, 
								loadingPlaceholder:BitmapData = null, errorPlaceholder:BitmapData = null)
		{
			_errorPlaceholder = errorPlaceholder;
			bitmapData = loadingPlaceholder;
			ctLoader.load(url, context, CtLoaderItem.TYPE_NORMAL, completeCallback, errorCallback);
		}
		
		private function completeCallback(loader:CtLoaderItem):void
		{
			bitmapData = loader.getBitmapData();
		}
		
		private function errorCallback(loader:CtLoaderItem):void
		{
			bitmapData = _errorPlaceholder;
		}
		
		public function destroy():void
		{
			_errorPlaceholder = null;
			bitmapData = null;
		}
	}
}