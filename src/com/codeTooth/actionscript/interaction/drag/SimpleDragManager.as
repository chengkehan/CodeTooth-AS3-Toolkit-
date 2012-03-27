package com.codeTooth.actionscript.interaction.drag
{
	/**
	 * 开始拖动
	 */
	[Event(name="simpleDragStart", type="com.codeTooth.actionscript.interaction.drag.SimpleDragManagerEvent")]
	
	/**
	 * 拖动过程中
	 */
	[Event(name="simpleDragging", type="com.codeTooth.actionscript.interaction.drag.SimpleDragManagerEvent")]

	/**
	 * 拖动结束
	 */
	[Event(name="startDragStop", type="com.codeTooth.actionscript.interaction.drag.SimpleDragManagerEvent")]
	
	import com.codeTooth.actionscript.lang.exceptions.NullPointerException;
	import com.codeTooth.actionscript.lang.utils.destroy.IDestroy;
	import flash.events.EventDispatcher;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;

	/**
	 * 简单的鼠标拖动
	 */
	public class SimpleDragManager extends EventDispatcher 
										implements IDestroy
	{
		/**
		 * 构造函书
		 * 
		 * @param	container 要拖动对象所在的容器
		 * @param	useUpdataAfterEvent 是否在鼠标拖动后立即更新
		 * 
		 * @throws	com.codeTooth.actionscript.lang.exceptions.NullPointerException 
		 * 指定的container是null
		 */
		public function SimpleDragManager(container:DisplayObjectContainer, useUpdataAfterEvent:Boolean = false)
		{
			if (container == null)
			{
				throw new NullPointerException()
			}
			
			_useUpdataAfterEvent = useUpdataAfterEvent;
			initializeContainer(container);
		}
		
		//---------------------------------------------------------------------------------------------------------------------------------------------------
		// Enabled
		//---------------------------------------------------------------------------------------------------------------------------------------------------
		
		private var _enabled:Boolean = true;
		
		/**
		 * 是否可用
		 */
		public function set enabled(bool:Boolean):void
		{
			_enabled = bool;
			
			if (!_enabled)
			{
				_listenersAdded = false;
				_container.removeEventListener(MouseEvent.MOUSE_UP, containerMouseUpHandler);
				_container.removeEventListener(MouseEvent.MOUSE_MOVE, containerMouseMoveHandler);
				_dragableObject = null;
			}
		}
		
		/**
		 * @private
		 */
		public function get enabled():Boolean
		{
			return _enabled;
		}
		
		//---------------------------------------------------------------------------------------------------------------------------------------------------
		// 拖动时定位对象坐标
		//---------------------------------------------------------------------------------------------------------------------------------------------------
		
		private var _positionDragableObject:Function = null;
		
		/**
		 * 设置拖动时定位对象的函数，如果不设置使用默认的，拖动时对象将跟随鼠标坐标。
		 * 设置自定义的后，不会跟随鼠标，而是把坐标传入函数，使用者自己进行定位。
		 * 
		 * @param	func	原型。func(x:数值类型, y:数值类型, dragableObject:任何正确的类型):void
		 */
		public function setPositionDragableObject(func:Function):void
		{
			_positionDragableObject = func;
		}
		
		public function getPositionDragableObject():Function
		{
			return _positionDragableObject;
		}
		
		//---------------------------------------------------------------------------------------------------------------------------------------------------
		// Container
		//---------------------------------------------------------------------------------------------------------------------------------------------------
		
		// 拖动对象所在的容器
		private var _container:DisplayObjectContainer = null;
		
		// 当前拖动的对象
		private var _dragableObject:Object = null;
		
		private var _useUpdataAfterEvent:Boolean = false;
		
		// 拖动时鼠标的偏移量
		private var _dragTx:Number = 0;
		
		private var _dragTy:Number = 0;
		
		private var _listenersAdded:Boolean = false;
		
		private var _draggingEvent:SimpleDragManagerEvent = null;
		
		private var _startDragEvent:SimpleDragManagerEvent = null;
		
		private var _stopDragEvent:SimpleDragManagerEvent = null;
		
		private function containerMouseDownHandler(event:MouseEvent):void
		{
			if (_enabled)
			{
				var target:Object = event.target;
				
				// 遍历显示列表，找可拖动的对象
				while(true)
				{
					if(target == null || target == _container)
					{
						target = null;
						break;
					}
					else
					{
						if(target is ISimpleDragable)
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
				
				if(target != null)
				{
					_dragTx = target.parent.mouseX - target.x;
					_dragTy = target.parent.mouseY - target.y;
					_dragableObject = target;
					
					_startDragEvent.dragableObject = _dragableObject;
					dispatchEvent(_startDragEvent);
					
					if(!_listenersAdded)
					{
						_listenersAdded = true;
						_container.addEventListener(MouseEvent.MOUSE_UP, containerMouseUpHandler);
						_container.addEventListener(MouseEvent.MOUSE_MOVE, containerMouseMoveHandler);
					}
				}
			}
		}
		
		private function containerMouseUpHandler(event:MouseEvent):void
		{
			_stopDragEvent.dragableObject = _dragableObject;
			dispatchEvent(_stopDragEvent);
			
			_listenersAdded = false;
			_container.removeEventListener(MouseEvent.MOUSE_UP, containerMouseUpHandler);
			_container.removeEventListener(MouseEvent.MOUSE_MOVE, containerMouseMoveHandler);
			_dragableObject = null;
		}
		
		private function containerMouseMoveHandler(event:MouseEvent):void
		{
			var tx:Number = _dragableObject.parent.mouseX - _dragTx;;
			var ty:Number = _dragableObject.parent.mouseY - _dragTy;;
			if (_positionDragableObject == null)
			{
				_dragableObject.x = tx;
				_dragableObject.y = ty;
			}
			else
			{
				_positionDragableObject(tx, ty, _dragableObject);
			}
			
			if(_useUpdataAfterEvent)
			{
				event.updateAfterEvent();
			}
			
			_draggingEvent.dragableObject = _dragableObject;
			dispatchEvent(_draggingEvent);
		}
		
		private function initializeContainer(container:DisplayObjectContainer):void
		{
			_container = container;
			_container.addEventListener(MouseEvent.MOUSE_DOWN, containerMouseDownHandler);
			_draggingEvent = new SimpleDragManagerEvent(SimpleDragManagerEvent.SIMPLE_DRAGGING);
			_startDragEvent = new SimpleDragManagerEvent(SimpleDragManagerEvent.SIMPLE_DRAG_START);
			_stopDragEvent = new SimpleDragManagerEvent(SimpleDragManagerEvent.SIMPLE_DRAG_STOP);
		}
		
		private function destroyContainer():void
		{
			if(_container != null)
			{
				containerMouseUpHandler(null);
				_container.removeEventListener(MouseEvent.MOUSE_DOWN, containerMouseDownHandler);
				_container.removeEventListener(MouseEvent.MOUSE_UP, containerMouseUpHandler);
				_container.removeEventListener(MouseEvent.MOUSE_MOVE, containerMouseMoveHandler);
				_container = null;
				
				_draggingEvent.dragableObject = null;
				_draggingEvent = null;
				_startDragEvent.dragableObject = null;
				_startDragEvent = null;
				_stopDragEvent.dragableObject = null;
				_stopDragEvent = null;
			}
		}
		
		//---------------------------------------------------------------------------------------------------------------------------------------------------
		// 实现 IDestroy 接口
		//---------------------------------------------------------------------------------------------------------------------------------------------------
		
		/**
		 * @inheritDoc
		 */
		public function destroy():void
		{
			destroyContainer();
		}
	}
}