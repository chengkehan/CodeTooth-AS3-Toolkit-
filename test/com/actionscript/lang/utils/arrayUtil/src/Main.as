package 
{
	import com.codeTooth.actionscript.lang.utils.ArrayUtil;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.utils.getTimer;
	
	public class Main extends Sprite 
	{
		private var _array:Array = null;
		
		private var _vector:Vector.<Sprite> = null;
		
		private var _child:Sprite = null;
		
		public function Main()
		{
			_array = new Array();
			for (var i:int = 0; i < 100; i++)
			{
				_array[i] = { index:i };
			}
			
			//trace(ArrayUtil.getItemByRowCol(_array, 0, 9, 10, 10).index);
			//trace(ArrayUtil.getItemByProperty(_array, "index", 10000));
			//trace(ArrayUtil.getItemByProperty(_array, "index", 31).index);
			
			
			_child = new Sprite();
			_vector = new Vector.<Sprite>();
			for (i = 0; i < 50; i++)
			{
				_vector[i] = new Sprite();
				_vector[i].x = i;
				
				if (i == 0)
				{
					_vector[i].addChild(_child);
				}
			}
			
			//trace(ArrayUtil.getItemByProperty(_vector, "x", 34));
			//trace(ArrayUtil.getItemByMethodReturnValue(_vector, "toString", "[object Sprite]"));
			
			//var time:int = getTimer();
			trace(ArrayUtil.getItemByMethodReturnValue(_vector, "contains", true, itemContains).x);
			//trace("time", getTimer() - time);
		}
		
		private function itemContains(item:Sprite):Array
		{
			return [_child];
		}
		
	}
	
}