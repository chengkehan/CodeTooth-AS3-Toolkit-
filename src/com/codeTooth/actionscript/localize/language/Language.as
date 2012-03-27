package com.codeTooth.actionscript.localize.language
{
	import com.codeTooth.actionscript.lang.exceptions.NullPointerException;
	import com.codeTooth.actionscript.lang.utils.destroy.IDestroy;
	
	import flash.events.EventDispatcher;
	
	public class Language extends EventDispatcher implements IDestroy
	{
		public function Language()
		{
			_languages = new Languages();
		}
		
		//----------------------------------------------------------------------------------------------------------------------------------
		// Langauges
		//----------------------------------------------------------------------------------------------------------------------------------
		
		private var _languages:Languages = null;
		
		private var _newLineFlag:String = null;
		
		private var _equalFlag:String = null;
		
		public function getText(id:String):String
		{
			return _languages.getText(id);
		}
		
		private function destroyLanguages():void
		{
			if(_languages != null)
			{
				_languages.destroy();
				_languages = null;
			}
		}
		
		//----------------------------------------------------------------------------------------------------------------------------------
		// 加载器
		//----------------------------------------------------------------------------------------------------------------------------------
		
		private var _loader:ILanguageLoader = null;
		
		public function load(loader:ILanguageLoader, source:Object, newLineFlag:String, equalFlag:String):void
		{
			if(loader == null)
			{
				throw new NullPointerException("Null loader");
			}
			if(source == null)
			{
				throw new NullPointerException("Null source");
			}
			
			_newLineFlag = newLineFlag;
			_equalFlag = equalFlag;
			destroyLoader();
			_loader = loader;
			addLoaderListeners();
			_loader.load(source);
		}
		
		private function addLoaderListeners():void
		{
			_loader.addEventListener(LanguageEvent.COMPLETE, completeHandler);
			_loader.addEventListener(LanguageEvent.IO_ERROR, ioErrorHandler);
			_loader.addEventListener(LanguageEvent.SECURITY_ERROR, securityErrorHandler);
		}
		
		private function removeLoaderListeners():void
		{
			_loader.removeEventListener(LanguageEvent.COMPLETE, completeHandler);
			_loader.removeEventListener(LanguageEvent.IO_ERROR, ioErrorHandler);
			_loader.removeEventListener(LanguageEvent.SECURITY_ERROR, securityErrorHandler);
		}
		
		private function completeHandler(event:LanguageEvent):void
		{
			_languages.createLanguages(_loader.getLanguageData(), _newLineFlag, _equalFlag);
			destroyLoader();
			dispatchEvent(event);
		}
		
		private function ioErrorHandler(event:LanguageEvent):void
		{
			destroyLoader();
			dispatchEvent(event);
		}
		
		private function securityErrorHandler(event:LanguageEvent):void
		{
			destroyLoader();
			dispatchEvent(event);
		}
		
		private function destroyLoader():void
		{
			if(_loader != null)
			{
				_loader.destroy();
				removeLoaderListeners();
				_loader = null;
			}
		}
		
		//----------------------------------------------------------------------------------------------------------------------------------
		// 实现 IDestroy 接口
		//----------------------------------------------------------------------------------------------------------------------------------
		
		public function destroy():void
		{
			destroyLoader();
			destroyLanguages();
		}
	}
}