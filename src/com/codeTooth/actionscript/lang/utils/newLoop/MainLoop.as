package com.codeTooth.actionscript.lang.utils.newLoop
{
	import com.codeTooth.actionscript.lang.exceptions.NullPointerException;
	import com.codeTooth.actionscript.lang.utils.destroy.DestroyUtil;
	import com.codeTooth.actionscript.lang.utils.destroy.IDestroy;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.Dictionary;
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
		
		// 删除子循环的队列
		// 需要删除的子循环对象会临时的保存在这里
		// 当单次主循环进行到最后的时候统一删除
		private var _removeSubLoopsQueue:Dictionary = null;
		private var _removeSubLoopsQueueLength:int = 0;
		
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
			
			_removeSubLoopsQueue = new Dictionary();
			_removeSubLoopsQueueLength = 0;
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
			if(subLoop == null)
			{
				throw new NullPointerException("Null subLoop");
			}
			
			if(_removeSubLoopsQueue[subLoop] == null)
			{
				_removeSubLoopsQueue[subLoop] = subLoop;
				_removeSubLoopsQueueLength++;
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
			DestroyUtil.breakMap(_removeSubLoopsQueue);
			_removeSubLoopsQueueLength = 0;
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
				if(_removeSubLoopsQueue[subLoop] != null)
				{
					continue;
				}
				
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
			
			// 从删除队列中删除所有的子循环
			if(_removeSubLoopsQueueLength > 0)
			{
				for each(var removeSubLoop:ISubLoop in _removeSubLoopsQueue)
				{
					var removeIndex:int = _subLoops.indexOf(removeSubLoop);
					if(removeIndex != -1)
					{
						_subLoops.splice(removeIndex, 1);
						_length--;
					}
				}
				DestroyUtil.breakMap(_removeSubLoopsQueue);
				_removeSubLoopsQueueLength = 0;
			}
			
			_time = currTime;
		}
		
		//------------------------------------------------------------------------------------------------------------------------------
		// 实现 IDestroy 接口
		//------------------------------------------------------------------------------------------------------------------------------
		
		public function destroy():void
		{
			removeEventListener(Event.ENTER_FRAME, mainLoopHandler);
			
			_fpsChangedEvent = null;
			
			DestroyUtil.breakVector(_subLoops);
			_subLoops = null;
			
			DestroyUtil.breakMap(_removeSubLoopsQueue);
			_removeSubLoopsQueue = null;
		}
	}
}