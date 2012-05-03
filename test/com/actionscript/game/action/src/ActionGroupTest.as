package
{
	import com.codeTooth.actionscript.game.action.ActionData;
	import com.codeTooth.actionscript.game.action.ActionGroup;
	import com.codeTooth.actionscript.game.action.ActionUtil;
	import com.codeTooth.actionscript.game.action.ClipData;
	import com.codeTooth.actionscript.game.action.IAction;
	
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	
	[SWF(frameRate="30", width="1000", height="700")]
	public class ActionGroupTest extends Sprite
	{
		[Embed(source="testSkill.xml", mimeType="application/octet-stream")]
		private var TestSkillXML:Class;
		
		[Embed(source="testSkill.png")]
		private var TestSkillPNG:Class;
		
		private var _actions:Vector.<IAction> = null;
		
		public function ActionGroupTest()
		{
			var sparrow:XML = XML(new TestSkillXML());
			
			var png:BitmapData = new TestSkillPNG().bitmapData;
			
			var clipsData:Vector.<ClipData> = ActionUtil.createClipsBySparrow(sparrow);
			ActionUtil.sliceClips(png, clipsData);
			
			_actions = new Vector.<IAction>();
			for (var i:int = 0; i < 400; i++) 
			{
				var action:ActionGroup = new ActionGroup(Vector.<ActionData>([new ActionData(i, clipsData)]));
				_actions.push(action);
				addChild(action);
				action.x = stage.stageWidth * Math.random() - 150;
				action.y = stage.stageHeight * Math.random() - 150;
			}
			
			addEventListener(Event.ENTER_FRAME, enterFrameHandler);
		}

		private function enterFrameHandler(event:Event):void
		{
			for each(var action:IAction in _actions)
			{
				action.refreshClip();
				action.nextClip();
			}
		}
	}
}