package com.codeTooth.actionscript.lang.utils.geom 
{
	import com.codeTooth.actionscript.lang.utils.clone.ICloneable;
	
	public class Point3D implements ICloneable
	{
		public var x:Number = 0;
		
		public var y:Number = 0;
		
		public var z:Number = 0;
		
		public function Point3D(x:Number = 0, y:Number = 0, z:Number = 0) 
		{
			this.x = x;
			this.y = y;
			this.z = z;
		}
		
		public function clone():*
		{
			return new Point3D(x, y, z);
		}
		
		public function toString():String
		{
			return "[object Point3D(x:" + x + ", y:" + y + ", z:" + z + ")]";
		}
	}

}