package  
{
	import com.adobe.images.JPGEncoder;
	import com.codeTooth.actionscript.lang.utils.ByteArrayUtil;
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.FileReference;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	
	public class Main extends Sprite 
	{
		private var _loader:URLLoader = null;
		
		//private var _loader:Loader = null;
		
		public function Main() 
		{
			_loader = new URLLoader();
			_loader.dataFormat = URLLoaderDataFormat.BINARY;
			_loader.addEventListener(Event.COMPLETE, completeHandler);
			_loader.load(new URLRequest("2009121010122652047.jpg"));
			
			//_loader = new Loader();
			//_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, completeHandler);
			//_loader.load(new URLRequest("image.jpg"));
		}
		
		private function completeHandler(event:Event):void 
		{
			var image:ByteArray = _loader.data;
			//trace(ByteArrayUtil.isPNG(image));
			//trace(ByteArrayUtil.readPNGSize(image));
			trace(ByteArrayUtil.isJPG(image));
			trace(ByteArrayUtil.readJPGSize(image));
			
			//var jpg:JPGEncoder = new JPGEncoder(100);
			//var by:ByteArray = jpg.encode(Bitmap(_loader.content).bitmapData);
			//var fileRef:FileReference = new FileReference();
			//fileRef.save(by);
		}
		
	}

}