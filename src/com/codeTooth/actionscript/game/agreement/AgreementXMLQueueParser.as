package com.codeTooth.actionscript.game.agreement
{
	public class AgreementXMLQueueParser implements IAgreementParser
	{
		public function AgreementXMLQueueParser()
		{
		}
		
		public function parse(input:Object):XML
		{
			if(input == null)
			{
				return null
			}
			
			var inputs:Vector.<Object> = Vector.<Object>(input);
			var length:uint = inputs.length;
			var result:XML = null;
			for(var i:uint = 0; i < length; i++)
			{
				var xml:XML = XML(inputs[i]);
				
				if(result == null)
				{
					result = new XML(<data/>);
					result.setName(String(xml.name()));
				}
				
				result.appendChild(xml.children());
			}
			
			return result == null ? null : new AgreementXMLParser().parse(result);
		}
		
		public function destroy():void
		{
			// Do nothing
		}
	}
}