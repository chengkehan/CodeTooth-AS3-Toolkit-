package com.codeTooth.actionscript.interaction.drag 
{
	import com.codeTooth.actionscript.lang.utils.destroy.IDestroy;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	/**
	 * 窗口拖动
	 */
	public class WindowDrag implements IDestroy
	{
		/**
		 * 构造函数
		 * 
		 * @param	container 容器
		 * @param	useUpdataAfterEvent 是否强制更新
		 */
		public function WindowDrag(container:DisplayObjectContainer, useUpdataAfterEvent:Boolean = false) 
		{
			_useUpdataAfterEvent = useUpdataAfterEvent;
			initializeContainer(container);
		}
		
		//--------------------------------------------------------------------------------------------------------------
		// 鼠标操作
		//--------------------------------------------------------------------------------------------------------------
		
		private var _useUpdataAfterEvent:Boolean = false;
		
		private var _listenersAdded:Boolean = false;
		
		private var _windowDragTarget:IWindowDragTarget = null;
		
		private var _dragTarget:DisplayObject = null;
		
		private var _dragDx:Number = 0;
		
		private var _dragDy:Number = 0;
		
		private function containerMouseDownHandler(event:MouseEvent):void
		{
			var target:Object = event.target;
			while(true)
			{
				if(target == null || target == _container)
				{
					target = null;
					break;
				}
				else
				{
					if(target is IWindowDragTarget)
					{
						break;
					}
					else
					{
						if(target.parent == null)
						{
							target = null;
							break;
						}
						else
						{
							target = target.parent;
						}
					}
				}
			}
			
			
			if (target != null)
			{
				var hitAreas:Vector.<DisplayObject> = target.hitAreas;
				
				if (target.parent != null)
				{
					target.parent.addChild(DisplayObject(target));
				}
				
				if (target.dragable && hitAreas != null)
				{
					var inHitAreas:Boolean = false;
					var dragT:DisplayObject = target.bindingTarget == null ? DisplayObject(target) : target.bindingTarget;
					var bounds:Rectangle;
					for each(var area:DisplayObject in hitAreas)
					{
						bounds = area.getBounds(dragT.parent);
						if (bounds.contains(dragT.parent.mouseX, dragT.parent.mouseY))
						{
							inHitAreas = true;
							break;
						}
					}
					
					if (inHitAreas)
					{
						_windowDragTarget = IWindowDragTarget(target);
						_dragTarget = dragT;
						_dragDx = _dragTarget.parent.mouseX - _dragTarget.x;
						_dragDy = _dragTarget.parent.mouseY - _dragTarget.y;
						
						if (!_listenersAdded)
						{
							_listenersAdded = true;
							_container.addEventListener(MouseEvent.MOUSE_UP, containerMouseUpHandler);
							_container.addEventListener(MouseEvent.MOUSE_MOVE, containerMouseMoveHandler);
						}
					}
				}
			}
		}
		
		private function containerMouseUpHandler(event:MouseEvent):void
		{
			_listenersAdded = false;
			_container.removeEventListener(MouseEvent.MOUSE_UP, containerMouseUpHandler);
			_container.removeEventListener(MouseEvent.MOUSE_MOVE, containerMouseMoveHandler);
			
			_dragTarget = null;
			_windowDragTarget = null;
		}
		
		private function containerMouseMoveHandler(event:MouseEvent):void
		{
			_dragTarget.x = _dragTarget.parent.mouseX - _dragDx;
			_dragTarget.y = _dragTarget.parent.mouseY - _dragDy;
			
			if(_useUpdataAfterEvent)
			{
				event.updateAfterEvent();
			}
		}
		
		//--------------------------------------------------------------------------------------------------------------
		// 容器
		//--------------------------------------------------------------------------------------------------------------
		
		private var _container:DisplayObjectContainer = null;
		
		private function initializeContainer(container:DisplayObjectContainer):void
		{
			if (container != null)
			{
				_container = container;
				_container.addEventListener(MouseEvent.MOUSE_DOWN, containerMouseDownHandler);
			}
		}
		
		private function destroyContainer():void
		{
			if (_container != null)
			{
				_container.removeEventListener(MouseEvent.MOUSE_DOWN, containerMouseDownHandler);
				_container.removeEventListener(MouseEvent.MOUSE_UP, containerMouseUpHandler);
				_container.removeEventListener(MouseEvent.MOUSE_MOVE, containerMouseMoveHandler);
				_container = null;
			}
		}
		
		//--------------------------------------------------------------------------------------------------------------
		// 实现 IDestroy 接口
		//--------------------------------------------------------------------------------------------------------------
		
		/**
		 * @inheritDoc
		 */
		public function destroy():void
		{
			destroyContainer();
			_windowDragTarget = null;
			_dragTarget = null;
		}
	}

}