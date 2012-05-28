package
{
	import com.codeTooth.actionscript.lang.utils.Common;
	import com.codeTooth.actionscript.lang.utils.serialize.ini.IniFile;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	public class TestIniFile extends Sprite
	{
		private var _loader:URLLoader = null;
		
		public function TestIniFile()
		{
			_loader = new URLLoader();
			_loader.addEventListener(Event.COMPLETE, completeHandler);
			_loader.load(new URLRequest("ini.txt"));
		}
		
		private function completeHandler(event:Event):void
		{
			var iniFile:IniFile = new IniFile();
			iniFile.newLine = Common.NEW_LINE;
			iniFile.deserialize(_loader.data);
//			trace(iniFile.getValue("name"));
//			trace(iniFile.getValue("age"));
//			iniFile.setValue("name", "coco");
//			iniFile.setValue("age", 30);
//			trace(iniFile.getValue("name"));
//			trace(iniFile.getValue("age"));
			trace(iniFile.serialize());
		}
	}
}