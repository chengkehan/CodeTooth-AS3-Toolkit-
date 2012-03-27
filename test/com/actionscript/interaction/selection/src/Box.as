package  
{
	import com.codeTooth.actionscript.display.GraphicsPen;
	import com.codeTooth.actionscript.interaction.selection.ISimpleSelectable;
	import flash.display.Sprite;
	
	public class Box extends Sprite implements ISimpleSelectable
	{
		
		public function Box() 
		{
			graphics.beginFill(0x0099FF);
			GraphicsPen.drawCross(graphics, 100, 50);
			graphics.endFill();
		}
		
	}

}