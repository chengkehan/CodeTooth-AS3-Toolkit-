package com.codeTooth.actionscript.display 
{
	import com.codeTooth.actionscript.lang.utils.geom.Mathematic;
	
	import flash.display.Graphics;
	
	/**
	 * 画笔
	 */
	public class GraphicsPen 
	{
		/**
		 * 六边形
		 * 
		 * @param	graphics	画布
		 * @param	outR	外径
		 * @param	x	画到画布上的x位置
		 * @param	y	画到画布上的x位置
		 * @param	centerAlign	是否使六边形的中心位置对齐指定的位置。传入false将使六边形的左上角对齐指定的位置
		 * 
		 * @return
		 */
		public static function drawHexagon(graphics:Graphics, outR:Number, x:Number = 0, y:Number = 0, centerAlign:Boolean = true):Boolean
		{
			if (graphics != null)
			{
				var halfR:Number = outR * .5;
				var h:Number = Mathematic.getHexagonInnerRByOuterR(outR);
				if (centerAlign)
				{
					x = -outR;
					y = -h;
				}
				graphics.moveTo(x - halfR + outR, y);
				graphics.lineTo(x + halfR + outR, y);
				graphics.lineTo(x + outR + outR, y + h);
				graphics.lineTo(x + halfR + outR, y + h + h);
				graphics.lineTo(x -halfR + outR, y + h + h);
				graphics.lineTo(x, y + h);
				graphics.lineTo(x - halfR + outR, y);
				
				return true;
			}
			else
			{
				return false;
			}
		}
		
		/**
		 * 菱形
		 * 
		 * @param	graphics	画布
		 * @param	longR	长内径的一半
		 * @param	x	画到画布上的x位置
		 * @param	y	画到画布上的x位置
		 * @param	centerAlign	是否使菱形的中心位置对齐指定的位置。传入false将使菱形的左上角对齐指定的位置
		 * 
		 * @return
		 */
		public static function drawDiamond(graphics:Graphics, longR:Number, x:Number = 0, y:Number = 0, centerAlign:Boolean = true):Boolean
		{
			if (graphics != null)
			{
				var halfLongR:Number = longR * .5
				if (centerAlign)
				{
					x = -longR;
					y = -halfLongR;
				}
				graphics.moveTo(x + longR, y);
				graphics.lineTo(x + longR * 2, y + halfLongR);
				graphics.lineTo(x + longR, y + longR);
				graphics.lineTo(x, y + halfLongR);
				graphics.lineTo(x + longR, y);
				
				return true;
			}
			else
			{
				return false;
			}
		}
		
		/**
		 * 矩形
		 * 
		 * @param	graphics	画布
		 * @param	width
		 * @param	height
		 * @param	x	画到画布上的x位置
		 * @param	y	画到画布上的x位置
		 * @param	centerAlign	是否使矩形的中心位置对齐指定的位置。传入false将使矩形的左上角对齐指定的位置
		 * 
		 * @return
		 */
		public static function drawRectangle(graphics:Graphics, width:Number, height:Number, x:Number = 0, y:Number = 0, centerAlign:Boolean = true):Boolean
		{
			if (graphics != null)
			{
				if (centerAlign)
				{
					x = -width * .5;
					y = -height * .5;
				}
				
				graphics.moveTo(x, y);
				graphics.lineTo(x + width, y);
				graphics.lineTo(x + width, y + height);
				graphics.lineTo(x, y + height);
				graphics.lineTo(x, y);
				
				return true;
			}
			else
			{
				return false;
			}
		}
		
		/**
		 * 十字
		 * 
		 * @param	graphics
		 * @param	lineLength
		 * @param	lineWidth
		 * @param	x	在画布上的x位置
		 * @param	y	在画布上的y位置
		 * @param	centerAlign	是否使十字的中心位置对齐指定的位置。传入false将使矩形的左上角对齐指定的位置
		 * @return
		 */
		public static function drawCross(graphics:Graphics, lineLength:Number = 100, lineWidth:Number = 10, x:Number = 0, y:Number = 0, centerAlign:Boolean = true):Boolean
		{
			if (graphics != null)
			{
				if (centerAlign)
				{
					x = -lineLength * .5;
					y = -lineLength * .5;
				}
				
				var l1:Number = (lineLength - lineWidth) * .5;
				
				graphics.moveTo(x, y);
				graphics.moveTo(x + l1, y);
				graphics.lineTo(x + l1 + lineWidth, y);
				graphics.lineTo(x + l1 + lineWidth, y + l1);
				graphics.lineTo(x + l1 + lineWidth + l1, y + l1);
				graphics.lineTo(x + l1 + lineWidth + l1, y + l1 + lineWidth);
				graphics.lineTo(x + l1 + lineWidth, y + l1 + lineWidth);
				graphics.lineTo(x + l1 + lineWidth, y + l1 + lineWidth + l1);
				graphics.lineTo(x + l1, y + l1 + lineWidth + l1);
				graphics.lineTo(x + l1, y + l1 + lineWidth);
				graphics.lineTo(x, y + l1 + lineWidth);
				graphics.lineTo(x, y + l1);
				graphics.lineTo(x + l1, y + l1);
				graphics.lineTo(x + l1, y);
				
				return true;
			}
			else
			{
				return false;
			}
		}
		
		public static function drawGridLines(graphics:Graphics, rows:uint = 8, cols:uint = 10, cellWidth:Number = 10, cellHeight:Number = 10, startX:Number = 0, startY:Number = 0):Boolean
		{
			if(graphics != null)
			{
				var width:Number = cols * cellWidth;
				var height:Number = rows * cellHeight;
				
				for(var row:uint = 0; row <= rows; row++)
				{
					graphics.moveTo(startX, startY + row * cellHeight);
					graphics.lineTo(startX + width, startY + row * cellHeight);
				}
				
				for(var col:uint = 0; col <= cols; col++) 
				{
					graphics.moveTo(startX + col * cellWidth, startY);
					graphics.lineTo(startX + col * cellWidth, startY + height);
				}
				
				return true;
			}
			else
			{
				return false;
			}
		}
	}

}