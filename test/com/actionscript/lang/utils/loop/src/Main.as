package 
{
	import com.codeTooth.actionscript.lang.utils.loop.Loop;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.utils.getTimer;
	import flash.utils.setTimeout;
	
	[SWF(width=1000, height=700)]
	public class Main extends Sprite 
	{
		private var _loop:Loop = null;
		
		public function Main()
		{
			_loop = new Loop();
			_loop.addExecute(new Exe1(this));
			_loop.addExecute(new Exe2(this));
		}
		
	}
	
}