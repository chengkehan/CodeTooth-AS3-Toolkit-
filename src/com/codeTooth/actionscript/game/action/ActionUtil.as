package com.codeTooth.actionscript.game.action
{
	import com.codeTooth.actionscript.lang.exceptions.NullPointerException;
	import com.codeTooth.actionscript.lang.utils.destroy.DestroyUtil;
	
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	public class ActionUtil
	{
		/**
		 * 对大张的位图，根据传入的ClipData中的切片数据，进行切片。最后切成的小块位图，存入对应的ClipData对象中。
		 * 
		 * @param bmpd
		 * @param clipsData
		 */
		public static function sliceClips(bmpd:BitmapData, clipsData:Vector.<ClipData>):void
		{
			if(bmpd == null)
			{
				throw new NullPointerException("Null input bmpd parameter.");
			}
			
			var rect:Rectangle = new Rectangle();
			var destPoint:Point = new Point();
			for each(var clipData:ClipData in clipsData)
			{
				rect.x = clipData.x;
				rect.y = clipData.y;
				rect.width = clipData.width;
				rect.height = clipData.height;
				if(rect.width == 0 || rect.height == 0)
				{
					clipData.bitmapData = null;
				}
				else
				{
					var clipBmpd:BitmapData = new BitmapData(clipData.width, clipData.height, true, 0x00000000);
					clipBmpd.copyPixels(bmpd, rect, destPoint, null, null, true);
					clipData.bitmapData = clipBmpd;
				}
			}
		}
		
		/**
		 * 销毁传入存有ClipData对象的集合
		 * 
		 * @param clipsData
		 */
		public static function destroyClips(clipsData:Vector.<ClipData>):void
		{
			for each(var clipData:ClipData in clipsData)
			{
				if(clipData != null && clipData.bitmapData != null)
				{
					clipData.bitmapData.dispose();
				}
			}
			DestroyUtil.destroyVector(clipsData);
		}
		
		/**
		 * 通过SparrowXML中的数据，创建所有的ClipData对象
		 * 
		 * @param sparrow
		 * 
		 * @return 返回存有所有ClipData对象的集合
		 */
		public static function createClipsBySparrow(sparrow:XML):Vector.<ClipData>
		{
			if(sparrow == null)
			{
				throw new NullPointerException("Null input sparrow parameter.");
			}
			
			var subTextures:XMLList = sparrow.SubTexture;
			var clips:Vector.<ClipData> = new Vector.<ClipData>(subTextures.length());
			var index:int = 0;
			for each(var subTexture:XML in subTextures)
			{
				var clip:ClipData = new ClipData(
					subTexture.@x, subTexture.@y, subTexture.@width, subTexture.@height, 
					subTexture.@frameX, subTexture.@frameY, subTexture.@frameWidth, subTexture.@frameHeight, 
					null, null, subTexture.@name
				);
				clips[index] = clip;
				index++;
			}
			
			return clips;
		}
		
		/**
		 * 验证是否是一个合法的SparrowXML
		 * 
		 * @param sparrow
		 * @return 
		 */
		public static function sparrowLegal(sparrow:XML):Boolean
		{
			if(sparrow == null)
			{
				throw new NullPointerException("Null input sparrow parameter.");
			}
			
			if(sparrow.name() != "TextureAtlas")
			{
				return false;
			}
			
			var SubTextureList:XMLList = sparrow.SubTexture;
			for each(var SubTexture:XML in SubTextureList)
			{
				if(SubTexture.name() != "SubTexture")
				{
					return false;
				}
				if(!SubTexture.hasOwnProperty("@name") || 
					!SubTexture.hasOwnProperty("@x") || 
					!SubTexture.hasOwnProperty("@y") || 
					!SubTexture.hasOwnProperty("@width") || 
					!SubTexture.hasOwnProperty("@height"))
				{
					return false;
				}
				
				var width:int = SubTexture.@width;
				var height:int = SubTexture.@height;
				if((width == 0 && height != 0) || 
					(width != 0 && height == 0) || 
					(width == 0 && height == 0 && (SubTexture.hasOwnProperty("@frameX") || SubTexture.hasOwnProperty("@frameY") || SubTexture.hasOwnProperty("@frameWidth") || SubTexture.hasOwnProperty("@frameHeight"))))
				{
					return false;
				}
			}
			
			return true;
		}
	}
}