package com.codeTooth.actionscript.dependencyInjection.core 
{
	import com.codeTooth.actionscript.lang.exceptions.NoSuchObjectException;
	import com.codeTooth.actionscript.lang.exceptions.NullPointerException;
	import com.codeTooth.actionscript.lang.utils.destroy.IDestroy;
	
	/**
	 * @private
	 */	
	 
	internal class Content implements IDestroy
	{
		private var _child1:DiObject = null;
		
		private var _child2:DiObject = null;
		
		public function Content()
		{
			
		}
		
		public function set child1(child1:DiObject):void
		{
			if(child1 == null)
			{
				throw new NullPointerException("Null child");
			}
			
			_child1 = child1;
		}
		
		public function get child1():DiObject
		{
			if(_child1 == null)
			{
				throw new NoSuchObjectException("No child1");
			}
			
			return _child1;
		}
		
		public function set child2(child2:DiObject):void
		{
			if(child2 == null)
			{
				throw new NullPointerException("Null child2");
			}
			
			_child2 = child2;
		}
		
		public function get child2():DiObject
		{
			if(_child2 == null)
			{
				throw new NoSuchObjectException("No child2");
			}
			
			return _child2;
		}
		
		public function destroy():void
		{
			if(hasChild1())
			{
				_child1.destroy();
				_child1 = null;
			}
			
			if(hasChild2())
			{
				_child2.destroy();
				_child2 = null;
			}
		}
		
		public function hasChild1():Boolean
		{
			return _child1 != null;
		}
		
		public function hasChild2():Boolean
		{
			return _child2 != null;
		}
	}
}