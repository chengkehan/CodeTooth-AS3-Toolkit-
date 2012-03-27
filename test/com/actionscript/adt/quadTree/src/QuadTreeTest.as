package
{
	import com.codeTooth.actionscript.adt.quadTree.QuadTree;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.utils.getTimer;
	
	[SWF(width="1000", height="700", frameRate="24")]
	public class QuadTreeTest extends Sprite
	{
		private var _stageWidth:uint = 0;
		
		private var _stageHeight:uint = 0;
		
		private var _quadTree:QuadTree = null;
		
		private var _elements:Vector.<Element> = null;
		
		private var _numElements:uint = 400;
		
		private var _elementSize:uint = 5;
		
		private var _elementContainer:Sprite = null;
		
		private var _bounds:Rectangle = null;
		
		private var _boundsCanvas:Sprite = null;
		
		public function QuadTreeTest()
		{
			addEventListener(Event.ADDED_TO_STAGE, addToStageHandler);
		}
		
		private function addToStageHandler(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, addToStageHandler);
			
			_stageWidth = stage.stageWidth;
			_stageHeight = stage.stageHeight;
			
			var time:uint = getTimer();
			_quadTree = new QuadTree(new Rectangle(0, 0, _stageWidth, _stageHeight), 6);
			trace("create tree spend: " + (getTimer() - time));
			
			createElements();
			createBounds();
			//run();
		}
		
		private function run():void
		{
			var time:int = getTimer();
			for (var i:int = 0; i < 500; i++) 
			{
			var elements:Vector.<DisplayObject> = _quadTree.getDisplayObjects(_bounds.x, _bounds.y, _bounds.width, _bounds.height);
			}
			trace("search elements spend: " + (getTimer() - time) + "ms");
			
			for each (var element:DisplayObject in elements) 
			{
				element.alpha = .5;
			}
		}
		
		private function createElements():void
		{
			_elementContainer = new Sprite();
			addChild(_elementContainer);
			
			_elements = new Vector.<Element>(_numElements);
			for (var i:int = 0; i < _numElements; i++) 
			{
				var element:Element = new Element(_elementSize);
				_elements[i] = element;
				element.x = _stageWidth * Math.random();
				element.y = _stageHeight * Math.random();
				_elementContainer.addChild(element);
				//_quadTree.addDisplayObject(element);
			}
			
			var time:int = getTimer();
			for each (var element2:Element in _elements) 
			{
				_quadTree.addDisplayObject(element2);
				_quadTree.removeDisplayObject(element2);
			}
			trace("add remove elements spend: " + (getTimer() - time));
			
		}
		
		private function createBounds():void
		{
			_bounds = new Rectangle(500, 300, 200, 200);
			
			_boundsCanvas = new Sprite();
			_boundsCanvas.graphics.lineStyle(1);
			_boundsCanvas.graphics.drawRect(_bounds.x, _bounds.y, _bounds.width, _bounds.height);
			_boundsCanvas.graphics.endFill();
			addChild(_boundsCanvas);
		}
	}
}