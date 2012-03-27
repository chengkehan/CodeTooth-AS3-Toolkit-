package
{
	import com.codeTooth.actionscript.display.displayAreas.DisplayAreas;
	import com.flashdynamix.utils.SWFProfiler;
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.geom.Rectangle;
	
	[SWF(width="1000", height="700", frameRate="24")]
	public class DisplayAreasTest extends Sprite
	{
		private var _elementContainer:Sprite = null;
		
		private var _gridCanvas:Shape = null;
		
		private var _visibleBoxCanvas:Shape = null;
		
		private var _displayAreas:DisplayAreas = null;
		
		private var _visibleBounds:Rectangle = null;
		
		private var _areaSize:uint = 100;
		
		private var _bufferAreaThickness:uint = 0;
		
		private var _numElements:uint = 1000;
		
		private var _elements:Vector.<Element> = null;
		
		private var _elementSize:uint = 50;
		
		private var _stageWidth:uint = 1000;
		
		private var _stageHeight:uint = 700;
		
		private var _speedMax:Number = 10;
		
		private var _speedMin:Number = 4;
		
		private var _swtichOn:Boolean = false;
		
		public function DisplayAreasTest()
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			addEventListener(Event.ADDED_TO_STAGE, addToStageHandler);
		}
		
		private function addToStageHandler(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, addToStageHandler);
			
			SWFProfiler.init(stage, this);
			
			_swtichOn = false;
			_stageWidth = stage.stageWidth;
			_stageHeight = stage.stageHeight;
			_visibleBounds = new Rectangle(200, 200, 400, 400);
			
			createElementContainer();
			createGrid();
			createVisibleBox();
			createDisplayAreas();
			createElements();
			run();
		}
		
		private function createDisplayAreas():void
		{
			_displayAreas = new DisplayAreas(_elementContainer, _areaSize, _bufferAreaThickness);
			_displayAreas.setVisibleBounds(_visibleBounds.x, _visibleBounds.y, _visibleBounds.width, _visibleBounds.height);
		}
		
		private function createElementContainer():void
		{
			_elementContainer = new Sprite();
			addChild(_elementContainer);
		}
		
		private function createGrid():void
		{
			_gridCanvas = new Shape();
			addChild(_gridCanvas);
			
			_gridCanvas.graphics.lineStyle(1, 0x000000, .5);
			
			var cols:uint = _stageWidth / _areaSize;
			for(var col:uint = 0; col < cols; col++)
			{
				_gridCanvas.graphics.moveTo(col * _areaSize, 0);
				_gridCanvas.graphics.lineTo(col * _areaSize, _stageHeight);
			}
			
			var rows:uint = _stageHeight / _areaSize;
			for(var row:uint = 0; row < rows; row++)
			{
				_gridCanvas.graphics.moveTo(0, row * _areaSize);
				_gridCanvas.graphics.lineTo(_stageWidth, row * _areaSize);
			}
		}
		
		private function createVisibleBox():void
		{
			_visibleBoxCanvas = new Shape();
			addChild(_visibleBoxCanvas);
			
			var bufferSize:uint = _bufferAreaThickness * _areaSize;
			_visibleBoxCanvas.graphics.lineStyle(3, 0xFF0000);
			_visibleBoxCanvas.graphics.drawRect(_visibleBounds.x - bufferSize, _visibleBounds.y - bufferSize, _visibleBounds.width + bufferSize * 2, _visibleBounds.height + bufferSize * 2);
			
			_visibleBoxCanvas.graphics.lineStyle(2, 0x0099FF);
			_visibleBoxCanvas.graphics.drawRect(_visibleBounds.x, _visibleBounds.y, _visibleBounds.width, _visibleBounds.height);
		}
		
		private function createElements():void
		{
			_elements = new Vector.<Element>(_numElements);
			for (var i:int = 0; i < _numElements; i++) 
			{
				_elements[i] = createElement(_stageWidth * Math.random(), _stageHeight * Math.random());
				if(_swtichOn)
				{
					_displayAreas.addElement(_elements[i]);
				}
				else
				{
					_elementContainer.addChild(_elements[i]);
				}
			}
		}
		
		private function createElement(x:Number, y:Number):Element
		{
			var element:Element = new Element(_elementSize, x, y, 
				_speedMin + (_speedMax - _speedMin) * Math.random(), 
				_speedMin + (_speedMax - _speedMin) * Math.random(), 
				_stageWidth, _stageHeight, 0, 0
			);
			return element;
		}
		
		private function run():void
		{
			addEventListener(Event.ENTER_FRAME, loopHandler);
		}
		
		private function loopHandler(event:Event):void
		{
			for each(var element:Element in _elements)
			{
				element.move();
				if(_swtichOn)
				{
					_displayAreas.moveElement(element);
				}
			}
		}
	}
}