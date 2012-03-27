package com.codeTooth.actionscript.display 
{
	import com.codeTooth.actionscript.core.codeTooth_internal;
	import com.codeTooth.actionscript.lang.errors.AbstractError;
	import com.codeTooth.actionscript.lang.exceptions.UnsupportedException;
	import com.codeTooth.actionscript.lang.utils.destroy.IDestroy;
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class UISprite extends Sprite 
									implements IDestroy
	{
		use namespace codeTooth_internal;
		
		public function UISprite() 
		{
			initalizeListeners();
		}
		
		//----------------------------------------------------------------------------------------------------------------
		// 重写坐标
		//----------------------------------------------------------------------------------------------------------------
		
		override public final function set x(value:Number):void
		{
			super.x = int(value);
			setXInternal(int(value));
		}
		
		override public final function set y(value:Number):void
		{
			super.y = int(value);
			setYInternal(int(value));
		}
		
		protected function setXInternal(value:Number):void
		{
			// Do something in sub class
		}
		
		protected function setYInternal(value:Number):void
		{
			// Do something in sub class
		}
		
		//----------------------------------------------------------------------------------------------------------------
		// 重写鼠标可用方法
		//----------------------------------------------------------------------------------------------------------------
		
		override public final function set mouseEnabled(bool:Boolean):void
		{
			// 不再支持这个方法
			throw new UnsupportedException();
		}
		
		override public final function get mouseEnabled():Boolean
		{
			return super.mouseEnabled;
		}
		
		override public final function get mouseChildren():Boolean
		{
			return super.mouseChildren;
		}
		
		override public final function set mouseChildren(bool:Boolean):void
		{
			// 不再支持这个方法
			throw new UnsupportedException();
		}
		
		codeTooth_internal function set mouseEnabled_internal(bool:Boolean):void
		{
			super.mouseEnabled = bool;
		}
		
		codeTooth_internal function set mouseChildren_internal(bool:Boolean):void
		{
			super.mouseChildren = bool;
		}
		
		protected function setSuperMouseEnabled(bool:Boolean):void
		{
			super.mouseEnabled = bool;
		}
		
		protected function setSuperMouseChildren(bool:Boolean):void
		{
			super.mouseChildren = bool;
		}
		
		//----------------------------------------------------------------------------------------------------------------
		// Listeners
		//----------------------------------------------------------------------------------------------------------------
		
		protected function addToStageExecute():void
		{
			// 抽象方法，子类必须覆盖
			throw new AbstractError();
		}
		
		protected function removeFromStageExecute():void
		{
			// 抽象方法，子类必须覆盖
			throw new AbstractError();
		}
		
		private function addToStageHandler(event:Event):void 
		{
			addEventListener(Event.REMOVED_FROM_STAGE, removeFromStageHandler);
			addToStageExecute();
		}
		
		private function removeFromStageHandler(event:Event):void 
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, removeFromStageHandler);
			removeFromStageExecute();
		}
		
		private function initalizeListeners():void
		{
			addEventListener(Event.ADDED_TO_STAGE, addToStageHandler);
		}
		
		private function destroyListeners():void
		{
			removeEventListener(Event.ADDED_TO_STAGE, addToStageHandler);
			removeEventListener(Event.REMOVED_FROM_STAGE, removeFromStageHandler);
		}
		
		//----------------------------------------------------------------------------------------------------------------
		// 重写宽高
		//----------------------------------------------------------------------------------------------------------------
		
		protected var _width:Number = 0;
		
		protected var _height:Number = 0;
		
		protected var _minWidth:Number = 0;
		
		protected var _minHeight:Number = 0;
		
		public final function get minWidth():Number
		{
			return _minWidth;
		}
		
		public final function get minHeight():Number
		{
			return _minHeight;
		}
		
		override public final function set width(value:Number):void
		{
			if (value < _minWidth)
			{
				value = _minWidth;
			}
			_width = int(value);
			setWidthInternal(_width);
		}
		
		override public final function set height(value:Number):void
		{
			if (value < _minHeight)
			{
				value = _minHeight;
			}
			_height = int(value);
			setHeightInternal(_height);
		}
		
		protected function setWidthInternal(value:Number):void
		{
			// 抽象方法，子类必须覆盖
			throw new AbstractError();
		}
		
		protected function setHeightInternal(value:Number):void
		{
			// 抽象方法，子类必须覆盖
			throw new AbstractError();
		}
		
		//----------------------------------------------------------------------------------------------------------------
		// 重写缩放
		//----------------------------------------------------------------------------------------------------------------
		
		override public final function set scaleX(value:Number):void
		{
			// Do nothing
		}
		
		override public final function set scaleY(value:Number):void
		{
			// Do nothing
		}
		
		//----------------------------------------------------------------------------------------------------------------
		// 实现 IDestroy 接口
		//----------------------------------------------------------------------------------------------------------------
		
		public final function destroy():void
		{
			destroyListeners();
			destroyInternal();
		}
		
		protected function destroyInternal():void
		{
			// 抽象方法，子类必须覆盖
			throw new AbstractError();
		}
	}

}