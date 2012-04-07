package
{
	import com.codeTooth.actionscript.game.action.ActionUtil;
	
	import flash.display.Sprite;
	
	public class SparrowLegalTest extends Sprite
	{
		[Embed(source="effect.xml", mimeType="application/octet-stream")]
		private var TestSkillXML:Class;
		
		public function SparrowLegalTest()
		{
			var sparrow:XML = XML(new TestSkillXML());
			
			trace(ActionUtil.sparrowLegal(sparrow));
		}
	}
}