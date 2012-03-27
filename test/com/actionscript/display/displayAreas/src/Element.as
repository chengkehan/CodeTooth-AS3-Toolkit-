package
{
	import flash.display.Shape;
	import flash.display.Sprite;
	
	public class Element extends Sprite
	{
		private var _vx:Number = 0;
		
		private var _vy:Number = 0;
		
		private var _maxX:Number = 0;
		
		private var _minX:Number = 0;
		
		private var _maxY:Number = 0;
		
		private var _minY:Number = 0;
		
		public function Element(size:uint, x:Number, y:Number, vx:Number, vy:Number, maxX:Number, maxY:Number, minX:Number, minY:Number)
		{
			graphics.beginFill(0xFFFFFF * Math.random());
			graphics.drawRect(0, 0, size, size);
			graphics.endFill();
			this.x = x;
			this.y = y;
			_vx = vx;
			_vy = vy;
			_minX = minX;
			_minY = minY;
			_maxX = maxX;
			_maxY = maxY;
		}
		
		public function move():void
		{
			x += _vx;
			y += _vy;
			
			if(x < _minX || x > _maxX)
			{
				_vx *= -1;
			}
			if(y < _minY || y > _maxY)
			{
				_vy *= -1;
			}
		}
	}
}