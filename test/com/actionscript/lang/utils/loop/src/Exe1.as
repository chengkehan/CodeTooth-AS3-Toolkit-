package  
{
	import com.codeTooth.actionscript.lang.utils.loop.ILoopExecute;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	
	public class Exe1 implements ILoopExecute 
	{
		private var _container:DisplayObjectContainer = null;
		
		private var _sp:Sprite = null;
		
		private var _speed:Number = 24 / 1000;
		
		private var _x:Number = 0;
		
		private var _moving:Boolean = false;
		
		public function getX():Number
		{
			return _x;
		}
		
		public function Exe1(container:DisplayObjectContainer) 
		{
			_container = container;
			
			_sp = new Sprite();
			_sp.graphics.beginFill(0x0099FF);
			_sp.graphics.drawCircle(0, 0, 10);
			_sp.graphics.endFill();
			_container.addChild(_sp);
		}
		
		public function get complete():Boolean
		{
			return false;
		}
		
		public function loopExecute(currTime:int, prevTime:int):void
		{
			if (!_moving)
			{
				_moving = true;
				return;
			}
			_x += (currTime - prevTime) * _speed;
			_sp.x = _x;
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