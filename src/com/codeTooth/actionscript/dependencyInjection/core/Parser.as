package com.codeTooth.actionscript.dependencyInjection.core   
{		
	import com.adobe.utils.StringUtil;
	import com.codeTooth.actionscript.lang.exceptions.IllegalOperationException;
	import com.codeTooth.actionscript.lang.exceptions.IndexOutOfBoundsException;
	import com.codeTooth.actionscript.lang.exceptions.NullPointerException;
	import com.codeTooth.actionscript.lang.exceptions.UnknownTypeException;
	
	import flash.utils.Dictionary;
	
	/**
	 * @private
	 * 
	 * 把加载的注入xml解析成指定的对象
	 */
	internal class Parser
	{
		public function Parser()
		{
			
		}
		
		/**
		 * 开始解析指定的xml
		 * 
		 * @param diXML 指定的xml
		 *
		 * @throws com.codeTooth.actionscript.lang.exceptions.NullPointerException 
		 * 指定的xml是null
		 * @throws com.codeTooth.actionscript.lang.exceptions.UnknownTypeException 
		 * 缺少id或type或attribute的长度不符合要求
		 * @throws com.codeTooth.actionscript.lang.exceptions.IllegalOperationException
		 * 存在重复的id 
		 *  
		 * @return 
		 */		
		public function parse(diXML:XML):Dictionary/*of Item*/
		{
			if(diXML == null)
			{
				throw new NullPointerException("Null di xml");
			}
			
			var dictionary:Dictionary = new Dictionary();
			
			if(diXML.item != undefined)
			{
				var itemsList:XMLList = diXML.item;
				var item:Item = null;
				
				var constructorArgumentsList:XMLList = null;
				var constructorArguments:Array = null;
				
				var contentsList:XMLList = null;
				var content:Content = null;
				var contents:Array = null;
				var contentAttributesList:XMLList = null;
				 
				//解析所有的item
				for each(var itemXML:XML in itemsList)
				{
					if(itemXML.@id == undefined)
					{
						throw new UnknownTypeException("Item has not id");
					}
					
					if(itemXML.@type == undefined)
					{
						throw new UnknownTypeException("Item " + "\"" + String(itemXML.@id) + "\"" + " has not type");
					}
					
					item = new Item();
					item.id = String(itemXML.@id);
					item.type = String(itemXML.@type);
					item.constructorType = itemXML.@constructorType == undefined ? Item.CONSTRUCTOR_TYPE_NEW : String(itemXML.@constructorType);
					item.isSingle = itemXML.@isSingle == undefined ? false : StringUtil.toBoolean(String(itemXML.@isSingle));
					item.isReinject = itemXML.@isReinject == undefined ? true : StringUtil.toBoolean(String(itemXML.@isReinject));
					
					//解析构造函数参数
					if(itemXML.constructorArgument != undefined)
					{
						constructorArguments = new Array();
						constructorArgumentsList = itemXML.constructorArgument;
						for each(var constructorArgumentXML:XML in constructorArgumentsList)
						{
							constructorArguments.push(parseDiObject(constructorArgumentXML, 0, false))
						}
						item.constructorArguments = constructorArguments;
					}
					
					//解析item中发的所有content
					if(itemXML.content != undefined)
					{
						contentsList = itemXML.content;
						contents = new Array();
						for each(var contentXML:XML in contentsList)
						{
							content = new Content();
							contentAttributesList = contentXML.attributes();
							//content的attribute只能是1个或两个
							//否则抛出异常
							if(contentAttributesList.length() == 1)
							{
								content.child1 = parseDiObject(contentXML, 0, true);
							}
							else if(contentAttributesList.length() == 2)
							{
								content.child1 = parseDiObject(contentXML, 0, false);
								content.child2 = parseDiObject(contentXML, 1, true);
							}
							else
							{
								throw new UnknownTypeException("Content attributes length : " + contentAttributesList.length());
							}
							contents.push(content);
							item.contents = contents;
						}
					}
					
					//不能有重复的id
					//否则抛出异常
					if(dictionary[item.id] != undefined)
					{
						throw new IllegalOperationException("Has the same id \"" + item.id + "\"");
					}
					else
					{
						dictionary[item.id] = item;
					}
				}
			}
			
			return dictionary;
		}
		
		
		/**
		 * @private
		 * 
		 * 将指定的xml节点解析程diObject对象
		 *  
		 * @param xml 	指定的xml
		 * @param index xml的attribute的索引
		 * @param isParseChildren 是否递归解析所有的children	
		 * 
		 * @throws com.codeTooth.actionscript.lang.exceptions.IndexOutOfBoundsException
		 * 
		 * @return 
		 */
		private function parseDiObject(xml:XML, index:int, isParseChildren:Boolean):DiObject
		{
			var diObject:DiObject = new DiObject();
			var attributesList:XMLList = xml.attributes();
			
			if(index >= attributesList.length())
			{
				throw new IndexOutOfBoundsException("Attributes length/index : " + attributesList.length() + "/" + index);
			}
			
			var attributeXML:XML = attributesList[index];
			diObject.type = String(attributeXML.name());
			diObject.content = String(attributeXML);
			
			if(isParseChildren && xml.children().length() != 0)
			{
				var childrenList:XMLList = xml.children();
				var children:Array = new Array();
				for each(var childXML:XML in childrenList)
				{
					children.push(parseDiObject(childXML, 0, true));
				}
				diObject.children = children;
			}
			
			return diObject;
		}
	}
}