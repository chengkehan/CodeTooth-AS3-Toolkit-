package com.codeTooth.actionscript.localize.language
{
	import com.codeTooth.actionscript.lang.exceptions.NullPointerException;
	import com.codeTooth.actionscript.lang.utils.destroy.DestroyUtil;
	import com.codeTooth.actionscript.lang.utils.destroy.IDestroy;
	
	import flash.utils.Dictionary;

	public class Languages implements IDestroy
	{
		public function Languages()
		{
			_languages = new Dictionary();
		}
		
		//----------------------------------------------------------------------------------------------------------------------------------
		// Languages
		//----------------------------------------------------------------------------------------------------------------------------------
		
		private var _languages:Dictionary = null;
		
		public function getText(id:String):String
		{
			return _languages[id];
		}
		
		public function createLanguages(data:String, newLineFlag:String, equalFlag:String):void
		{
			if(data == null)
			{
				throw new NullPointerException("Null data");
			}
			
			DestroyUtil.breakMap(_languages);
			
			var lines:Array = data.split(newLineFlag);
			for each(var line:String in lines)
			{
				var blocks:Array = line.split(equalFlag);
				_languages[blocks[0]] = blocks[1];
			}
		}
		
		private function destroyLanguages():void
		{
			DestroyUtil.breakMap(_languages);
			_languages = null;
		}
		
		//----------------------------------------------------------------------------------------------------------------------------------
		// 实现 IDestroy 接口
		//----------------------------------------------------------------------------------------------------------------------------------
		
		public function destroy():void
		{
			destroyLanguages();
		}
	}
}