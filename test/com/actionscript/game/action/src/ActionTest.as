package
{
	import com.codeTooth.actionscript.game.action.Action;
	import com.codeTooth.actionscript.game.action.ActionData;
	import com.codeTooth.actionscript.game.action.ClipsDataManager;
	
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	
	[SWF(frameRate="30")]
	public class ActionTest extends Sprite
	{
		[Embed(source="testSkill.xml", mimeType="application/octet-stream")]
		private var TestSkillXML:Class;
		
		[Embed(source="testSkill.png")]
		private var TestSkillPNG:Class;
		
		private var _actions:Vector.<Action> = null;
		
		private var _manager:ClipsDataManager = null;
		
		public function ActionTest()
		{
			var sparrow:XML = XML(new TestSkillXML());
			
			var png:BitmapData = new TestSkillPNG().bitmapData;
			
			_manager = new ClipsDataManager();
			_manager.createClipsData(0, sparrow, png);
			
			_actions = new Vector.<Action>();
			var length:int = 3;
			for (var i:int = 0; i < length; i++) 
			{
				var action:Action = new Action(new ActionData(0, _manager.cloneClipsData(0)));
				_actions.push(action);
				addChild(action);
				action.x = Math.random() * stage.stageWidth;
				action.y = Math.random() * stage.stageHeight;
				action.addEmptyClipPrefix(5 * i);
				action.addEmptyClipSuffix(5 * (length - i));
			}
			
			addEventListener(Event.ENTER_FRAME, enterFrameHandler);
		}
		
		private function enterFrameHandler(event:Event):void
		{
			for each(var action:Action in _actions)
			{
				action.refreshClip();
				action.nextClip();
			}
		}
	}
}