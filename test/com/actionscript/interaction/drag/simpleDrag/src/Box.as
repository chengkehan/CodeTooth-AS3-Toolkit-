package  
{
	import com.codeTooth.actionscript.display.GraphicsPen;
	import com.codeTooth.actionscript.interaction.drag.ISimpleDragable;
	import flash.display.Sprite;
	
	public class Box extends Sprite implements ISimpleDragable
	{
		
		public function Box() 
		{
			graphics.beginFill(0x0099FF);
			GraphicsPen.drawCross(graphics, 100, 50, 0, 0, false);
			graphics.endFill();
		}
		
	}

}