package com.codeTooth.actionscript.lang.utils.ctLoader
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.system.LoaderContext;
	
	internal class CtImage extends Bitmap
	{
		private var _loadingPlaceholder:BitmapData = null;
		
		private var _errorPlaceholder:BitmapData = null;
		
		public function CtImage(ctLoader:CtLoader, url:String, context:LoaderContext = null, loadingPlaceholder:BitmapData = null, errorPlaceholder:BitmapData = null)
		{
			_loadingPlaceholder = loadingPlaceholder;
			_errorPlaceholder = errorPlaceholder;
			bitmapData = _loadingPlaceholder;
			ctLoader.load(url, context, completeCallback, errorCallback, errorCallback, errorCallback, errorCallback, errorCallback);
		}
		
		private function completeCallback(loader:CtLoaderItem):void
		{
			bitmapData = loader.getBitmapData();
		}
		
		private function errorCallback(loader:CtLoaderItem):void
		{
			bitmapData = _errorPlaceholder;
		}
	}
}