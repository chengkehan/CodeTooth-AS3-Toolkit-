package com.codeTooth.actionscript.lang.utils.nLoop
{
	import com.codeTooth.actionscript.lang.exceptions.NullPointerException;
	import com.codeTooth.actionscript.lang.utils.destroy.DestroyUtil;
	import com.codeTooth.actionscript.lang.utils.destroy.IDestroy;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.getTimer;

	/**
	 * 主循环控制类
	 */
	public class MainLoop extends Sprite implements IDestroy
	{
		// fps采样次数
		private const SAMPLE_AMOUNT:int = 30;
		
		// 当前的毫秒数
		private var _time:int = 0
			
		// 当前的fps
		private var _fps:int = 0;
		
		// 上次一的fps
		private var _prevFPS:int = 0;
		
		// fps采样计数
		private var _sampleCount:int = 0;
		
		// 时间间隔求和计数
		private var _stepSum:int = 0;
		
		private var _fpsChangedEvent:MainLoopEvent = null;
		
		// 
		private var _subLoops:Vector.<ISubLoop> = null;
		
		private var _length:int = 0;
		
		/**
		 * 构造函数
		 * 
		 * @param initFPS 初始化时的fps
		 */
		public function MainLoop(initFPS:int)
		{
			_length = 0;
			_fps = initFPS;
			_prevFPS = initFPS;
			_fpsChangedEvent = new MainLoopEvent(MainLoopEvent.FPS_CHANGED);
			
			_time = getTimer();
			addEventListener(Event.ENTER_FRAME, mainLoopHandler);
			
			_subLoops = new Vector.<ISubLoop>();
		}
		
		/**
		 * 获得当前的fps
		 */
		public function get fps():int
		{
			return _fps;
		}
		
		/**
		 * 获得当前的毫秒数
		 */
		public function get time():int
		{
			return _time;
		}
		
		public function get numSubLoops():int
		{
			return _length;
		}
		
		public function containsSubLoop(subLoop:ISubLoop):Boolean
		{
			return _subLoops.indexOf(subLoop) != -1;
		}
		
		public function addSubLoop(subLoop:ISubLoop):void
		{
			if(subLoop == null)
			{
				throw new NullPointerException("Null subLoop");
			}
			
			_length++;
			_subLoops.push(subLoop);
		}
		
		public function removeSubLoop(subLoop:ISubLoop):void
		{
			var index:int = _subLoops.indexOf(subLoop);
			if(index != -1)
			{
				_length--;
				_subLoops.splice(index, 1);
			}
		}
		
		public function removeSubLoops(subLoops:Vector.<ISubLoop>):void
		{
			for each(var subLoop:ISubLoop in subLoops)
			{
				removeSubLoop(subLoop);
			}
		}
		
		public function removeAllSubLoops():void
		{
			DestroyUtil.breakVector(_subLoops);
			_length = 0;
		}
		
		private function mainLoopHandler(event:Event):void
		{
			var currTime:int = getTimer();
			var step:int = currTime - _time;
			_stepSum += step;
			
			if(++_sampleCount == SAMPLE_AMOUNT)
			{
				_sampleCount = 0;
				_fps = 1000 / (_stepSum / SAMPLE_AMOUNT);
				_stepSum = 0;
				
				if(_fps != _prevFPS)
				{
					_fpsChangedEvent.prevFPS = _prevFPS;
					_fpsChangedEvent.currFPS = _fps;
					_prevFPS = _fps;
					dispatchEvent(_fpsChangedEvent);
				}
			}
			
			for (var i:int = 0; i < _length; i++) 
			{
				var subLoop:ISubLoop = _subLoops[i];
				if(subLoop.canEnter)
				{
					subLoop.loop(_time, currTime);
				}
				if(subLoop.canExit)
				{
					_subLoops.splice(i, 1);
					--_length;
					--i;
				}
			}
			
			_time = currTime;
		}
		
		//------------------------------------------------------------------------------------------------------------------------------
		// 实现 IDispose 接口
		//------------------------------------------------------------------------------------------------------------------------------
		
		public function destroy():void
		{
			removeEventListener(Event.ENTER_FRAME, mainLoopHandler);
			
			_fpsChangedEvent = null;
			
			DestroyUtil.breakVector(_subLoops);
			_subLoops = null;
		}
	}
}