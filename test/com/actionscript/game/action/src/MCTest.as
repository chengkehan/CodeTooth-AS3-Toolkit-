package
{
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.URLRequest;
	
	public class MCTest extends Sprite
	{
		private var _loader:Loader = null;
		
		public function MCTest()
		{
			_loader = new Loader();
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, completeHandler);
			_loader.load(new URLRequest("youlongciJGup.swf"));
		}
		
		private function completeHandler(event:Event):void
		{
			var clazz:Class = Class(_loader.contentLoaderInfo.applicationDomain.getDefinition("youlongciJGup"));
			for (var i:int = 0; i < 200; i++) 
			{
				var mc:DisplayObject = new clazz();
				addChild(mc);
				mc.x = Math.random() * stage.stageWidth;
				mc.y = Math.random() * stage.stageHeight;
			}
		}
	}
}