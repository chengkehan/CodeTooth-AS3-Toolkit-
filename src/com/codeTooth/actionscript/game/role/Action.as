package com.codeTooth.actionscript.game.role
{
	import com.codeTooth.actionscript.lang.utils.destroy.IDestroy;
	
	import flash.display.BitmapData;

	/**
	 * 动作
	 */
	public class Action implements IDestroy
	{
		// 动作的名称
		public var name:String = null;
		
		// 角色位图
		public var roleBitmapData:BitmapData = null;
		// 角色位图切片宽度
		public var roleSliceWidth:uint = 0;
		// 角色位图切片高度
		public var roleSliceHeight:uint = 0;
		// 角色立足点x像素坐标
		public var roleStandOnX:int = 0;
		// 角色立足点y像素坐标
		public var roleStandOnY:int = 0;
		
		// 所有的剪辑
		public var clips:Vector.<ActionClip> = null;
		
		// 角色动作方向在位图中行索引
		public var upDirection:uint = 0;
		public var downDirection:uint = 0;
		public var leftDirection:uint = 0;
		public var rightDirection:uint = 0;
		public var leftUpDirection:uint = 0;
		public var leftDownDirection:uint = 0;
		public var rightUpDirection:uint = 0;
		public var rightDownDirection:uint = 0;
		
		public function Action(name:String, 
			roleBmpd:BitmapData, roleSliceWidth:uint, roleSliceHeight:uint, roleStandOnX:int, roleStandOnY:int, 
			clips:Vector.<ActionClip>, 
			upDirection:uint = 3, downDirection:uint =0, leftDirection:uint = 1, rightDirection:uint = 2, 
			leftUpDirection:uint = 6, leftDownDirection:uint = 4, rightUpDirection:uint = 7, rightDownDirection:uint = 5)
		{
			this.name = name;
			
			this.roleBitmapData = roleBmpd;
			this.roleSliceWidth = roleSliceWidth;
			this.roleSliceHeight = roleSliceHeight;
			this.roleStandOnX = roleStandOnX;
			this.roleStandOnY = roleStandOnY;
			
			this.clips = clips;
			
			this.upDirection = upDirection;
			this.downDirection = downDirection;
			this.leftDirection = leftDirection;
			this.rightDirection = rightDirection;
			this.leftUpDirection = leftUpDirection;
			this.leftDownDirection = leftDownDirection;
			this.rightUpDirection = rightUpDirection;
			this.rightDownDirection = rightDownDirection;
		}
		
		//-----------------------------------------------------------------------------------------------------------------------------
		// 实现 IDestroy 接口
		//-----------------------------------------------------------------------------------------------------------------------------
		
		public function destroy():void
		{
			roleBitmapData = null;
			clips = null;
		}

	}
}