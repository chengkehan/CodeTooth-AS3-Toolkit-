package
{
	import com.codeTooth.actionscript.display.displayAreasBaseOnSceneRectangle.SceneRectangleDisplayAreas;
	import com.flashdynamix.utils.SWFProfiler;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.geom.Rectangle;
	
	[SWF(width="1000", height="700", frameRate="30")]
	public class DisplayAreasBaseOnSceneRectangleTest extends Sprite
	{
		private var _container:DisplayObjectContainer = null;
		
		private var _elements:Vector.<Element> = null;
		
		private var _numElements:uint = 2000;
		
		private var _sceneBounds:Rectangle = null;
		
		private var _displayAreas:SceneRectangleDisplayAreas = null;
		
		private var _sceneBoundsCanvas:Sprite = null;
		
		private var _switchOn:Boolean = false;
		
		public function DisplayAreasBaseOnSceneRectangleTest()
		{
			SWFProfiler.init(stage, this);
			
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			_switchOn = true;
			
			createDisplayAreas();
			createElements();
			run();
		}
		
		private function run():void
		{
			addEventListener(Event.ENTER_FRAME, loopHandler);
		}
		
		private function loopHandler(event:Event):void
		{
			for each (var element:Element in _elements) 
			{
				element.move();
				if(_switchOn)
				{
					_displayAreas.moveElement(element);
				}
			}
		}
		
		private function createDisplayAreas():void
		{
			_container = new Sprite();
			addChild(_container);
			
			_sceneBounds = new Rectangle(200, 200, 200, 200);
			
			_displayAreas = new SceneRectangleDisplayAreas(_container);
			_displayAreas.setVisibleBounds(_sceneBounds.x, _sceneBounds.y, _sceneBounds.width, _sceneBounds.height);
			
			_sceneBoundsCanvas = new Sprite();
			_sceneBoundsCanvas.graphics.lineStyle(1);
			_sceneBoundsCanvas.graphics.drawRect(_sceneBounds.x, _sceneBounds.y, _sceneBounds.width, _sceneBounds.height);
			_sceneBoundsCanvas.graphics.endFill();
			addChild(_sceneBoundsCanvas);
		}
		
		private function createElements():void
		{
			_elements = new Vector.<Element>(_numElements);
			for (var i:int = 0; i < _numElements; i++) 
			{
				var element:Element = new Element(
					10, Math.random() * stage.stageWidth, stage.stageHeight * Math.random(), 
					5 + 10 * Math.random(), 5 + 10 * Math.random(), stage.stageWidth, stage.stageHeight, 0, 0);
				_elements[i] = element;
				if(_switchOn)
				{
					_displayAreas.addElement(element);
				}
				else
				{
					_container.addChild(element);
				}
			}
		}
	}
}