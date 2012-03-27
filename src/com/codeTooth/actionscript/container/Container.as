package com.codeTooth.actionscript.container
{
	import com.codeTooth.actionscript.lang.utils.destroy.IDestroy;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	
	/**
	 * 容器。有可视范围的容器，里面的对象如果出了这个范围就不可见了
	 */
	public class Container extends Sprite 
								implements IDestroy
	{
		public function Container()
		{
			initializeContainer();
			initializeWidthHeight();
		}
		
		//---------------------------------------------------------------------------------------------------------------------------------------------------
		// Bounds
		//---------------------------------------------------------------------------------------------------------------------------------------------------
		
		private var _drawBounds:Boolean = false;
		
		private var _boundsColor:uint = 0x444444;
		
		/**
		 * 画边框
		 */
		public function set drawBounds(bool:Boolean):void
		{
			_drawBounds = bool;
			drawBondsInteranl();
		}
		
		/**
		 * @private
		 */
		public function get drawBounds():Boolean
		{
			return _drawBounds;
		}
		
		/**
		 * 边框颜色
		 */
		public function set boundsColor(color:uint):void
		{
			_boundsColor = color;
			drawBondsInteranl();
		}
		
		/**
		 * @private
		 */
		public function get boundsColor():uint
		{
			return _boundsColor;
		}
		
		private function drawBondsInteranl():void
		{
			graphics.clear();
			
			if(_drawBounds)
			{
				graphics.lineStyle(1, _boundsColor);
				graphics.drawRect(0, 0, width, height);
			}
		}
		
		//---------------------------------------------------------------------------------------------------------------------------------------------------
		// 重写宽高
		//---------------------------------------------------------------------------------------------------------------------------------------------------
		
		protected var _scrollRect:Rectangle = null;
		
		/**
		 * @inheritDoc
		 */
		override public function set width(value:Number):void
		{
			if(value < 0)
			{
				value = 0;
			}
			
			_scrollRect.width = value;
			_container.scrollRect = _scrollRect;
			drawBondsInteranl();
		}
		
		/**
		 * @inheritDoc
		 */
		override public function get width():Number
		{
			return _scrollRect.width;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function set height(value:Number):void
		{
			if(value < 0)
			{
				value = 0;
			}
			
			_scrollRect.height = value;
			_container.scrollRect = _scrollRect;
			drawBondsInteranl();
		}
		
		/**
		 * @inheritDoc
		 */
		override public function get height():Number
		{
			return _scrollRect.height;
		}
		
		private function initializeWidthHeight():void
		{
			_scrollRect = new Rectangle(0, 0, 300, 300);
			_container.scrollRect = _scrollRect;
		}
		
		private function destroyWidthHeight():void
		{
			_scrollRect = null;
		}
		
		//---------------------------------------------------------------------------------------------------------------------------------------------------
		// Container
		//---------------------------------------------------------------------------------------------------------------------------------------------------
		
		private var _container:Sprite = null;
		
		/**
		 * @inheritDoc
		 */
		override public function addChild(child:DisplayObject):DisplayObject
		{
			return _container.addChild(child);
		}
		
		protected function superAddChild(child:DisplayObject):DisplayObject
		{
			return super.addChild(child);
		}
		
		/**
		 * @inheritDoc
		 */
		override public function addChildAt(child:DisplayObject, index:int):DisplayObject
		{
			return _container.addChildAt(child, index);
		}
		
		protected function superAddChildAt(child:DisplayObject, index:int):DisplayObject
		{
			return super.addChildAt(child, index);
		}
		
		/**
		 * @inheritDoc
		 */
		override public function contains(child:DisplayObject):Boolean
		{
			return _container.contains(child);
		}
		
		protected function superContains(child:DisplayObject):Boolean
		{
			return super.contains(child);
		}
		
		/**
		 * @inheritDoc
		 */
		override public function getChildAt(index:int):DisplayObject
		{
			return _container.getChildAt(index);
		}
		
		protected function superGetChildAt(index:int):DisplayObject
		{
			return super.getChildAt(index);
		}
		
		/**
		 * @inheritDoc
		 */
		override public function getChildByName(name:String):DisplayObject
		{
			return _container.getChildByName(name);
		}
		
		protected function superGetChildByName(name:String):DisplayObject
		{
			return super.getChildByName(name);
		}
		
		/**
		 * @inheritDoc
		 */
		override public function getChildIndex(child:DisplayObject):int
		{
			return _container.getChildIndex(child);
		}
		
		protected function superGetChildIndex(child:DisplayObject):int
		{
			return super.getChildIndex(child);
		}
		
		/**
		 * @inheritDoc
		 */
		override public function removeChild(child:DisplayObject):DisplayObject
		{
			return _container.removeChild(child);
		}
		
		protected function superRemoveChild(child:DisplayObject):DisplayObject
		{
			return super.removeChild(child);
		}
		
		/**
		 * @inheritDoc
		 */
		override public function removeChildAt(index:int):DisplayObject
		{
			return _container.removeChildAt(index);
		}
		
		protected function superRemoveChildAt(index:int):DisplayObject
		{
			return super.removeChildAt(index);
		}
		
		/**
		 * @inheritDoc
		 */
		override public function setChildIndex(child:DisplayObject, index:int):void
		{
			_container.setChildIndex(child, index);
		}
		
		protected function superSetChildIndex(child:DisplayObject, index:int):void
		{
			super.setChildIndex(child, index);
		}
		
		/**
		 * @inheritDoc
		 */
		override public function swapChildren(child1:DisplayObject, child2:DisplayObject):void
		{
			_container.swapChildren(child1, child2);
		}
		
		protected function superSwapChildren(child1:DisplayObject, child2:DisplayObject):void
		{
			super.swapChildren(child1, child2);
		}
		
		/**
		 * @inheritDoc
		 */
		override public function swapChildrenAt(index1:int, index2:int):void
		{
			_container.swapChildrenAt(index1, index2);
		}
		
		protected function superSwapChildrenAt(index1:int, index2:int):void
		{
			super.swapChildrenAt(index1, index2);
		}
		
		/**
		 * @inheritDoc
		 */
		private function initializeContainer():void
		{
			_container = new Sprite();
			superAddChild(_container);
		}
		
		override public function get numChildren():int
		{
			return _container.numChildren;
		}
		
		protected function superNumChildren():int
		{
			return super.numChildren;
		}
		
		//---------------------------------------------------------------------------------------------------------------------------------------------------
		// 实现 IDestroy 接口
		//---------------------------------------------------------------------------------------------------------------------------------------------------
		
		/**
		 * @inheritDoc
		 */
		public function destroy():void
		{
			if(_container != null)
			{
				var numberChildren:int = _container.numChildren;
				while(--numberChildren > 0)
				{
					_container.removeChildAt(0);
				}
				
				superRemoveChild(_container);
				_container = null;
			}
		}
	}
}