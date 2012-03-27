package com.codeTooth.actionscript.game.role
{
	import com.codeTooth.actionscript.lang.utils.destroy.IDestroy;
	
	import flash.display.BitmapData;

	/**
	 * 角色动作剪辑帧
	 */
	public class RoleActionClipFrame implements IDestroy
	{
		// 帧显示的位图
		private var _bmpd:BitmapData = null;
		
		// 角色立足点x像素坐标
		private var _standOnX:int = 0;
		
		// 角色立足点y像素坐标
		private var _standOnY:int = 0;
		
		public function RoleActionClipFrame(bmpd:BitmapData, standOnX:int, standOnY:int)
		{
			_bmpd = bmpd;
			_standOnX = standOnX;
			_standOnY = standOnY;
		}
		
		public function getBitmapData():BitmapData
		{
			return _bmpd;
		}
		
		public function get standOnX():int
		{
			return _standOnX;
		}
		
		public function get standOnY():int
		{
			return _standOnY;
		}
		
		//-----------------------------------------------------------------------------------------------------------------------------------
		// 实现 IDestoy 接口
		//-----------------------------------------------------------------------------------------------------------------------------------
		
		public function destroy():void
		{
			_bmpd = null;
		}
	}
}