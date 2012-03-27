package 
{
	import com.codeTooth.actionscript.interaction.cursor.CursorManager;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	
	public class Main extends Sprite 
	{
		private var _cm:CursorManager = null;
		
		public function Main()
		{
			_cm = new CursorManager(stage, this);
			
			var box:Box = new Box(50, 50, 0x0099FF, false, "hand");
			addChild(box);
			
			var cursor:Box = new Box(10, 10, 0x0099FF, true, null);
			_cm.addCursor("hand", cursor);
			
			var normalCursor:Box = new Box(10, 10, 0xFF0000, true, null);
			_cm.normalCursorType = "normalCursor";
			_cm.addCursor("normalCursor", normalCursor);
			
			var box2:Box = new Box(50, 50, 0x00FF00, false, "hand2");
			addChild(box2);
			box2.x = 200;
			box2.y = 200;
			
			var cursor2:Box = new Box(10, 10, 0x00FF00, true, null);
			_cm.addCursor("hand2", cursor2);
		}
		
	}
	
}