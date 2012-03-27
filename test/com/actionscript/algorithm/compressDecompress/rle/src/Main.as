package 
{
	import com.codeTooth.actionscript.algorithm.compressDecompress.RLE;
	import flash.display.Sprite;
	import flash.net.FileReference;
	import flash.utils.ByteArray;
	import flash.utils.getTimer;
	
	public class Main extends Sprite 
	{
		
		public function Main()
		{
			//var str:String = "";
			//for (var i:int = 0; i < 100; i++)
			//{
				//str += "A"
			//}
			var str:String = "abccccdeeeeeeeeeeeeeeefffffffffffffffffffffffffgkkkkkkkkkkkkkkkkkkkkkkkkmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmkkkkkkkkkkkkkkkkkkkkkkkkkkkkk";
			var newString:String = RLE.compressASCII(str);
			
			trace("---------------------------------------");
			trace(newString);
			trace(newString.length);
			trace(RLE.decompressASCII(newString));
			trace("---------------------------------------");
			
			//var fileRef:FileReference = new FileReference();
			//fileRef.save(newString);
		}
		
	}
	
}