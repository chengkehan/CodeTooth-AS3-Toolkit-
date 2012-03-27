package com.codeTooth.actionscript.display
{
	import com.codeTooth.actionscript.lang.utils.destroy.IDestroy;
	import flash.display.Sprite;
	
	/**
	 * 带有方框背景的Sprite
	 */
	public class BoxBackgroundSprite extends Sprite 
										implements IDestroy
	{
		public function BoxBackgroundSprite()
		{
			initializeBg();
		}
		
		//---------------------------------------------------------------------------------------------------------------------------------------------------
		// 重写宽高
		//---------------------------------------------------------------------------------------------------------------------------------------------------
		
		/**
		 * @inheritDoc
		 */
		override public function set width(value:Number):void
		{
			_bg.width = value;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function set height(value:Number):void
		{
			_bg.height = value;
		}
		
		//---------------------------------------------------------------------------------------------------------------------------------------------------
		// Background
		//---------------------------------------------------------------------------------------------------------------------------------------------------
		
		protected var _bg:Box = null;
		
		private function initializeBg():void
		{
			_bg = new Box();
			addChild(_bg);
		}
		
		//---------------------------------------------------------------------------------------------------------------------------------------------------
		// 实现 IDestroy 接口
		//---------------------------------------------------------------------------------------------------------------------------------------------------
		
		public function destroy():void
		{
			if (_bg != null)
			{
				removeChild(_bg);
				_bg = null;
			}
		}
	}
}