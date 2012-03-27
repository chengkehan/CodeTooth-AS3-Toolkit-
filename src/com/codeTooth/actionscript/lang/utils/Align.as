package com.codeTooth.actionscript.lang.utils
{
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.display.DisplayObject;
	
	/**
	 * 对齐。
	 * 注意该类中返回对象的方法，为了提高效率，同一类型的返回值其实都是同一个对象，所以如果要持有返回的对象，请调用返回值的clone方法
	 */
	public class Align  
	{
		private static var _rect:Rectangle = new Rectangle();
		
		private static var _matrix:Matrix = new Matrix();
		
		/**
		 * 该函数和rectScaleCenterAlign功能完全相同，只是返回值是一个矩阵
		 * 
		 * @param	srcRect
		 * @param	dstRect
		 * 
		 * @return
		 */
		public static function rectScaleCenterAlignByMatrix(srcRect:Rectangle, dstRect:Rectangle):Matrix
		{
			var newRect:Rectangle = rectScaleCenterAlign(srcRect, dstRect);
			if (newRect == null)
			{
				return null;
			}
			else
			{
				_matrix.a = newRect.width / srcRect.width;
				_matrix.b = 0;
				_matrix.c = 0;
				_matrix.d = newRect.height / srcRect.height;
				_matrix.tx = newRect.x;
				_matrix.ty = newRect.y;
				
				return _matrix;
			}
		}
		
		/**
		 * 源矩形相对于目标矩形进行缩放对齐
		 * 
		 * @param	srcRect
		 * @param	dstRect
		 * 
		 * @return 返回缩放对齐后的矩形范围。如果入参是null，则返回null。
		 */
		public static function rectScaleCenterAlign(srcRect:Rectangle, dstRect:Rectangle):Rectangle 
		{
			if (srcRect == null || dstRect == null)
			{
				return null;
			}
			else
			{
				var p:Number;
				var originP:Number = srcRect.width / srcRect.height;
				var targetP:Number = dstRect.width / dstRect.height;
				if (originP >= targetP) 
				{
					p = dstRect.width / srcRect.width;
					_rect.width = srcRect.width * p;
					_rect.height = srcRect.height * p;
				}
				else 
				{
					p =  dstRect.height / srcRect.height;
					_rect.width = srcRect.width * p;
					_rect.height = srcRect.height * p;
				}
				
				_rect.x = dstRect.x + (dstRect.width - _rect.width) * .5;
				_rect.y = dstRect.y + (dstRect.height - _rect.height) * .5;
				
				return _rect;
			}
		}
		
		/**
		 * 源矩形相对于目标矩形进行对齐
		 * 
		 * @param	srcRect
		 * @param	dstRect
		 * 
		 * @return 返回对齐后的矩形范围。如果入参是null，则返回null。
		 */
		public static function rectCenterAlign(srcRect:Rectangle, dstRect:Rectangle):Rectangle
		{
			if (srcRect == null || dstRect == null)
			{
				return null;
			}
			else
			{
				_rect.width = srcRect.width;
				_rect.height = srcRect.height;
				_rect.x = dstRect.x + (dstRect.width - _rect.width) * .5;
				_rect.y = dstRect.y + (dstRect.height - _rect.height) * .5;
				
				return _rect;
			}
		}
		
		/**
		 * 获得对象的矩形范围。
		 * 
		 * @param	object
		 * 
		 * @return 如果入参是null，则返回null。
		 */
		public static function getRectangle(object:DisplayObject):Rectangle
		{
			return object == null ? null : new Rectangle(object.x, object.y, object.width, object.height);
		}
	}
	
}