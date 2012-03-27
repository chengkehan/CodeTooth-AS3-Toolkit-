package
{
	import flash.display.Sprite;
	
	public class Element extends Sprite
	{
		public function Element(size:uint)
		{
			graphics.beginFill(0x444444);
			graphics.drawCircle(0, 0, size);
			graphics.endFill();
		}
	}
}