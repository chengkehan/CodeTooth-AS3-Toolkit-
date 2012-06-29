package
{
	import com.codeTooth.actionscript.game.avatar.Avatar;
	import com.codeTooth.actionscript.game.avatar.AvatarUnitType;
	
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	
	[SWF(width="1000", height="700", frameRate="30")]
	public class AvatarTest extends Sprite
	{
		[Embed(source="ryvzj.png", mimeType="image/png")]
		private var Bmpd:Class;
		
		[Embed(source="ryvzj.xml", mimeType="application/octet-stream")]
		private var Xml:Class;
		
		private var _avatars:Vector.<Avatar> = null;
		
		private var _times:int = 0;
		
		public function AvatarTest()
		{
			var bmpd:BitmapData = new Bmpd().bitmapData;
			var sparrow:XML = new XML(new Xml());
			
			Avatar.createAction(0, AvatarUnitType.BODY, bmpd, sparrow, 0, 0);
			
			var actionsIndex:Array = new Array();
			actionsIndex[0] = 6;
			actionsIndex[6] = 6;
			actionsIndex[12] = 6;
			actionsIndex[18] = 6;
			actionsIndex[24] = 6;
			
			actionsIndex[30] = 6;
			actionsIndex[36] = 6;
			actionsIndex[42] = 6;
			actionsIndex[48] = 6;
			actionsIndex[54] = 6;
			
			actionsIndex[60] = 10;
			actionsIndex[70] = 10;
			actionsIndex[80] = 10;
			actionsIndex[90] = 10;
			actionsIndex[100] = 10;
			
			actionsIndex[110] = 7;
			actionsIndex[117] = 7;
			actionsIndex[124] = 7;
			actionsIndex[131] = 7;
			actionsIndex[138] = 7;
			
			actionsIndex[145] = 8;
			actionsIndex[153] = 8;
			actionsIndex[161] = 8;
			actionsIndex[169] = 8;
			actionsIndex[177] = 8;
			
			actionsIndex[185] = 2;
			actionsIndex[187] = 2;
			actionsIndex[189] = 2;
			actionsIndex[191] = 2;
			actionsIndex[193] = 2;
			
			actionsIndex[195] = 1;
			actionsIndex[196] = 1;
			actionsIndex[197] = 1;
			actionsIndex[198] = 1;
			actionsIndex[199] = 1;
			
			_avatars = new Vector.<Avatar>();
			for (var i:int = 0; i < 100; i++) 
			{
				var avatar:Avatar = new Avatar();
				addChild(avatar);
				avatar.setActionsIndex(actionsIndex);
				avatar.setAvatarUnit(0, AvatarUnitType.BODY);
				_avatars.push(avatar);
				avatar.x = Math.random() * (stage.stageWidth - 200);
				avatar.y = Math.random() * (stage.stageHeight - 200);
			}
			
			addEventListener(Event.ENTER_FRAME, loopHandler);
		}
		
		private function loopHandler(event:Event):void
		{
			if(++_times >= 3)
			{
				_times = 0;
				for each(var avatar:Avatar in _avatars)
				{
					avatar.play(0);
				}
			}
		}
	}
}