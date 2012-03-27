package com.codeTooth.actionscript.lang.utils.geom 
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 * 三角算法。
	 * 注意该类中返回对象的方法，为了提高效率，同一类型的返回值其实都是同一个对象，所以如果要持有返回的对象，请调用返回值的clone方法
	 */
	public class Mathematic 
	{
		// 静态变量持有对象，避免重复创建对象导致的开销
		private static var _point:Point = new Point();
		
		private static var _point3D:Point3D = new Point3D();
		
		private static var _vector1:Vector2D = new Vector2D();
		private static var _vector2:Vector2D = new Vector2D();
		
		private static var _rect:Rectangle = new Rectangle();;
		
		// 数字常量
		// Math.sqrt(2)
		public static const SQRT_2:Number = 1.4142135623730950488016887242097;
		// Math.sqrt(3)
		public static const SQRT_3:Number = 1.7320508075688772935274463415059;
		// 1.2247
		public static const Y_CORRECT:Number = Math.cos( -Math.PI / 6) * Math.SQRT2;
		
		// 角度常量
		// Math.PI / 2
		public static const RADIAN_90:Number = 1.5707963267948965;
		// 60 * Math.PI / 180
		public static const RADIAN_60:Number = 1.0471975511965976666666666666667;
		// 45 * Math.PI / 180
		public static const RADIAN_45:Number = 0.78539816339744825;
		// 30 * Math.PI / 180
		public static const RADIAN_30:Number = 0.52359877559829883333333333333333;
		// Math.sin(RADIAN_90)
		public static const SIN_90:Number = 1;
		// Math.cos(RADIAN_90)
		public static const COS_90:Number = 0;
		// Math.sin(RADIAN_60)
		public static const SIN_60:Number = 0.86602540378443864676372317075294;
		// Math.cos(RADIAN_60)
		public static const COS_60:Number = .5;
		// Math.sin(RADIAN_45)
		public static const SIN_45:Number = 0.70710678118654752440084436210485;
		// Math.cos(RADIAN_45)
		public static const COS_45:Number = SIN_45;
		// Math.sin(RADIAN_30)
		public static const SIN_30:Number = COS_60;
		 //Math.cos(RADIAN_30)
		public static const COS_30:Number = SIN_60;
		
		/**
		 * 在2D平面中旋转一点
		 * 
		 * @param	x 当前x坐标
		 * @param	y 当前y坐标
		 * @param	radianIncrement 旋转点的弧度增量
		 * 
		 * @return 返回新的xy坐标值。
		 * 返的对象仅供返回之后立即读取内部的值，如果打算持有返回的对象，请调用该对象的clone方法。
		 */
		public static function rotate2D(x:Number, y:Number, radianIncrement:Number):Point
		{
			_point.x = Math.cos(radianIncrement) * x - Math.sin(radianIncrement) * y;
			_point.y = Math.cos(radianIncrement) * y + Math.sin(radianIncrement) * x;
			
			return _point;
		}
		
		/**
		 * 在2D平面中绕指定点旋转一点
		 * 
		 * @param	x 当前x坐标
		 * @param	y 当前y坐标
		 * @param	origX 旋转原点的x坐标
		 * @param	origY 旋转原点的y坐标
		 * @param	radian 旋转的弧度
		 * @param	useIncrement 是否使用增量。如果使用增量，表示radian是一个增量值。
		 * 
		 * @return 返回新的xy坐标值。
		 * 返的对象仅供返回之后立即读取内部的值，如果打算持有返回的对象，请调用返回对象的clone方法。
		 */
		public static function rotate2D_2(x:Number, y:Number, origX:Number, origY:Number, radian:Number, useIncrement:Boolean = false):Point
		{
			var newRadian:Number = 
				useIncrement ? Math.atan2(y - origY, x - origX) + radian : radian;
			var dx:Number = x - origX;
			var dy:Number = y - origY;
			var radius:Number = Math.sqrt(dx * dx + dy * dy);
			_point.x = origX + Math.cos(newRadian) * radius;
			_point.y = origY + Math.sin(newRadian) * radius;
			
			return _point;
		}
		
		/**
		 * 指定点绕x轴旋转
		 * 
		 * @param	y 指定点的y坐标
		 * @param	z 指定点的z坐标
		 * @param	radianIncrement 旋转弧度的增量
		 * 
		 * @return 返回新的yz坐标值。
		 * 返的对象仅供返回之后立即读取内部的值，如果打算持有返回的对象，请调用返回对象的clone方法。
		 */
		public static function rotateXAxis(y:Number, z:Number, radianIncrement:Number):Point3D
		{
			_point3D.y = Math.cos(radianIncrement) * y - Math.sin(radianIncrement) * z;
			_point3D.z = Math.cos(radianIncrement) * z + Math.sin(radianIncrement) * y;
			
			return _point3D;
		}
		
		/**
		 * 指定点绕y轴旋转
		 * 
		 * @param	x 指定点的x坐标
		 * @param	z 指定点的z坐标
		 * @param	radianIncrement 旋转弧度的增量
		 * 
		 * @return 返回新的xz坐标值。
		 * 返的对象仅供返回之后立即读取内部的值，如果打算持有返回的对象，请调用返回对象的clone方法。
		 */
		public static function rotateYAxis(x:Number, z:Number, radianIncrement:Number):Point3D
		{
			_point3D.x = Math.cos(radianIncrement) * x - Math.sin(radianIncrement) * z;
			_point3D.z = Math.cos(radianIncrement) * z + Math.sin(radianIncrement) * x;
			
			return _point3D;
		}
		
		/**
		 * 指定点绕z轴旋转
		 * 
		 * @param	x 指定点的x坐标
		 * @param	y 指定点的z坐标
		 * @param	radianIncrement 旋转弧度的增量
		 * 
		 * @return 返回新的xy坐标值。
		 * 返的对象仅供返回之后立即读取内部的值，如果打算持有返回的对象，请调用返回对象的clone方法。
		 */
		public static function rotateZAxis(x:Number, y:Number, radianIncrement:Number):Point3D
		{
			_point3D.x = Math.cos(radianIncrement) * x - Math.sin(radianIncrement) * y;
			_point3D.y = Math.cos(radianIncrement) * y + Math.sin(radianIncrement) * x;
			
			return _point3D;
		}
		
		/**
		 * 指定一点在3D空间中依次绕xyz轴进行旋转
		 * 
		 * @param	x 指定点的x坐标
		 * @param	y 指定点的y坐标
		 * @param	z 指定点的z坐标
		 * @param	xRadianIncrement 绕x轴旋转弧度的增量
		 * @param	yRadianIncrement 绕y轴旋转弧度的增量
		 * @param	zRadianIncrement 绕z轴旋转弧度的增量
		 * 
		 * @return 获得合成后新的xyz坐标。
		 * 返的对象仅供返回之后立即读取内部的值，如果打算持有返回的对象，请调用返回对象的clone方法。
		 */
		public static function rotate3D(x:Number, y:Number, z:Number, 
			xRadianIncrement:Number, yRadianIncrement:Number, zRadianIncrement:Number):Point3D
		{
			var newPoint:Point3D;
			
			if (xRadianIncrement != 0)
			{
				newPoint = rotateXAxis(y, z, xRadianIncrement);
				y = newPoint.y;
				z = newPoint.z;
			}
			
			if (yRadianIncrement != 0)
			{
				newPoint = rotateYAxis(x, z, yRadianIncrement);
				x = newPoint.x;
				z = newPoint.z;
			}
			
			if (zRadianIncrement != 0)
			{
				newPoint = rotateZAxis(x, y, zRadianIncrement);
				x = newPoint.x;
				y = newPoint.y;
			}
			
			_point3D.x = x;
			_point3D.y = y;
			_point3D.z = z;
			
			return _point3D;
		}
		
		/**
		 * 将等角世界中的坐标转换成屏幕坐标
		 * 
		 * @param	x 等角世界中的x坐标值
		 * @param	y 等角世界中的y坐标值
		 * @param	z 等角世界中的z坐标值
		 * @param	xAxisRadian 等角世界中x轴的旋转弧度
		 * @param	yAxisRadian 等角世界中y轴的旋转弧度
		 * 
		 * @return	返回转换后的屏幕坐标。
		 * 返的对象仅供返回之后立即读取内部的值，如果打算持有返回的对象，请调用返回对象的clone方法。
		 */
		public static function isoWorldToScreen(x:Number, y:Number, z:Number, xAxisRadian:Number, yAxisRadian:Number):Point
		{
			var point:Point3D = rotateYAxis(x, z, yAxisRadian);
			_point.x = point.x * Math.SQRT2;
			_point.y = rotateXAxis(y, point.z, xAxisRadian).y * Math.SQRT2;
			
			return _point;
		}
		
		/**
		 * 标准的等角世界坐标转换成屏幕坐标。精度和计算效率相对较高
		 * 
		 * @param	x	世界中的x坐标
		 * @param	y	世界中的y坐标
		 * @param	z	世界中的z坐标
		 * 
		 * @return	返回转换成的屏幕坐标。
		 * 返的对象仅供返回之后立即读取内部的值，如果打算持有返回的对象，请调用返回对象的clone方法。
		 */
		public static function isoWorldToScreenStandard(x:Number, y:Number, z:Number):Point
		{
			_point.x = x - z;
			_point.y = y * Y_CORRECT + (x + z) * .5;
			
			return _point;
		}
		
		/**
		 * 将等角世界中的屏幕坐标转换成世界坐标。由于屏幕坐标是2D的，所以转换后的世界坐标将丢失一个维度y，y总是等于0
		 * 
		 * @param	x 屏幕上的x坐标
		 * @param	y 屏幕上的y坐标
		 * @param	xAxisRadian 等角世界中x轴的旋转弧度
		 * @param	yAxisRadian 等角世界中y轴的旋转弧度
		 * 
		 * @return	返回转换后的世界坐标。
		 * 返的对象仅供返回之后立即读取内部的值，如果打算持有返回的对象，请调用返回对象的clone方法。
		 */
		public static function isoScreenToWorld(x:Number, y:Number, xAxisRadian:Number, yAxisRadian:Number):Point3D
		{
			_point3D = rotateYAxis(x / Math.SQRT2, -y / Math.SQRT2 / Math.sin(xAxisRadian), -yAxisRadian);
			_point3D.y = 0;
			
			return _point3D;
		}
		
		/**
		 * 标准的将等角世界中的屏幕坐标转换成世界坐标。由于屏幕坐标是2D的，所以转换后的世界坐标将丢失一个维度y，y总是等于0。
		 * 精度和计算效率相对较高
		 * 
		 * @param	x	屏幕上的x坐标
		 * @param	y	屏幕上的y坐标
		 * 
		 * @return	返回转换成的世界坐标。
		 * 返的对象仅供返回之后立即读取内部的值，如果打算持有返回的对象，请调用返回对象的clone方法。
		 */
		public static function isoScreenToWorldStandard(x:Number, y:Number):Point3D
		{
			_point3D.x = y + x * .5;
			_point3D.y = 0;
			_point3D.z = y - x * .5;
			
			return _point3D;
		}
		
		/**
		 * 判断点是否在三角形内。
		 * 输入点坐标，然后是三角形的顶点坐标。顶点的传入顺序没有限制。
		 * 经过测试此方法要比pointInTriangleByVector快
		 * 
		 * @author http://hi.baidu.com/actionscript3/home
		 * 
		 * @param	px
		 * @param	py
		 * @param	x1
		 * @param	y1
		 * @param	x2
		 * @param	y2
		 * @param	x3
		 * @param	y3
		 * 
		 * @return
		 */
		public static function pointInTriangle(
			px:Number, py:Number, 
			x1:Number, y1:Number, 
			x2:Number, y2:Number, 
			x3:Number, y3:Number):Boolean
		{
			return !(isOnSameSide(px, py, x1, y1, x2, y2, x3, y3) || 
				isOnSameSide(px, py, x2, y2, x3, y3, x1, y1) ||
				isOnSameSide(px, py, x3, y3, x1, y1, x2, y2));
		}
		
		private static function isOnSameSide(x0:Number,y0:Number,x1:Number,y1:Number,
                                     x2:Number,y2:Number,x3:Number,y3:Number):Boolean
		{
			var a:Number;
			var b:Number;
			var c:Number;
			a = y0 - y1; 
			b = x1 - x0; 
			c = x0 * y1 - x1 * y0;
			
			return (a * x2 + b * y2 + c) * (a * x3 + b * y3 + c) > 0;
		}
		
		/**
		 * 判断点是否在三角形内。
		 * 输入点坐标，然后是三角形的顶点坐标。
		 * 传入顶点的顺序根据sign来确定
		 * 
		 * @param	px
		 * @param	py
		 * @param	x1
		 * @param	y1
		 * @param	x2
		 * @param	y2
		 * @param	x3
		 * @param	y3
		 * @param	sign	等于1时，顺时针传入定点。等于-1，逆时针传入顶点
		 * 
		 * @return
		 */
		public static function pointInTriangleByVector(
			px:Number, py:Number, 
			x1:Number, y1:Number, 
			x2:Number, y2:Number, 
			x3:Number, y3:Number, 
			sign:Number = 1):Boolean
		{
			_vector1.x = x2 - x1;
			_vector1.y = y2 - y1;
			_vector2.x = px - x1;
			_vector2.y = py - y1;
			if (_vector1.signQuickly(_vector2) != sign)
			{
				return false;
			}
			
			_vector1.x = x3 - x2;
			_vector1.y = y3 - y2;
			_vector2.x = px - x2;
			_vector2.y = py - y2;
			if (_vector1.signQuickly(_vector2) != sign)
			{
				return false;
			}
			
			_vector1.x = x1 - x3;
			_vector1.y = y1 - y3;
			_vector2.x = px - x3;
			_vector2.y = py - y3;
			if (_vector1.signQuickly(_vector2) != sign)
			{
				return false;
			}
			
			return true;
		}
		
		/**
		 * 通过六边形的外接圆半径获得内接圆的半径
		 * 
		 * @param	outerR
		 * 
		 * @return
		 */
		public static function getHexagonInnerRByOuterR(outerR:Number):Number
		{
			return SQRT_3 * outerR * .5;
		}
		
		/**
		 * 判断联个矩形是否相交
		 * 
		 * @param	rect1
		 * @param	rect2
		 * 
		 * @return
		 */
		public static function rentanglesIntersect(rect1:Rectangle, rect2:Rectangle):Boolean
		{
			if (rect1 == null || rect2 == null)
			{
				return false;
			}
			else
			{
				var xOK:Boolean = false;
				var xDist:Number = rect2.x - rect1.x;
				if(rect1.x <= rect2.x)
				{
					if(xDist <= rect1.width)
					{
						xOK = true;
					}
				}
				else
				{
					if(-xDist <= rect2.width)
					{
						xOK = true;
					}
				}
				
				if(xOK)
				{
					var yDist:Number = rect2.y - rect1.y;
					if(rect1.y <= rect2.y)
					{
						if(yDist <= rect1.height)
						{
							return true;
						}
					}
					else
					{
						if(-yDist <= rect2.height)
						{
							return true;
						}
					}
				}
				
				return false;
			}
		}
		
		/**
		 * 获得包含两个矩形的更大的一个矩形
		 * 
		 * @param rect1
		 * @param rect2
		 * 
		 * @return 
		 */
		public static function getBoundsRectangle(rect1:Rectangle, rect2:Rectangle):Rectangle
		{
			if(rect1 == null && rect2 == null)
			{
				return null;
			}
			else if(rect1 == null && rect2 != null)
			{
				return rect2;
			}
			else if(rect1 != null && rect2 == null)
			{
				return rect1;
			}
			// rect1 != null && rect2 != null
			else
			{
				_rect.x = Math.min(rect1.x, rect2.x);
				_rect.y = Math.min(rect1.y, rect2.y);
				_rect.width = Math.max(rect1.x + rect1.width, rect2.x + rect2.width) - _rect.x;
				_rect.height = Math.max(rect1.y + rect1.height, rect2.y + rect2.height) - _rect.y;
				
				return _rect;
			}
		}
		
		/**
		 * 获得包含多个举行的一个更大的举行
		 * 
		 * @param rects
		 * 
		 * @return 
		 */
		public static function getBoundsRectangle2(rects:Vector.<Rectangle>):Rectangle
		{
			if(rects == null)
			{
				return null;
			}
			else
			{
				var rect:Rectangle = null;
				var length:uint = rects.length;
				for(var i:uint = 0; i < length; i++)
				{
					var newRect:Rectangle = getBoundsRectangle(rect, rects[i]);
					rect = newRect == null ? null : newRect.clone();
				}
					
				return rect;
			}
		}
	}
}