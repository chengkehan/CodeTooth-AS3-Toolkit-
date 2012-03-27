package 
{
	import com.codeTooth.actionscript.interaction.selection.SimpleSelectionManager;
	import com.codeTooth.actionscript.interaction.selection.SimpleSelectionManagerEvent;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	
	public class Main extends Sprite 
	{
		private var _selection:SimpleSelectionManager = null;
		
		public function Main()
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			_selection = new SimpleSelectionManager(stage);
			_selection.addEventListener(SimpleSelectionManagerEvent.SELECT_OBJECT, selectObjectHandler);
			_selection.addEventListener(SimpleSelectionManagerEvent.UNSELECT_OBJECT, unselectObjectHandler);
			_selection.boundsWide = 4;
			_selection.boundsColor = 0xFF0080;
			_selection.boundsAlpha = .5;
			
			var box:Box = new Box();
			box.x = 100;
			box.y = 100;
			addChild(box);
			box.name = "box1";
			
			var box2:Box = new Box();
			box2.x = 300;
			box2.y = 300;
			addChild(box2);
			box2.name = "box2";
		}
		
		private function unselectObjectHandler(e:SimpleSelectionManagerEvent):void 
		{
			trace("unselect", Box(e.selectableObject).name);
		}
		
		private function selectObjectHandler(e:SimpleSelectionManagerEvent):void 
		{
			trace("select", Box(e.selectableObject).name);
		}
		
	}
	
}