package com.codeTooth.actionscript.display 
{
	import flash.display.Bitmap;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	
	public function interactiveBitmap(bitmap:Bitmap, definition:Class):Sprite
	{
		if (bitmap == null)
		{
			return null;
		}
		else
		{
			var parent:DisplayObjectContainer = bitmap.parent;
			var container:Sprite = new definition();
			container.addChild(bitmap);
			container.x = bitmap.x;
			container.y = bitmap.y;
			bitmap.x = 0;
			bitmap.y = 0;
			
			if (parent != null)
			{
				parent.addChild(container);
			}
			
			return container;
		}
	}

}