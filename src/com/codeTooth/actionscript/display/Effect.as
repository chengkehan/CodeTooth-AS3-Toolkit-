package com.codeTooth.actionscript.display 
{
	import flash.display.DisplayObject;
	import flash.filters.ColorMatrixFilter;
	import flash.geom.ColorTransform;
	
	public class Effect
	{
		private static var _colorTrandform:ColorTransform = null;
		
		/**
		 * 改变显示对象的颜色
		 * 
		 * @param	target 目标对象，对象必须是已经灰度处理后的
		 * @param	color 指定的颜色
		 */
		public static function changeColor(target:DisplayObject, color:uint = 0x0099FF):DisplayObject
		{
			if (target != null)
			{
				var red:Number = color >>> 16;
				var green:Number = color >>> 8 & 0xff;
				var blue:Number = color & 0xff;
				red = red / 255;
				green = green / 255;
				blue = blue / 255;
				
				if (_colorTrandform == null)
				{
					_colorTrandform = new ColorTransform();
				}
				_colorTrandform.redMultiplier = red;
				_colorTrandform.greenMultiplier = green;
				_colorTrandform.blueMultiplier = blue;
				target.transform.colorTransform = _colorTrandform;
				
				return target;
			}
			else
			{
				return null;
			}
		}
		
		private static var _colorMatrixFilter:Array = null;
		
		private static var _colorMatrixFileterMatrix:Array = null;
		
		/**
		 * 改变显示对象的灰度
		 * 
		 * @param	target
		 * @param	value 0到1的值
		 * 
		 * @return
		 */
		public static function gray(target:DisplayObject, value:Number = 0):DisplayObject
		{
			if (target != null)
			{
				value = Math.min(Math.max(value, 0), 1);
				var value1:Number = .33 + .67 * value;
				var value2:Number = .33 * (1 - value);
				
				if (_colorMatrixFilter == null)
				{
					_colorMatrixFileterMatrix = new Array();
					_colorMatrixFileterMatrix[3] = 0;
					_colorMatrixFileterMatrix[4] = 0;
					_colorMatrixFileterMatrix[8] = 0;
					_colorMatrixFileterMatrix[9] = 0;
					_colorMatrixFileterMatrix[13] = 0;
					_colorMatrixFileterMatrix[14] = 0;
					_colorMatrixFileterMatrix[15] = 0;
					_colorMatrixFileterMatrix[16] = 0;
					_colorMatrixFileterMatrix[17] = 0;
					_colorMatrixFileterMatrix[18] = 1;
					_colorMatrixFileterMatrix[19] = 0;
					
					_colorMatrixFilter = [new ColorMatrixFilter()];
				}
				_colorMatrixFileterMatrix[0] = value1;
				_colorMatrixFileterMatrix[1] = value2;
				_colorMatrixFileterMatrix[2] = value2;
				
				_colorMatrixFileterMatrix[5] = value2;
				_colorMatrixFileterMatrix[6] = value1;
				_colorMatrixFileterMatrix[7] = value2;
				
				_colorMatrixFileterMatrix[10] = value2;
				_colorMatrixFileterMatrix[11] = value2;
				_colorMatrixFileterMatrix[12] = value1;
				
				_colorMatrixFilter[0].matrix = _colorMatrixFileterMatrix;
				
				target.filters = _colorMatrixFilter;
				
				return target;
			}
			else
			{
				return null;
			}
		}
	}

}