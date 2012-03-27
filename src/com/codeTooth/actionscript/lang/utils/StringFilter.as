package com.codeTooth.actionscript.lang.utils
{
	import com.codeTooth.actionscript.lang.utils.destroy.DestroyUtil;
	import com.codeTooth.actionscript.lang.utils.destroy.IDestroy;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.text.TextField;
	import flash.utils.Dictionary;
	
	/**
	 * 字符串过滤
	 */
	public class StringFilter implements IDestroy
	{
		/**
		 * 构造函数
		 * 
		 * @param	target 指定要过滤字符串的对象
		 */
		public function StringFilter(target:IEventDispatcher = null) 
		{
			initializeStrings();
			this.target = target;
		}
		
		//------------------------------------------------------------------------------------------------------------------
		// Chars
		//------------------------------------------------------------------------------------------------------------------
		
		// 存储所有需要过滤的字符串
		private var _strings:Dictionary = null;
		
		/**
		 * 添加要过滤掉的字符串
		 * 
		 * @param	str 指定的过滤字符串
		 */
		public function addStrings(...strs):void
		{
			for each(var str:Object in strs)
			{
				if (str is String)
				{
					_strings[str] = true;
				}
			}
		}
		
		/**
		 * 删除已指定的过滤字符串
		 * 
		 * @param	str 要删除的字符串
		 */
		public function removeStrings(...strs):void
		{
			var numberStrings:int = _strings.length;
			for each(var str:Object in strs)
			{
				if (str is String)
				{
					delete _strings[str];
				}
			}
		}
		
		/**
		 * 判断是否包含指定的字符串
		 * 
		 * @param	str
		 * 
		 * @return
		 */
		public function contains(str:String):Boolean
		{
			return _strings[str] != undefined;
		}
		
		private function initializeStrings():void
		{
			_strings = new Dictionary()
		}
		
		private function destroyStrings():void
		{
			if (_strings != null)
			{
				DestroyUtil.breakMap(_strings);
				_strings = null;
			}
		}
		
		//------------------------------------------------------------------------------------------------------------------
		// Target
		//------------------------------------------------------------------------------------------------------------------
		
		// 字符串过滤目标
		private var _target:IEventDispatcher = null;
		
		/**
		 * 指定一个要过滤字符串的对象
		 */
		public function set target(target:IEventDispatcher):void
		{
			destroyTarget();
			_target = target;
			_target.addEventListener(Event.CHANGE, changeHandler);
		}
		
		/**
		 * @private
		 */
		public function get target():IEventDispatcher
		{
			return _target;
		}
		
		private function changeHandler(event:Event):void
		{
			if (event.target is TextField)
			{
				var tf:TextField = TextField(event.target);
				var text:String = tf.text;
				var index:int;
				var changed:Boolean;
				while (true)
				{
					changed = false;
					for (var str:String in _strings)
					{
						if ((index = text.indexOf(str)) != -1)
						{
							changed = true;
							text = text.substring(0, index) + text.substring(index + str.length, text.length);
						}
					}
					
					if (!changed)
					{
						break;
					}
				}
				
				tf.text = text;
			}
		}
		
		private function destroyTarget():void
		{
			if (_target != null)
			{
				_target.removeEventListener(Event.CHANGE, changeHandler);
				_target = null;
			}
		}
		
		//------------------------------------------------------------------------------------------------------------------
		// 实现 IDestroy 接口
		//------------------------------------------------------------------------------------------------------------------
		
		/**
		 * @private
		 */
		public function destroy():void
		{
			destroyTarget();
			destroyStrings();
		}
	}

}