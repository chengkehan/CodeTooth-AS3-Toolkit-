package 
{
	import com.codeTooth.actionscript.algorithm.pathSearching.aStarLike.AStarLike;
	import com.codeTooth.actionscript.algorithm.pathSearching.base.Node;
	import com.codeTooth.actionscript.algorithm.pathSearching.base.SearchingDirection;
	import com.codeTooth.actionscript.lang.utils.Common;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;
	import flash.utils.Timer;
	
	[SWF(width="1000", height="700")]
	public class AStarLikeTest1 extends Sprite 
	{
		private var _rows:uint = 120;
		
		private var _cols:uint = 160;
		
		private var _cellSize:Number = 5;
		
		private var _width:Number = 0;
		
		private var _height:Number = 0;
		
		private var _aStar:AStarLike = null;
		
		private var _box:Shape = null;
		
		private var _moving:Boolean = false;
		
		private var _path:Vector.<int> = null;
		
		private var _pathNodeIndex:int = 0;
		
		private var _timer:Timer = null;
		
		public function AStarLikeTest1()
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			_width = _cellSize * _cols;
			_height = _cellSize * _rows;
			
			graphics.lineStyle(1);
			for (var row:int = 0; row <= _rows; row++)
			{
				graphics.moveTo(0, row * _cellSize);
				graphics.lineTo(_width, row * _cellSize);
			}
			for (var col:int = 0; col <= _cols; col++)
			{
				graphics.moveTo(col * _cellSize, 0);
				graphics.lineTo(col * _cellSize, _height);
			}
			
			var time:int = getTimer()
			_aStar = new AStarLike(_rows, _cols, SearchingDirection.FOUR);
			trace("Create aStar time", getTimer() - time, "ms");
			time = getTimer();
			
			graphics.beginFill(0x000000);
			var stones:Dictionary = new Dictionary();
			for (var i:int = 0; i < 5000; i++)
			{
				row = int(Math.random() * _rows);
				col = int(Math.random() * _cols);
				if (stones[row + Common.DELIM + col] == undefined)
				{
					stones[row + Common.DELIM + col] = 1;
					graphics.drawRect(col * _cellSize, row * _cellSize, _cellSize, _cellSize);
					_aStar.addUnwalkable(row, col);
				}
				else
				{
					i--;
				}
			}
			graphics.endFill();
			trace("Set unwalkable time", getTimer() - time, "ms");
			
			_box = new Shape();
			_box.graphics.beginFill(0xFF0000);
			_box.graphics.drawRect(0, 0, _cellSize, _cellSize);
			_box.graphics.endFill();
			while (true)
			{
				row = int(Math.random() * _rows);
				col = int(Math.random() * _cols);
				if (stones[row + Common.DELIM + col] == undefined)
				{
					_box.x = _cellSize * col;
					_box.y = _cellSize * row;
					break;
				}
			}
			addChild(_box);
			
			stage.addEventListener(MouseEvent.CLICK, clickHandler);
			
			_timer = new Timer(10);
			_timer.addEventListener(TimerEvent.TIMER, moveHandler);
		}
		
		private function inUnwalkable(unwalkable:Vector.<int>, row:int, col:int):Boolean
		{
			if (unwalkable == null)
			{
				return false;
			}
			
			var length:int = unwalkable.length;
			for (var i:int = 0; i < length; i += 2)
			{
				if (unwalkable[i] == row && unwalkable[i + 1] == col)
				{
					return true;
				}
			}
			
			return false;
		}
		
		private function clickHandler(event:MouseEvent):void
		{
			if (mouseX >= 0 && mouseX < _width && mouseY >= 0 && mouseY < _height)
			{
				var time:int = getTimer();
				var path:Vector.<Vector.<int>> = _aStar.search(int(_box.y / _cellSize), int(_box.x / _cellSize), int(mouseY / _cellSize), int(mouseX / _cellSize));
				trace("time", getTimer() - time, "ms");
				if (path == null)
				{
					trace("no path");
				}
				else
				{
					_path = path[0];
					_pathNodeIndex = _path.length - 1;
					if (!_moving)
					{
						_moving = true;
						_timer.start();
					}
				}
			}
			else
			{
				trace("out of bounds");
			}
		}
		
		private function moveHandler(event:TimerEvent):void
		{
			if (_pathNodeIndex < 0)
			{
				_moving = false;
				_timer.stop();
				return;
			}
			
			_box.x = _path[_pathNodeIndex] * _cellSize;
			_box.y = _path[_pathNodeIndex - 1] * _cellSize;
			_pathNodeIndex -= 2;
		}
		
	}
	
}