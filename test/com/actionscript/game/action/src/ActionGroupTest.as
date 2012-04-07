package
{
	import com.codeTooth.actionscript.game.action.ActionData;
	import com.codeTooth.actionscript.game.action.ActionGroup;
	import com.codeTooth.actionscript.game.action.ActionUtil;
	import com.codeTooth.actionscript.game.action.ClipData;
	
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	
	[SWF(frameRate="30")]
	public class ActionGroupTest extends Sprite
	{
		[Embed(source="testSkill.xml", mimeType="application/octet-stream")]
		private var TestSkillXML:Class;
		
		[Embed(source="testSkill.png")]
		private var TestSkillPNG:Class;
		
		private var _actionGroup:ActionGroup = null;
		
		public function ActionGroupTest()
		{
			var sparrow:XML = XML(new TestSkillXML());
			
			var png:BitmapData = new TestSkillPNG().bitmapData;
			
			var clipsData:Vector.<ClipData> = ActionUtil.createClipsBySparrow(sparrow);
			ActionUtil.sliceClips(png, clipsData);
			
			var actionsData:Vector.<ActionData> = new Vector.<ActionData>();
			for (var i:int = 0; i < 200; i++) 
			{
				actionsData.push(new ActionData(0, clipsData));
			}
			_actionGroup = new ActionGroup(actionsData);
			addChild(_actionGroup);
			
			addEventListener(Event.ENTER_FRAME, enterFrameHandler);
		}

		private function enterFrameHandler(event:Event):void
		{
			_actionGroup.refreshClip();
			_actionGroup.nextClip();
		}
	}
}