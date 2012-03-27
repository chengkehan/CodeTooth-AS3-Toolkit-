package  
{
	import com.codeTooth.actionscript.lang.utils.loop.ILoopExecute;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	
	public class Exe2 implements ILoopExecute 
	{
		private var _container:DisplayObjectContainer = null;
		
		private var _sp:Sprite = null;
		
		public function Exe2(container:DisplayObjectContainer) 
		{
			_container = container;
			
			_sp = new Sprite();
			_sp.graphics.beginFill(0xFF0000);
			_sp.graphics.drawCircle(0, 0, 10);
			_sp.graphics.endFill();
			_container.addChild(_sp);
			
			_sp.y = 40;
		}
		
		public function get complete():Boolean
		{
			return false;
		}
		
		public function loopExecute(currTime:int, prevTime:int):void
		{
			_sp.x += 1;
		}
		
		public function destroy():void
		{
			if (_container != null)
			{
				_container.removeChild(_sp);
				_sp = null;
				_container = null;
			}
		}
		
	}

}