package
{
	import com.codeTooth.actionscript.lang.utils.ByteArrayUtil;
	
	import flash.display.Sprite;
	import flash.utils.ByteArray;
	
	public class Test1 extends Sprite
	{
		public function Test1()
		{
			var bytes:ByteArray = new ByteArray();
			bytes.writeUnsignedInt(1);
			bytes.writeUnsignedInt(2);
			bytes.writeUnsignedInt(3);
			trace("bytes length", bytes.length);
			
			ByteArrayUtil.setVerification(bytes);
			
			if(ByteArrayUtil.checkVerification(bytes, true))
			{
				bytes.position = 0;
				trace(bytes.readUnsignedInt());
				trace(bytes.readUnsignedInt());
				trace(bytes.readUnsignedInt());
				trace("bytes length", bytes.length);
			}
		}
	}
}