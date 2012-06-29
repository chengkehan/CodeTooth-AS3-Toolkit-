package
{
	import com.bit101.components.CheckBox;
	import com.bit101.components.ComboBox;
	import com.codeTooth.actionscript.game.avatar.Avatar;
	import com.codeTooth.actionscript.game.avatar.AvatarUnitType;
	
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	[SWF(frameRate="30", width="1000", height="700")]
	public class AvatarTest2 extends Sprite
	{
		[Embed(source="cloth.png", mimeType="image/png")]
		private var ClothImage:Class;
		[Embed(source="cloth2.png", mimeType="image/png")]
		private var Cloth2Image:Class;
		[Embed(source="cloth.xml", mimeType="application/octet-stream")]
		private var ClothData:Class;
		
		[Embed(source="head.png", mimeType="image/png")]
		private var HeadImage:Class;
		[Embed(source="head.xml", mimeType="application/octet-stream")]
		private var HeadData:Class;
		
		[Embed(source="armRight.png", mimeType="image/png")]
		private var ArmRightImage:Class;
		[Embed(source="armRight.xml", mimeType="application/octet-stream")]
		private var ArmRightData:Class;
		
		[Embed(source="armLeft.png", mimeType="image/png")]
		private var ArmLeftImage:Class;
		[Embed(source="armLeft.xml", mimeType="application/octet-stream")]
		private var ArmLeftData:Class;
		
		[Embed(source="clothArmRight.png", mimeType="image/png")]
		private var ClothArmRightImage:Class;
		[Embed(source="clothArmRight.xml", mimeType="application/octet-stream")]
		private var ClothArmRightData:Class;
		
		[Embed(source="clothArmLeft.png", mimeType="image/png")]
		private var ClothArmLeftImage:Class;
		[Embed(source="clothArmLeft.xml", mimeType="application/octet-stream")]
		private var ClothArmLeftData:Class;
		
		[Embed(source="legRight.png", mimeType="image/png")]
		private var LegRightImage:Class;
		[Embed(source="legRight.xml", mimeType="application/octet-stream")]
		private var LegRightData:Class;
		
		[Embed(source="legLeft.png", mimeType="image/png")]
		private var LegLeftImage:Class;
		[Embed(source="legLeft.xml", mimeType="application/octet-stream")]
		private var LegLeftData:Class;
		
		[Embed(source="hat.png", mimeType="image/png")]
		private var HatImage:Class;
		[Embed(source="hat.xml", mimeType="application/octet-stream")]
		private var HatData:Class;
		
		private var _avatars:Vector.<MyAvatar> = null;
		
		private var _times:int = 0;
		
		private var _frame:int = AvatarDirection.TOP;
		
		public function AvatarTest2()
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			Avatar.createAction(0, AvatarUnitType.BODY, new ClothImage().bitmapData, new XML(new ClothData()), 0, 0);
			Avatar.createAction(1, AvatarUnitType.BODY, new Cloth2Image().bitmapData, new XML(new ClothData()), 0, 0);
			Avatar.createAction(0, AvatarUnitType.HEAD, new HeadImage().bitmapData, new XML(new HeadData()), 0, 0);
			Avatar.createAction(0, AvatarUnitType.ARM_RIGHT, new ArmRightImage().bitmapData, new XML(new ArmRightData()), 0, 0);
			Avatar.createAction(0, AvatarUnitType.ARM_LEFT, new ArmLeftImage().bitmapData, new XML(new ArmLeftData()), 0, 0);
			Avatar.createAction(0, AvatarUnitType.CLOTHES_ARM_RIGHT, new ClothArmRightImage().bitmapData, new XML(new ClothArmRightData()), 0, 0);
			Avatar.createAction(0, AvatarUnitType.CLOTHES_ARM_LEFT, new ClothArmLeftImage().bitmapData, new XML(new ClothArmLeftData()), 0, 0);
			Avatar.createAction(0, AvatarUnitType.LEG_RIGHT, new LegRightImage().bitmapData, new XML(new LegRightData()), 0, 0);
			Avatar.createAction(0, AvatarUnitType.LEG_LEFT, new LegLeftImage().bitmapData, new XML(new LegLeftData()), 0, 0);
			Avatar.createAction(0, AvatarUnitType.HAT, new HatImage().bitmapData, new XML(new HatData()), 0, 0);
			
			var actionsIndex:Array = new Array();
			actionsIndex[AvatarDirection.TOP] = 8;
			actionsIndex[AvatarDirection.TOP_RIGHT] = 8;
			actionsIndex[AvatarDirection.RIGHT] = 8;
			actionsIndex[AvatarDirection.RIGHT_BOTTOM] = 8;
			actionsIndex[AvatarDirection.BOTTOM] = 8;
			
			_avatars = new Vector.<MyAvatar>();
			for (var i:int = 0; i < 100; i++) 
			{
				var avatar:MyAvatar = new MyAvatar();
				addChild(avatar);
				avatar.setActionsIndex(actionsIndex);
				avatar.setAvatarUnit(0, AvatarUnitType.BODY);
				avatar.setAvatarUnit(0, AvatarUnitType.HEAD);
				avatar.setAvatarUnit(0, AvatarUnitType.ARM_RIGHT);
				avatar.setAvatarUnit(0, AvatarUnitType.ARM_LEFT);
				avatar.setAvatarUnit(0, AvatarUnitType.CLOTHES_ARM_RIGHT);
				avatar.setAvatarUnit(0, AvatarUnitType.CLOTHES_ARM_LEFT);
				avatar.setAvatarUnit(0, AvatarUnitType.LEG_RIGHT);
				avatar.setAvatarUnit(0, AvatarUnitType.LEG_LEFT);
				avatar.setAvatarUnit(0, AvatarUnitType.HAT);
				_avatars.push(avatar);
				avatar.x = Math.random() * (stage.stageWidth - 200);
				avatar.y = Math.random() * (stage.stageHeight - 200);
			}
			
			addEventListener(Event.ENTER_FRAME, loopHandler);
			
			initializeUI();
		}
		
		private function loopHandler(event:Event):void
		{
			if(++_times >= 3)
			{
				_times = 0;
				for each(var avatar:MyAvatar in _avatars)
				{
					avatar.play(_frame);
				}
			}
		}
		
		//------------------------------------------------------------------------------------------------------------------------------
		// UI
		//------------------------------------------------------------------------------------------------------------------------------
		
		private var _cb:ComboBox = null;
		
		private var _clothesArmCkb:CheckBox = null;
		
		private var _clothesCb:ComboBox = null;
		
		private function initializeUI():void
		{
			_cb = new ComboBox(this, 0, 0, "Top", [
				{ label:"Top" }, { label:"TopRight" }, { label:"Right" }, { label:"RightBottom" }, { label:"Bottom" }
			]);
			_cb.addEventListener(Event.SELECT, cbSelectHandler);
			
			_clothesArmCkb = new CheckBox(this, 0, 30, "ClothesArm", clothesArmCbHandler);
			_clothesArmCkb.selected = true;
			
			_clothesCb = new ComboBox(this, 0, 60, "Cloth1", [
				{ label:"Cloth1" }, { label:"Cloth2" }
			]);
			_clothesCb.addEventListener(Event.SELECT, clothesCbHandler);
		}
		
		private function clothesCbHandler(event:Event):void
		{
			var item:Object = _clothesCb.selectedItem;
			for each(var avatar:MyAvatar in _avatars)
			{
				if(item.label == "Cloth1")
				{
					avatar.setAvatarUnit(0, AvatarUnitType.BODY);
				}
				else if(item.label == "Cloth2")
				{
					avatar.setAvatarUnit(1, AvatarUnitType.BODY);
				}
			}
		}
		
		private function clothesArmCbHandler(event:Event):void
		{
			for each(var avatar:MyAvatar in _avatars)
			{
				if(_clothesArmCkb.selected)
				{
					avatar.setAvatarUnit(0, AvatarUnitType.CLOTHES_ARM_RIGHT);
					avatar.setAvatarUnit(0, AvatarUnitType.CLOTHES_ARM_LEFT);
				}
				else
				{
					avatar.clearAvatarUnit(AvatarUnitType.CLOTHES_ARM_RIGHT);
					avatar.clearAvatarUnit(AvatarUnitType.CLOTHES_ARM_LEFT);
				}
			}
		}
		
		private function cbSelectHandler(event:Event):void
		{
			var item:Object = _cb.selectedItem;
			_frame = item.label == "Top" ? AvatarDirection.TOP : 
				item.label == "TopRight" ? AvatarDirection.TOP_RIGHT : 
				item.label == "Right" ? AvatarDirection.RIGHT : 
				item.label == "RightBottom" ? AvatarDirection.RIGHT_BOTTOM : 
				item.label == "Bottom" ? AvatarDirection.BOTTOM : AvatarDirection.TOP;
		}
	}
}