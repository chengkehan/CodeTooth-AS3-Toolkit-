package  
{
	import com.codeTooth.actionscript.interaction.cursor.ICursorTarget;
	import flash.display.Sprite;
	
	public class Box extends Sprite implements ICursorTarget
	{
		private var _cursorType:String = null;
		
		public function Box(width:Number, height:Number, color:uint, line:Boolean, cursorType:String) 
		{
			if (line)
			{
				graphics.lineStyle(1);
			}
			
			graphics.beginFill(color);
			graphics.drawRect(0, 0, width, height);
			graphics.endFill();
			
			_cursorType = cursorType;
		}
		
		public function get cursorType():String
		{
			return _cursorType;
		}
		
	}

}