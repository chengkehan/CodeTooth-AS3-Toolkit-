package com.codeTooth.actionscript.interaction.drag 
{
	import com.codeTooth.actionscript.lang.exceptions.NullPointerException;
	import com.codeTooth.actionscript.lang.utils.destroy.IDestroy;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	
	/**
	 * 拖动管理
	 */
	public class DragManager extends EventDispatcher 
								implements IDestroy 
	{
		/**
		 * 构造函数
		 * 
		 * @param	container 容器
		 * @param	dragContainer 拖动图标显示的容器
		 * @param	useUpdateAfterEvent 是否强制刷新
		 * 
		 * @throws	com.codeTooth.actionscript.lang.exceptions.NullPointerException 
		 * 入参container或者dragContainer是null
		 */
		public function DragManager(container:DisplayObjectContainer, dragContainer:Sprite, useUpdateAfterEvent:Boolean = false) 
		{
			if (container == null || dragContainer == null)
			{
				throw new NullPointerException();
			}
			
			_useUpdataAfterEvent = useUpdateAfterEvent;
			initializeContainer(container, dragContainer);
		}
		
		//--------------------------------------------------------------------------------------------------------------------
		// 拖动操作
		//--------------------------------------------------------------------------------------------------------------------
		
		private var _useUpdataAfterEvent:Boolean = false;
		
		private var _dragInitiator:IDragInitiator = null;
		
		private var _dragData:DragData = null;
		
		private var _dropTarget:IDropTarget = null;
		
		private var _addedListeners:Boolean = false;
		
		private var _canDropUnderMouseEvent:DragManagerEvent = null;
		
		private var _cannotDropUnderMouseEvent:DragManagerEvent = null;
		
		private	function dispatchCanDropUnderMouseEvent():void
		{
			if (_canDropUnderMouseEvent == null)
			{
				_canDropUnderMouseEvent = new DragManagerEvent(DragManagerEvent.CAN_DROP_UNDER_MOUSE);
			}
			_canDropUnderMouseEvent.dragData = _dragData;
			dispatchEvent(_canDropUnderMouseEvent);
		}
		
		private function dispatchCannotDropUnderMouseEvent():void
		{
			if (_cannotDropUnderMouseEvent == null)
			{
				_cannotDropUnderMouseEvent = new DragManagerEvent(DragManagerEvent.CANNOT_DROP_UNDER_MOUSE);
			}
			_cannotDropUnderMouseEvent.dragData = _dragData;
			dispatchEvent(_cannotDropUnderMouseEvent);
		}
		
		private function continueInterruptedDrop():void
		{
			_dragInitiator.dropResponse(_dropTarget.setDragData(_dragData));
			clearDragData();
		}
		
		private function preventDrop():void
		{
			clearDragData();
		}
		
		private function clearDragData():void
		{
			_dragInitiator = null;
			_dropTarget = null;
			
			if (_dragData != null && _dragData.snapshot != null && _dragContainer.contains(_dragData.snapshot))
			{
				_dragContainer.removeChild(_dragData.snapshot);
			}
			_dragData = null;
		}
		
		private function getObjectUnderMouse(target:Object, definition:Class):Object
		{
			while(true)
			{
				if(target == null || target == _container)
				{
					target = null;
					break;
				}
				else
				{
					if(target is definition)
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
			
			return target;
		}
		
		private function containerMouseDownHandler(event:MouseEvent):void 
		{
			var target:Object = getObjectUnderMouse(event.target, IDragInitiator);
			if(target != null)
			{
				var initiator:IDragInitiator = IDragInitiator(target);
				if (initiator.dragEnabled)
				{
					_dragInitiator = initiator;
					_dragData = _dragInitiator.getDragData();
					_dragData.from = _dragInitiator.dragBelongTo;
					
					if (!_addedListeners)
					{
						_addedListeners = true;
						_container.addEventListener(MouseEvent.MOUSE_DOWN, containerMouseDownHandler);
						_container.addEventListener(MouseEvent.MOUSE_MOVE, containerMouseMoveHandler);
					}
				}
			}
		}
		
		private function containerMouseUpHandler(event:MouseEvent):void 
		{
			if (_dropTarget != null)
			{
				var newEvent:DragManagerEvent;
				_dragData.to = _dropTarget.dropBelongTo;
				
				if (_dropTarget.interruptDrop(_dragData))
				{
					newEvent = new DragManagerEvent(DragManagerEvent.DROP_INTERRUPTTED);
					newEvent.continueInterruptedDropFunc = continueInterruptedDrop;
					newEvent.preventDropFunc = preventDrop;
					newEvent.dragData = _dragData;
					dispatchEvent(newEvent);
				}
				else
				{
					continueInterruptedDrop();
				}
			}
			else
			{
				newEvent = new DragManagerEvent(DragManagerEvent.DROP_NOT_ON_TARGET);
				newEvent.dragData = _dragData;
				dispatchEvent(newEvent);
				
				clearDragData();
			}
			
			_addedListeners = false;
			_container.removeEventListener(MouseEvent.MOUSE_DOWN, containerMouseDownHandler);
			_container.removeEventListener(MouseEvent.MOUSE_MOVE, containerMouseMoveHandler);
		}
		
		private function containerMouseMoveHandler(event:MouseEvent):void 
		{
			var target:Object = getObjectUnderMouse(event.target, IDropTarget);
			if (target != null)
			{
				var dropTarget:IDropTarget = IDropTarget(target);
				if (target.dropEnabled(dropTarget))
				{
					_dropTarget = dropTarget;
					if (_dragData != null)
					{
						_dragData.to = _dropTarget.dropBelongTo;
						if (_dragData.snapshot != null)
						{
							_dragContainer.addChild(_dragData.snapshot);
							_dragData.snapshot.x = _dragContainer.mouseX - _dragData.offsetX;
							_dragData.snapshot.y = _dragContainer.mouseY - _dragData.offsetY;
							
							if (_useUpdataAfterEvent)
							{
								event.updateAfterEvent();
							}
						}
					}
					
					dispatchCanDropUnderMouseEvent();
				}
				else
				{
					dispatchCannotDropUnderMouseEvent();
					_dropTarget = null;
				}
			}
			else
			{
				dispatchCannotDropUnderMouseEvent();
				_dropTarget = null;
			}
		}
		
		//--------------------------------------------------------------------------------------------------------------------
		// 容器
		//--------------------------------------------------------------------------------------------------------------------
		
		private var _container:DisplayObjectContainer = null;
		
		private var _dragContainer:Sprite = null;
		
		private function initializeContainer(container:DisplayObjectContainer, dragContainer:Sprite):void
		{
			_container = container;
			_dragContainer = null;
			_container.addEventListener(MouseEvent.MOUSE_DOWN, containerMouseDownHandler);
		}
		
		private function destroyContainer():void
		{
			if (_container != null)
			{
				_container.removeEventListener(MouseEvent.MOUSE_DOWN, containerMouseDownHandler);
				_container.removeEventListener(MouseEvent.MOUSE_MOVE, containerMouseMoveHandler);
				_container.removeEventListener(MouseEvent.MOUSE_UP, containerMouseUpHandler);
				_container = null;
			}
			
			if (_dragContainer != null)
			{
				if (_dragData != null && _dragData.snapshot != null && _dragContainer.contains(_dragData.snapshot))
				{
					_dragContainer.removeChild(_dragData.snapshot);
					_dragContainer = null;
				}
			}
			
			clearDragData();
			_canDropUnderMouseEvent = null;
			_cannotDropUnderMouseEvent = null;
		}
		
		//--------------------------------------------------------------------------------------------------------------------
		// 实现 IDestroy 接口
		//--------------------------------------------------------------------------------------------------------------------
		
		public function destroy():void
		{
			destroyContainer();
		}
		
	}

}