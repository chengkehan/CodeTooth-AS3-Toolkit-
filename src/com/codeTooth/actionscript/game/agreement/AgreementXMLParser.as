package com.codeTooth.actionscript.game.agreement
{
	import com.codeTooth.actionscript.lang.exceptions.NoSuchObjectException;

	/**
	 * 协议XML解析器
	 */
	public class AgreementXMLParser implements IAgreementParser
	{
		public function AgreementXMLParser()
		{
			
		}
		
		//----------------------------------------------------------------------------------------------------------------------------------
		// 实现 IAgreementParser 接口
		//----------------------------------------------------------------------------------------------------------------------------------
		
		/**
		 * 解析加载的协议，使之成为可以识别的XML结构
		 * 
		 * @param input
		 * 
		 * @return 
		 */
		public function parse(input:Object):XML
		{
			if(input == null)
			{
				return null;
			}
			
			// 把struct节点，使用数据替换掉
			// 原先的struct节点是为了减少协议xml中的重复而设计的
			var xml:XML = XML(input);
			var structXMLList:XMLList = xml.struct;
			var agreementXMLList:XMLList = xml.agreement;
			
			for each(var agreementXML:XML in agreementXMLList)
			{
				includeStruct(agreementXML, structXMLList);
			}
			
			return xml;
		}
		
		private function includeStruct(xml:XML, structXMLList:XMLList):void
		{
			var children:XMLList = xml.children();
			var numChildren:uint = children.length();
			
			outerLoop:for(var i:uint = 0; i < numChildren; i++)
			{
				var child:XML = children[i];
				if(String(child.name()) == "struct")
				{
					var structID:String = String(child.@id);
					for each(var structXML:XML in structXMLList)
					{
						if(structID == String(structXML.@id))
						{
							xml.insertChildAfter(child, structXML.children().copy());
							delete children[i];
							
							includeStruct(xml, structXMLList);
							
							break outerLoop;
						}
					}
					
					throw new NoSuchObjectException("Has not the struct \"" + structID + "\"");
				}
				else
				{
					includeStruct(child, structXMLList);
				}
			}
		}
		
		//----------------------------------------------------------------------------------------------------------------------------------
		// 实现 IDestroy 接口
		//----------------------------------------------------------------------------------------------------------------------------------
		
		public function destroy():void
		{
			
		}
	}
}