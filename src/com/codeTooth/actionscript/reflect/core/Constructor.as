package com.codeTooth.actionscript.reflect.core
{
	import com.codeTooth.actionscript.lang.utils.destroy.DestroyUtil;
	import com.codeTooth.actionscript.lang.utils.destroy.IDestroy;
	import com.codeTooth.actionscript.patterns.iterator.ArrayIterator;
	import com.codeTooth.actionscript.patterns.iterator.IIterator;
	
	/**
	 * 构造函数
	 */	
	
	public class Constructor implements IDestroy 
	{
		//构造函数入参
		private var _parameters:Array = null;
		
		public function Constructor()
		{
			
		}
		
		/**
		 * 获得构造函数入参迭代器
		 * 
		 * @return 
		 */		
		public function parametersIterator():IIterator/*of Parameter*/
		{
			if(hasParameters())
			{
				return new ArrayIterator(_parameters);
			}
			else
			{
				return null;
			}
		}
		
		/**
		 * 判断构造函数是否有入参
		 * 
		 * @return
		 */		
		public function hasParameters():Boolean
		{
			return _parameters != null;
		}
		
		/**
		 * @inheritDoc
		 */		
		public function destroy():void
		{
			if(_parameters != null)
			{
				DestroyUtil.breakArray(_parameters);
				_parameters = null;
			}
		}
		
		//设置入参
		internal function set parametersInternal(parameters:Array):void
		{
			_parameters = parameters;
		}
	}
}