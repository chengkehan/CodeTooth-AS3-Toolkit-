package com.codeTooth.actionscript.display
{
	import com.codeTooth.actionscript.lang.exceptions.IllegalOperationException;
	import com.codeTooth.actionscript.lang.exceptions.IllegalParameterException;
	import com.codeTooth.actionscript.lang.exceptions.NullPointerException;
	
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;

	/**
	 * 位图Alpha混合。
	 * 将原始的位图画布放大一倍。
	 * 原始位图用黑色作为背景。
	 * 放大的区域可以是在原始图片的右边或者下边。
	 * 在放大的区域中是一张灰度图（纯白为不透明，纯黑为透明，根据灰色来调整透明值），描述原始图的Alpha。
	 * 使用png8存储源图片效果最佳（需要测试下原始图在256色下是否会颜色失帧）。
	 * 使用jpg存储源图片时，由于jpg压缩算法的原因，根据jpg的品质不同，会出现不同程度的颜色失帧。
	 */
	public class BitmapDataAlphaBlend
	{
		/**
		 * 灰度图在原始图的右边
		 */
		public static const VERTICAL:int = 1;
		
		/**
		 * 灰度图在原始图的下边
		 */
		public static const HORIZONTAL:int = 2;
		
		/**
		 * 是否是合法的alpha混合位图。
		 * 
		 * @param bmpd
		 * @param maskBmpdType
		 * 
		 * @return 
		 */
		public static function isLegal(bmpd:BitmapData, maskBmpdType:int):Boolean
		{
			if(bmpd == null)
			{
				throw new NullPointerException("Null input bmpd parameter.");
			}
			
			if(maskBmpdType == VERTICAL)
			{
				return bmpd.height % 2 == 0;
			}
			else if(maskBmpdType == HORIZONTAL)
			{
				return bmpd.width % 2 == 0;
			}
			else
			{
				throw new IllegalParameterException("Illegal maskBmpdType \"" + maskBmpdType + "\"");
				return false;
			}
		}
		
		/**
		 * 获得原始图的BitmapData形态
		 * 
		 * @param maskBmpd
		 * @param maskBmpdType
		 * @param empty
		 * 
		 * @return 
		 */
		public static function getAction(maskBmpd:BitmapData, maskBmpdType:int, empty:Boolean = false):BitmapData
		{
			checkLegal(maskBmpd, maskBmpdType);
			
			var newBmpd:BitmapData = null;
			if(maskBmpdType == VERTICAL)
			{
				newBmpd = new BitmapData(maskBmpd.width, maskBmpd.height * .5, true, 0x00000000);
			}
			else
			{
				newBmpd = new BitmapData(maskBmpd.width * .5, maskBmpd.height, true, 0x00000000);
			}
			if(!empty)
			{
				newBmpd.copyPixels(maskBmpd, newBmpd.rect, new Point());
			}
			
			return newBmpd;
		}
		
		/**
		 * 获得灰度图的BitmapData形态
		 * 
		 * @param maskBmpd
		 * @param maskBmpdType
		 * 
		 * @return 
		 */
		public static function getMask(maskBmpd:BitmapData, maskBmpdType:int):BitmapData
		{
			checkLegal(maskBmpd, maskBmpdType);
			
			var newBmpd:BitmapData = null;
			if(maskBmpdType == VERTICAL)
			{
				newBmpd = new BitmapData(maskBmpd.width, maskBmpd.height * .5, false, 0x000000);
				newBmpd.copyPixels(maskBmpd, new Rectangle(0, maskBmpd.height * .5, maskBmpd.width, maskBmpd.height * .5), new Point());
			}
			else
			{
				newBmpd = new BitmapData(maskBmpd.width * .5, maskBmpd.height, false, 0x000000);
				newBmpd.copyPixels(maskBmpd, new Rectangle(maskBmpd.width * .5, 0, maskBmpd.width * .5, maskBmpd.height), new Point());
			}
			
			return newBmpd;
		}
		
		/**
		 * 获得原始图的Vector形态
		 * 
		 * @param maskBmpd
		 * @param maskBmpdType
		 * 
		 * @return 
		 */
		public static function getActionPixels(maskBmpd:BitmapData, maskBmpdType:int):Vector.<uint>
		{
			checkLegal(maskBmpd, maskBmpdType);
			
			if(maskBmpdType == VERTICAL)
			{
				return maskBmpd.getVector(new Rectangle(0, 0, maskBmpd.width, maskBmpd.height * .5));
			}
			else
			{
				return maskBmpd.getVector(new Rectangle(0, 0, maskBmpd.width * .5, maskBmpd.height));
			}
		}
		
		/**
		 * 获得灰度图的Vector形态
		 * 
		 * @param maskBmpd
		 * @param maskBmpdType
		 * 
		 * @return 
		 */
		public static function getMaskPixels(maskBmpd:BitmapData, maskBmpdType:int):Vector.<uint>
		{
			checkLegal(maskBmpd, maskBmpdType);
			
			if(maskBmpdType == VERTICAL)
			{
				return maskBmpd.getVector(new Rectangle(0, maskBmpd.height * .5, maskBmpd.width, maskBmpd.height * .5));
			}
			else
			{
				return maskBmpd.getVector(new Rectangle(maskBmpd.width * .5, 0, maskBmpd.width * .5, maskBmpd.height));
			}
		}
		
		/**
		 * 获得原始图的ByteArray形态
		 * 
		 * @param maskBmpd
		 * @param maskBmpdType
		 * 
		 * @return 
		 */
		public static function getActionBytes(maskBmpd:BitmapData, maskBmpdType:int):ByteArray
		{
			checkLegal(maskBmpd, maskBmpdType);
			
			if(maskBmpdType == VERTICAL)
			{
				return maskBmpd.getPixels(new Rectangle(0, 0, maskBmpd.width, maskBmpd.height * .5));
			}
			else
			{
				return maskBmpd.getPixels(new Rectangle(0, 0, maskBmpd.width * .5, maskBmpd.height));
			}
		}
		
		/**
		 * 获得灰度图的ByteArray形态
		 * 
		 * @param maskBmpd
		 * @param maskBmpdType
		 * 
		 * @return 
		 */
		public static function getMaskBytes(maskBmpd:BitmapData, maskBmpdType:int):ByteArray
		{
			checkLegal(maskBmpd, maskBmpdType);
			
			if(maskBmpdType == VERTICAL)
			{
				return maskBmpd.getPixels(new Rectangle(0, maskBmpd.height * .5, maskBmpd.width, maskBmpd.height * .5));
			}
			else
			{
				return maskBmpd.getPixels(new Rectangle(maskBmpd.width * .5, 0, maskBmpd.width * .5, maskBmpd.height));
			}
		}
		
		/**
		 * 混合BitmapData形态的原始图和灰度图
		 * 
		 * @param action
		 * @param mask
		 */
		public static function mixBitmapData(action:BitmapData, mask:BitmapData):void
		{
			if(action == null)
			{
				throw new NullPointerException("Null input action parameter.");
			}
			if(mask == null)
			{
				throw new NullPointerException("Null input mask parameter.");
			}
			if(action.width != mask.width || action.height != action.height)
			{
				throw new IllegalParameterException("Illegal action and mask bmpd size.");
			}
			
			action.lock();
			mask.lock();
			var actionW:int = action.width;
			var actionH:int = action.height;
			for (var w:int = 0; w < actionW; w++) 
			{
				for (var h:int = 0; h < actionH; h++) 
				{
					var maskColor:uint = mask.getPixel(w, h);
					if(maskColor == 0x000000)
					{
						action.setPixel32(w, h, 0x00000000);
					}
					else if(maskColor == 0xFFFFFF)
					{
						// Do nothing
					}
					else
					{
						var roleColor:uint = action.getPixel32(w, h);
						var roleAlpha:int = 0xFF * (maskColor / 0xFFFFFF);
						action.setPixel32(w, h, (roleAlpha << 24) + roleColor);
					}
				}
				
			}
			mask.unlock();
			action.unlock();
		}
		
		/**
		 * 混合Vector形态的原始图和灰度图
		 * 
		 * @param action
		 * @param mask
		 */
		public static function mixPixels(action:Vector.<uint>, mask:Vector.<uint>):void
		{
			if(action == null)
			{
				throw new NullPointerException("Null input action parameter.");
			}
			if(mask == null)
			{
				throw new NullPointerException("Null input mask parameter.");
			}
			if(action.length != mask.length)
			{
				throw new IllegalParameterException("Illegal action and mask vector size.");
			}
			
			var length:uint = action.length;
			for (var i:int = 0; i < length; i++) 
			{
				var maskColor:uint = mask[i];
				if(maskColor == 0xFF000000)
				{
					action[i] = 0x00000000;
				}
				else if(maskColor == 0xFFFFFFFF)
				{
					// Do nothing
				}
				else
				{
					var roleColor:uint = action[i];
					var roleAlpha:int = 0xFF * (maskColor / 0xFFFFFF);
					action[i] = (roleAlpha << 24) + roleColor;
				}
			}
		}
		
		/**
		 * 混合ByteArray形态的原始图和灰度图
		 * 
		 * @param action
		 * @param mask
		 */
		public static function mixBytes(action:ByteArray, mask:ByteArray):void
		{
			if(action == null)
			{
				throw new NullPointerException("Null input action parameter.");
			}
			if(mask == null)
			{
				throw new NullPointerException("Null input mask parameter.");
			}
			if(action.length != mask.length)
			{
				throw new IllegalParameterException("Illegal action and mask vector size.");
			}
			
			action.position = 0;
			mask.position = 0;
			var length:int = action.length * .25;
			for (var i:int = 0; i < length; ++i) 
			{
				var pos:int = i << 2;
				var maskColor:uint = (mask[pos + 1] << 16) + (mask[pos + 2] << 8) + mask[pos + 3];
				if(maskColor == 0x000000)
				{
					action[pos] = 0x00;
				}
				else if(maskColor == 0xFFFFFF)
				{
					// Do nothing
				}
				else
				{
					var roleAlpha:int = 0xFF * (maskColor / 0xFFFFFF);
					action[pos] = roleAlpha;
				}
			}
			action.position = 0;
			mask.position = 0;
		}
		
		/**
		 * 直接快速获得混合后的图片，内部使用BitmapData形态。
		 * 
		 * @param maskBmpd
		 * @param maskBmpdType
		 * 
		 * @return 
		 */
		public static function mixBitmapDataSimplely(maskBmpd:BitmapData, maskBmpdType:int):BitmapData
		{
			var action:BitmapData = BitmapDataAlphaBlend.getAction(maskBmpd, maskBmpdType);
			var mask:BitmapData = BitmapDataAlphaBlend.getMask(maskBmpd, maskBmpdType);
			BitmapDataAlphaBlend.mixBitmapData(action, mask);
			mask.dispose();
			
			return action;
		}
		
		/**
		 * 直接快速获得混合后的图片，内部使用Vector形态。
		 * 
		 * @param maskBmpd
		 * @param maskBmpdType
		 * 
		 * @return 
		 */
		public static function mixPixelsSimplely(maskBmpd:BitmapData, maskBmpdType:int):BitmapData
		{
			var action:Vector.<uint> = BitmapDataAlphaBlend.getActionPixels(maskBmpd, maskBmpdType);
			var mask:Vector.<uint> = BitmapDataAlphaBlend.getMaskPixels(maskBmpd, maskBmpdType);
			BitmapDataAlphaBlend.mixPixels(action, mask);
			var actionBmpd:BitmapData = BitmapDataAlphaBlend.getAction(maskBmpd, maskBmpdType, true);
			actionBmpd.setVector(actionBmpd.rect, action);
			mask.length = 0;
			action.length = 0;
			
			return actionBmpd;
		}
		
		/**
		 * 直接快速获得混合后的图片，内部使用ByteArray形态。
		 * 
		 * @param maskBmpd
		 * @param maskBmpdType
		 * 
		 * @return 
		 */
		public static function mixBytesSimplely(maskBmpd:BitmapData, maskBmpdType:int):BitmapData
		{
			var action:ByteArray = BitmapDataAlphaBlend.getActionBytes(maskBmpd, maskBmpdType);
			var mask:ByteArray = BitmapDataAlphaBlend.getMaskBytes(maskBmpd, maskBmpdType);
			BitmapDataAlphaBlend.mixBytes(action, mask);
			var actionBmpd:BitmapData = BitmapDataAlphaBlend.getAction(maskBmpd, maskBmpdType, true);
			actionBmpd.setPixels(actionBmpd.rect, action);
			action.clear();
			mask.clear();
			
			return actionBmpd;
		}
		
		private static function checkLegal(maskBmpd:BitmapData, maskBmpdType:int):void
		{
			if(!isLegal(maskBmpd, maskBmpdType))
			{
				throw new IllegalOperationException("Illegal MaskBitmapData");
			}
		}
	}
}