package com.codeTooth.actionscript.message
{
	import com.codeTooth.actionscript.lang.exceptions.IllegalParameterException;
	import com.codeTooth.actionscript.lang.exceptions.NullPointerException;
	import com.codeTooth.actionscript.lang.utils.destroy.DestroyUtil;
	import com.codeTooth.actionscript.lang.utils.destroy.IDestroy;
	
	import flash.utils.Dictionary;

	public class MessageObserverUpdateUtil implements IDestroy
	{
		private var _functionMap:Dictionary = null;
		
		public function MessageObserverUpdateUtil()
		{
			_functionMap = new Dictionary();
		}
		
		public function addMessageFunction(messageID:MessageID, func:Function/*func(data:Type)*/):void
		{
			if(messageID == null)
			{
				throw new NullPointerException("Null messageID");
			}
			if(func == null)
			{
				throw new NullPointerException("Null function");
			}
			if(func.length > 1)
			{
				throw new IllegalParameterException("Illegal function parameter length.Should be 0 or 1 parameter.");
			}
			
			_functionMap[messageID] = func;
		}
		
		public function removeMessageFunction(messageID:MessageID):Function
		{
			var func:Function = _functionMap[messageID];
			delete _functionMap[messageID];
			
			return func;
		}
		
		public function containsMessageFunction(messageID:MessageID):Boolean
		{
			return _functionMap[messageID] != null;
		}
		
		public function getMessageFunction(messageID:MessageID):Function
		{
			return _functionMap[messageID];
		}
		
		public function update(data:MessageNotifyData = null):void
		{
			if(data == null || data.messageID == null)
			{
				return;
			}
			
			if(_functionMap[data.messageID] == null)
			{
				return;
			}
			
			var func:Function = _functionMap[data.messageID];
			if(func.length == 0)
			{
				func();
			}
			// func.length == 1
			else
			{
				func(data);
			}
		}
		
		//----------------------------------------------------------------------------------------------------------------------------------
		// 实现 IDestroy 接口
		//----------------------------------------------------------------------------------------------------------------------------------
		
		public function destroy():void
		{
			DestroyUtil.breakMap(_functionMap);
			_functionMap = null;
		}
		
	}
}