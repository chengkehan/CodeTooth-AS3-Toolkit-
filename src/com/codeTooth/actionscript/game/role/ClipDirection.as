package com.codeTooth.actionscript.game.role
{
	import com.codeTooth.actionscript.lang.utils.ConstantObject;

	/**
	 * 剪辑方向
	 */
	public class ClipDirection extends ConstantObject
	{
		public static const UP:ClipDirection = createInstance("up", ClipDirection);
		
		public static const DOWN:ClipDirection = createInstance("down", ClipDirection);
		
		public static const LEFT:ClipDirection = createInstance("left", ClipDirection);
		
		public static const RIGHT:ClipDirection = createInstance("right", ClipDirection);
		
		public static const LEFT_UP:ClipDirection = createInstance("leftUp", ClipDirection);
		
		public static const LEFT_DOWN:ClipDirection = createInstance("leftDown", ClipDirection);
		
		public static const RIGHT_UP:ClipDirection = createInstance("rightUp", ClipDirection);
		
		public static const RIGHT_DOWN:ClipDirection = createInstance("rightDown", ClipDirection);
		
		public static const NUMBER_CLIP_DIRECTIONS:uint = 8;
		
		public static function getClipDirectionByString(str:String):ClipDirection
		{
			return str == UP.toString() ? UP : 
				str == DOWN.toString() ? DOWN : 
				str == LEFT.toString() ? LEFT : 
				str == RIGHT.toString() ? RIGHT : 
				str == LEFT_UP.toString() ? LEFT_UP : 
				str == LEFT_DOWN.toString() ? LEFT_DOWN : 
				str == RIGHT_UP.toString() ? RIGHT_UP : 
				str == RIGHT_DOWN.toString() ? RIGHT_DOWN : null;
		}
	}
}