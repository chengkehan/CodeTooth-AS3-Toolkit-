package com.codeTooth.actionscript.lang.utils.newObjectPool
{
	import com.codeTooth.actionscript.lang.utils.destroy.IDestroy;

	/**
	 * 对象池中存储的一个项
	 */
	internal class Item implements IDestroy
	{
		/**
		 * 对象实例
		 */
		public var object:Object = null;
		
		/**
		 * 最近的一次活跃时间点
		 */
		public var activeTimePoint:int = 0;
		
		/**
		 * 被使用的次数
		 */
		public var usedTimes:int = 0;
		
		public function Item()
		{
		}
		
		public function destroy():void
		{
			object = null;
		}
	}
}