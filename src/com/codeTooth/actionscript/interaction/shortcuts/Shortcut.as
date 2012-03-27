package com.codeTooth.actionscript.interaction.shortcuts 
{
	import com.codeTooth.actionscript.lang.utils.compare.CompareUtil;
	import com.codeTooth.actionscript.lang.utils.compare.IComparable;
	import com.codeTooth.actionscript.lang.utils.destroy.IDestroy;
	
	/**
	 * 快捷键对象
	 */
	public class Shortcut implements IComparable, IDestroy
	{
		/**
		 * Control键是否处于活动状态
		 */
		public var ctrlKey:Boolean = false;
		
		/**
		 * Shift键是否处于活动状态
		 */
		public var shiftKey:Boolean = false;
		
		/**
		 * Alt键是否处于活动状态
		 */
		public var altKey:Boolean = false;
		
		/**
		 * 当前处于处于活动状态的键控代码值
		 */
		public var keyCode:uint = 0;
		
		/**
		 * 在按下时触发快捷键。false表示在释放时触发快捷键
		 */
		public var keyDown:Boolean = true;
		
		/**
		 * 如果是按下时触发快捷键，那么是只触发一次还是连续触发
		 */
		public var keyDownOnce:Boolean = true;
		
		/**
		 * 触发快捷键时指定的函数。原型func(void)void
		 */
		public var execute:Function = null;
		
		// 按下时的内部计数
		internal var keyDownCount:int = 0;
		
		/**
		 * 构造函数
		 * 
		 * @param	execute
		 * @param	keyCode
		 * @param	keyDown
		 * @param	keyDownOnce
		 * @param	ctrlKey
		 * @param	shiftKey
		 * @param	altKey
		 */
		public function Shortcut(execute:Function, keyCode:uint, keyDown:Boolean = true, keyDownOnce:Boolean = true, 
			ctrlKey:Boolean = false, shiftKey:Boolean = false, altKey:Boolean = false) 
		{
			this.execute = execute;
			this.keyCode = keyCode;
			this.ctrlKey = ctrlKey;
			this.shiftKey = shiftKey;
			this.altKey = altKey;
			this.keyDown = keyDown;
			this.keyDownOnce = keyDownOnce;
		}
		
		//------------------------------------------------------------------------------------------------------------------------------------------------------
		// 实现 IComparable 接口
		//------------------------------------------------------------------------------------------------------------------------------------------------------
		
		/**
		 * 比较两个快捷键对象是否相同。如果两个快捷键对象的所有公共属性都相等，那么这两个快捷键会被视为是相同的
		 * 
		 * @param	destObj
		 * 
		 * @return	返回一个比较值，见CompareUtil中的常量定义
		 */
		public function compare(destObj:Object):int
		{
			if (destObj == null || !(destObj is Shortcut))
			{
				return CompareUtil.COMPARE_FAILURE;
			}
			else
			{
				var target:Shortcut = Shortcut(destObj);
				
				return ctrlKey == target.ctrlKey && altKey == target.altKey && shiftKey == target.shiftKey && 
					keyDown == target.keyDown && keyCode == target.keyCode && keyDownOnce == target.keyDownOnce && 
					execute == target.execute ? CompareUtil.EQUAL : CompareUtil.NOT_EQUAL;
			}
		}
		
		//------------------------------------------------------------------------------------------------------------------------------------------------------
		// 实现 IDestroy 接口
		//------------------------------------------------------------------------------------------------------------------------------------------------------
		
		public function destroy():void
		{
			execute = null;
		}
	}

}