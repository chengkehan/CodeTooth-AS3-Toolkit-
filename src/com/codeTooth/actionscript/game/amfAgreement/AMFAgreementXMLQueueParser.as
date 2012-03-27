package com.codeTooth.actionscript.game.amfAgreement
{
	/**
	 * XML队列解析器，将多个XML协议数据合并成一个XML。
	 */
	public class AMFAgreementXMLQueueParser implements IAMFAgreementParser
	{
		public function AMFAgreementXMLQueueParser()
		{
		}
		
		/**
		 * 开始解析
		 * 
		 * @param data 是一个Vector.<Object>类型的集合，集合中的每一个元素是一个XML或者可被转换成XML的对象。
		 * 
		 * @return 
		 */
		public function parse(data:Object):XML
		{
			if(data == null)
			{
				return null;
			}
			
			var result:XML = null;
			var input:Vector.<Object> = Vector.<Object>(data);
			var length:uint = input.length;
			for(var i:uint = 0; i < length; i++)
			{
				var xml:XML = XML(input[i]);
				
				if(result == null)
				{
					result = new XML(<data/>);
					result.setName(String(result.name()));
				}
				
				result.appendChild(xml.children());
			}
			
			return result;
		}
		
		/**
		 * @inheritDoc
		 */
		public function destroy():void
		{
			// Do nothing
		}
	}
}