package
{
	import com.codeTooth.actionscript.game.avatar.Avatar;
	import com.codeTooth.actionscript.game.avatar.AvatarUnitType;
	
	public class MyAvatar extends Avatar
	{
		public function MyAvatar()
		{
			super();
		}
		
		override public function play(action:int):void
		{
			super.play(action);
			
			if(action == AvatarDirection.TOP)
			{
				swapCanvas(AvatarUnitType.ARM_LEFT, AvatarUnitType.BODY_AFTER, true);
				swapCanvas(AvatarUnitType.CLOTHES_ARM_LEFT, AvatarUnitType.HEAD_BEFORE, true);
				swapCanvas(AvatarUnitType.ARM_RIGHT, AvatarUnitType.LEG_RIGHT_AFTER, true);
				swapCanvas(AvatarUnitType.CLOTHES_ARM_RIGHT, AvatarUnitType.BODY_BEFORE, true);
			}
			else
			{
				swapCanvas(AvatarUnitType.ARM_LEFT, AvatarUnitType.BODY_AFTER, false);
				swapCanvas(AvatarUnitType.CLOTHES_ARM_LEFT, AvatarUnitType.HEAD_BEFORE, false);
				swapCanvas(AvatarUnitType.ARM_RIGHT, AvatarUnitType.LEG_RIGHT_AFTER, false);
				swapCanvas(AvatarUnitType.CLOTHES_ARM_RIGHT, AvatarUnitType.BODY_BEFORE, false);
			}
		}
		
		override public function clearAvatarUnit(avatarUnitType:int, immediately:Boolean = false):void
		{
			switch(avatarUnitType)
			{
				case AvatarUnitType.ARM_LEFT:
				{
					swapCanvas(AvatarUnitType.ARM_LEFT, AvatarUnitType.BODY_AFTER, false, false);
					break;
				}
					
				case AvatarUnitType.CLOTHES_ARM_LEFT:
				{
					swapCanvas(AvatarUnitType.CLOTHES_ARM_LEFT, AvatarUnitType.HEAD_BEFORE, false, false);
					break;
				}
					
				case AvatarUnitType.ARM_RIGHT:
				{
					swapCanvas(AvatarUnitType.ARM_RIGHT, AvatarUnitType.LEG_RIGHT_AFTER, false, false);
					break;
				}
					
				case AvatarUnitType.CLOTHES_ARM_RIGHT:
				{
					swapCanvas(AvatarUnitType.CLOTHES_ARM_RIGHT, AvatarUnitType.BODY_BEFORE, false, false);
					break;
				}
			}
			
			super.clearAvatarUnit(avatarUnitType, immediately);
		}
	}
}