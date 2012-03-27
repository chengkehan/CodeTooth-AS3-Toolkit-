package com.codeTooth.actionscript.layout
{
	import flash.display.DisplayObjectContainer;
	import flash.display.Graphics;

	public class LayoutContainer
	{
		public function LayoutContainer(container:DisplayObjectContainer)
		{
			_container = container;
		}
		
		//---------------------------------------------------------------------------------------------------------------------------------------------------
		// DrawBounds
		//---------------------------------------------------------------------------------------------------------------------------------------------------
		
		public function clearDrawBounds():Boolean
		{
			if(_layout == null)
			{
				return false;
			}
			else
			{
				return _layout.clearDrawBounds();
			}
		}
		
		// DrawBounds
		private var _drawBounds:Boolean = false;
		
		public function set drawBounds(bool:Boolean):void
		{
			_drawBounds = bool;
		}
		
		public function get drawBounds():Boolean
		{
			return _drawBounds;
		}
		
		//BoundsColor
		private var _boundsColor:uint = 0x666666;
		
		public function set boundsColor(color:uint):void
		{
			_boundsColor = color;
		}
		
		public function get boundsColor():uint
		{
			return _boundsColor;
		}
		
		// DrawBoundsGraphics
		private var _drawBoundsGraphics:Graphics = null;
		
		public function setDrawBoundsGraphics(graphics:Graphics):Graphics
		{
			_drawBoundsGraphics = graphics;
			return _drawBoundsGraphics;
		}
		
		public function getDrawBoundsGraphics():Graphics
		{
			return _drawBoundsGraphics;
		}
		
		//---------------------------------------------------------------------------------------------------------------------------------------------------
		// Width
		// Height
		//---------------------------------------------------------------------------------------------------------------------------------------------------
		
		public function get width():Number
		{
			return _container == null ? 0 : _container.width;
		}
		
		public function get height():Number
		{
			return _container == null ? 0 : _container.height;
		}
		
		//---------------------------------------------------------------------------------------------------------------------------------------------------
		// Layout
		//---------------------------------------------------------------------------------------------------------------------------------------------------
		
		protected var _layout:LayoutBase = null;
		
		public function setLayout(layout:LayoutBase):LayoutBase
		{
			_layout = layout;
			return _layout;
		}
		
		public function getLayout():LayoutBase
		{
			return _layout;
		}
		
		public function layout():Boolean
		{
			return _layout == null ? false : _layout.layout(this);
		}
		
		//---------------------------------------------------------------------------------------------------------------------------------------------------
		// 容器
		//---------------------------------------------------------------------------------------------------------------------------------------------------
		
		private var _container:DisplayObjectContainer = null;
		
		public function setContainer(container:DisplayObjectContainer):DisplayObjectContainer
		{
			_container = container;
			return container;
		}
		
		public function getContainer():DisplayObjectContainer
		{
			return _container;
		}
		
		//---------------------------------------------------------------------------------------------------------------------------------------------------
		// 元素
		//---------------------------------------------------------------------------------------------------------------------------------------------------
		
		public function getElements():Array
		{
			if(_container == null)
			{
				return null;
			}
			else
			{
				var elements:Array = new Array();
				var numberChildren:int = _container.numChildren;
				
				for(var i:int = 0; i < numberChildren; i++)
				{
					elements.push(_container.getChildAt(i));
				}
				
				return elements;
			}
		}
		
		//---------------------------------------------------------------------------------------------------------------------------------------------------
		// Margin
		//---------------------------------------------------------------------------------------------------------------------------------------------------
		
		// LeftMargin
		private var _leftMargin:Number = 0;

		public function get leftMargin():Number
		{
			return _leftMargin;
		}

		public function set leftMargin(value:Number):void
		{
			_leftMargin = value;
		}

		// RightMargin
		private var _rightMargin:Number = 0;

		public function get rightMargin():Number
		{
			return _rightMargin;
		}

		public function set rightMargin(value:Number):void
		{
			_rightMargin = value;
		}

		// TopMargin
		private var _topMargin:Number = 0;

		public function get topMargin():Number
		{
			return _topMargin;
		}

		public function set topMargin(value:Number):void
		{
			_topMargin = value;
		}

		// BottomMargin
		private var _bottomMargin:Number = 0;

		public function get bottomMargin():Number
		{
			return _bottomMargin;
		}

		public function set bottomMargin(value:Number):void
		{
			_bottomMargin = value;
		}
		
		//---------------------------------------------------------------------------------------------------------------------------------------------------
		// ElementMargin
		//---------------------------------------------------------------------------------------------------------------------------------------------------
		
		// ElementLeftMargin
		private var _elementLeftMargin:Number = 0;

		public function get elementLeftMargin():Number
		{
			return _elementLeftMargin;
		}

		public function set elementLeftMargin(value:Number):void
		{
			_elementLeftMargin = value;
		}

		// ElementRightMargin
		private var _elementRightMargin:Number = 0;

		public function get elementRightMargin():Number
		{
			return _elementRightMargin;
		}

		public function set elementRightMargin(value:Number):void
		{
			_elementRightMargin = value;
		}

		// ElementTopMargin
		private var _elementTopMargin:Number = 0;

		public function get elementTopMargin():Number
		{
			return _elementTopMargin;
		}

		public function set elementTopMargin(value:Number):void
		{
			_elementTopMargin = value;
		}

		// ElementBottomMargin
		private var _elementBottomMargin:Number = 0;

		public function get elementBottomMargin():Number
		{
			return _elementBottomMargin;
		}

		public function set elementBottomMargin(value:Number):void
		{
			_elementBottomMargin = value;
		}
		
		//---------------------------------------------------------------------------------------------------------------------------------------------------
		// Gap
		//--------------------------------------------------------------------------------------------------------------------------------------------------
		
		// VGap
		private var _vGap:Number = 0;

		public function get vGap():Number
		{
			return _vGap;
		}

		public function set vGap(value:Number):void
		{
			_vGap = value;
		}

		// HGap
		private var _hGap:Number = 0;

		public function get hGap():Number
		{
			return _hGap;
		}

		public function set hGap(value:Number):void
		{
			_hGap = value;
		}
		
		//---------------------------------------------------------------------------------------------------------------------------------------------------
		// LayoutType
		//--------------------------------------------------------------------------------------------------------------------------------------------------
		
		private var _layoutType:int = LayoutType.LEFT;
		
		public function setLayoutType(type:int):Boolean
		{
			if(type &  LayoutType.BOTTOM || type & LayoutType.CENTER || 
				type & LayoutType.LEFT || type & LayoutType.RIGHT || 
				type & LayoutType.TOP)
			{
				_layoutType = type;
				return true;
			}
			else
			{
				return false;
			}
		}
		
		public function getLayoutType():int
		{
			return _layoutType;
		}
		
		//---------------------------------------------------------------------------------------------------------------------------------------------------
		// ElementLayoutType
		//--------------------------------------------------------------------------------------------------------------------------------------------------
		
		private var _elementLayoutType:int = LayoutType.LEFT;
		
		public function setElementLayoutType(type:int):Boolean
		{
			if(type &  LayoutType.BOTTOM || type & LayoutType.CENTER || 
				type & LayoutType.LEFT || type & LayoutType.RIGHT || 
				type & LayoutType.TOP)
			{
				_elementLayoutType = type;
				return true;
			}
			else
			{
				return false;
			}
		}
		
		public function getElementLayoutType():int
		{
			return _elementLayoutType;
		}
		
		//---------------------------------------------------------------------------------------------------------------------------------------------------
		// elementBounds
		//--------------------------------------------------------------------------------------------------------------------------------------------------
		
		private var _elementBounds:IElementBounds = null;
		
		public function setElementBounds(elementBounds:IElementBounds):IElementBounds
		{
			_elementBounds = elementBounds;
			
			return _elementBounds;
		}
		
		public function getElementBounds():IElementBounds
		{
			return _elementBounds;
		}
	}
}