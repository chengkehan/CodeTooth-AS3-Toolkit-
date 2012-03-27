package com.codeTooth.actionscript.display 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.IBitmapDrawable;
	import flash.geom.Matrix;
	
	/**
	 * 获得指定显示对象的快照
	 * 
	 * @param object 指定的显示对象
	 * 
	 * @return 返回生成的快照位图
	 */	
	public function snapshot(object:Object):Bitmap
	{
		if (object == null)
		{
			return null;
		}
		else
		{
			var matrix:Matrix = object is DisplayObject ? object.transform.matrix : new Matrix();
				
			var bmp:Bitmap = new Bitmap(new BitmapData(object.width, object.height, true, 0x00FFFFFF));
			bmp.bitmapData.draw(IBitmapDrawable(object), matrix);
			
			return bmp;
		}
	}
}