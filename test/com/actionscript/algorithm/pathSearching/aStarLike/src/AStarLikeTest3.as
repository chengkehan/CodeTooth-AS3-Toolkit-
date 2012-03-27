package
{
	import com.bit101.components.PushButton;
	import com.bit101.components.RadioButton;
	import com.codeTooth.actionscript.algorithm.pathSearching.aStar.AStar;
	import com.codeTooth.actionscript.algorithm.pathSearching.aStarLike.AStarLike;
	import com.codeTooth.actionscript.algorithm.pathSearching.base.IPathSearching;
	import com.codeTooth.actionscript.algorithm.pathSearching.base.SearchingDirection;
	import com.codeTooth.actionscript.display.Box;
	import com.codeTooth.actionscript.display.GraphicsPen;
	import com.codeTooth.actionscript.lang.utils.Common;
	
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;
	
	[SWF(width="1000", height="700", frameRate="15")]
	public class AStarLikeTest3 extends Sprite
	{
		private var _gridCanvas:Shape = null;
		
		private var _rows:uint = 30;
		
		private var _cols:uint = 40;
		
		private var _cellSize:uint = 20;
		
		private var _startPoint:Box = null;
		
		private var _endPoint:Box = null;
		
		private var _aStar:IPathSearching = null;
		
		private var _useDrawBlockPenRBtn:RadioButton = null;
		private var _useDrawStartPointPenRBtn:RadioButton = null;
		private var _useDrawEndPointPenRBtn:RadioButton = null;
		
		private var _runBtn:PushButton = null;
		
		private var _currDrawPolicy:Function = drawBlock;
		
		private var _blocks:Dictionary/*key id(row_col), value Box*/ = null;
		
		private var _roleBox:Box = null;
		
		private var _path:Vector.<Vector.<int>> = null;
		
		private var _pathIndex:int = 0;
		
		public function AStarLikeTest3()
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			initializeGridCanvas();
			initiailzePoints();
			initializeAStar();
			initializeBtns();
			initializeStageListeners();
			initializeBlocks();
		}
		
		private function drawBlock(x:Number, y:Number):void
		{
			if(x >= 0 && x < _cellSize * _cols && y >= 0 && y < _cellSize * _rows)
			{
				var row:int = y / _cellSize;
				var col:int = x / _cellSize;
				var id:String = row + Common.DELIM + col;
				var box:Box = null;
				if(_blocks[id] == null)
				{
					box = new Box(_cellSize, _cellSize, 0x444444);
					_blocks[id] = box;
					positionObjectByXY(box, x, y);
					addChild(box);
					_aStar.addUnwalkable(row, col);
				}
				else
				{
					box = _blocks[id];
					delete _blocks[id];
					removeChild(box);
					_aStar.removeUnwalkable(row, col);
				}
			}
		}
		
		private function drawStartPoint(x:Number, y:Number):void
		{
			positionObjectByXY(_startPoint, x, y);
		}
		
		private function drawEndPoint(x:Number, y:Number):void
		{
			positionObjectByXY(_endPoint, x, y);
		}
		
		private function initializeStageListeners():void
		{
			stage.addEventListener(MouseEvent.CLICK, stageClickHandler);
		}
		
		private function stageClickHandler(event:MouseEvent):void
		{
			_currDrawPolicy(mouseX, mouseY);
		}
		
		private function initializeBlocks():void
		{
			_blocks = new Dictionary();
		}
		
		private function initializeBtns():void
		{
			_useDrawBlockPenRBtn = new RadioButton(this, _cols * _cellSize + _cellSize, _cellSize, "Draw block", true, useDrawBlockPenRBtnHandler);
			_useDrawStartPointPenRBtn = new RadioButton(this, _cols * _cellSize + _cellSize, _cellSize + _cellSize, "Draw start point", false, useDrawStartPointPenRBtnHandler);
			_useDrawEndPointPenRBtn = new RadioButton(this, _cols * _cellSize + _cellSize, _cellSize + _cellSize * 2, "Draw end point", false, useDrawEndPointPenRBtnHandler);
			
			_runBtn = new PushButton(this, _cols * _cellSize + _cellSize, _cellSize + _cellSize * 3, "Run", runBtnHandler);
		}
		
		private function runBtnHandler(event:MouseEvent):void
		{
			if(!hasEventListener(Event.ENTER_FRAME))
			{
				var rowFrom:int = _startPoint.y / _cellSize;
				var colFrom:int = _startPoint.x / _cellSize;
				
				var rowTo:int = _endPoint.y / _cellSize;
				var colTo:int = _endPoint.x / _cellSize;
			
				var time:int = getTimer();
				_path = _aStar.search(rowFrom, colFrom, rowTo, colTo);
				trace("AStar time spend: " + (getTimer() - time));
				
				if(_path == null || _path[0] == null)
				{
					return;
				}
					
				_pathIndex = _path[0].length - 1;
				
				_roleBox.visible = true;
				addEventListener(Event.ENTER_FRAME, roleMoveHandler);
			}
		}
		
		private function roleMoveHandler(event:Event):void
		{
			if(_pathIndex < 0)
			{
				_roleBox.visible = false;
				removeEventListener(Event.ENTER_FRAME, roleMoveHandler);
			}
			else
			{
				_roleBox.x = _path[0][_pathIndex] * _cellSize;
				_roleBox.y = _path[0][_pathIndex - 1] * _cellSize;
				_pathIndex -= 2;
			}
		}
		
		private function useDrawBlockPenRBtnHandler(event:MouseEvent):void
		{
			_currDrawPolicy = drawBlock;
		}
		
		private function useDrawStartPointPenRBtnHandler(event:MouseEvent):void
		{
			_currDrawPolicy = drawStartPoint;
		}
		
		private function useDrawEndPointPenRBtnHandler(event:MouseEvent):void
		{
			_currDrawPolicy = drawEndPoint;
		}
		
		private function initializeAStar():void
		{
			_aStar = new AStar(_rows, _cols);
		}
		
		private function positionObjectByXY(point:DisplayObject, x:Number, y:Number):void
		{
			var row:int = y / _cellSize;
			var col:int = x / _cellSize;
			if(row >= 0 && row < _rows && col >= 0 && col < _cols)
			{
				positionObjectByRowCol(point, y / _cellSize, x / _cellSize);
			}
		}
		
		private function positionObjectByRowCol(point:DisplayObject, row:int, col:int):void
		{
			point.x = col * _cellSize;
			point.y = row * _cellSize;
		}
		
		private function initiailzePoints():void
		{
			_startPoint = new Box(_cellSize, _cellSize, 0x0099FF);
			addChild(_startPoint);
			
			_endPoint = new Box(_cellSize, _cellSize, 0xFF0000);
			addChild(_endPoint);
			positionObjectByRowCol(_endPoint, _rows - 1, _cols - 1);
			
			_roleBox = new Box(_cellSize, _cellSize, 0x00FF00);
			addChild(_roleBox);
			_roleBox.visible = false;
		}
		
		private function initializeGridCanvas():void
		{
			_gridCanvas = new Shape();
			addChild(_gridCanvas);
			
			_gridCanvas.graphics.lineStyle(1);
			GraphicsPen.drawGridLines(_gridCanvas.graphics, _rows, _cols, _cellSize, _cellSize);
		}
	}
}