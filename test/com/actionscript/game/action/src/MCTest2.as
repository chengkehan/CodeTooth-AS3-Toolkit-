package
{
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.URLRequest;
	
	[SWF(frameRate="30", backgroundColor="0x000000")]
	public class MCTest2 extends Sprite
	{
		private var _loader:Loader = null;
		
		public function MCTest2()
		{
			_loader = new Loader();
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, completeHandler);
			_loader.load(new URLRequest("mc2.swf"));
		}
		
		private function completeHandler(event:Event):void
		{
			var clazz:Class = Class(_loader.contentLoaderInfo.applicationDomain.getDefinition("GoldMC"));
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