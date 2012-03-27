package com.codeTooth.actionscript.game.amfAgreement
{
	/**
	 * 将传入的XML转换成可以识别的协议XML
	 */
	public class AMFAgreementXMLParser implements IAMFAgreementParser
	{
		public function AMFAgreementXMLParser()
		{
			// Do nothing
		}
		
		public function parse(data:Object):XML
		{
			return XML(data);
		}
		
		public function destroy():void
		{
			// Do nothing
		}
	}
}