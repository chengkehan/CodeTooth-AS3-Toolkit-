package com.codeTooth.actionscript.air.template.application.baby.util.notify
{
	/**
	 * @private
	 * 
	 * 主题消息数据
	 */
	public class NotifyData
	{
		private var _reason:String = null;
		
		protected var _data:Object = null;
		
		public function NotifyData(reason:String, data:Object = null)
		{
			_reason = reason;
			_data = data;
		}
		
		public function get reason():String
		{
			return _reason;
		}
		
		public function setData(data:Object):void
		{
			_data = data;
		}
	}
}