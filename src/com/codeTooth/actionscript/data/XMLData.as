package com.codeTooth.actionscript.data 
{
	import com.codeTooth.actionscript.lang.utils.destroy.IDestroy;
	
	public class XMLData implements IDestroy
	{
		/**
		 * 递归的将XML转换成对象形式
		 */
		public function XMLData() 
		{
			
		}
		
		//---------------------------------------------------------------------------------------------------------
		// Nodes
		//---------------------------------------------------------------------------------------------------------
		
		// 根节点
		private var _root:XMLDataNode = null;
		
		public function get root():XMLDataNode
		{
			return _root
		}
		
		/**
		 * 获得指定名称的所有节点
		 * 
		 * @param	name
		 * 
		 * @return 没有找到返回长度为零的集合，如果没有找到根返回null
		 */
		public function getNodesByName(name:String):Vector.<XMLDataNode>
		{
			var nodes:Vector.<XMLDataNode> = null;
			if (_root != null)
			{
				nodes = new Vector.<XMLDataNode>();
				getNodesByNameRecursive(name, _root, nodes);
			}
			
			return nodes;
		}
		
		private function getNodesByNameRecursive(name:String, node:XMLDataNode, collection:Vector.<XMLDataNode>):void
		{
			if (node.name == name)
			{
				collection.push(node);
			}
			
			for each(var child:XMLDataNode in node.children)
			{
				getNodesByNameRecursive(name, child, collection);
			}
		}
		
		/**
		 * 获得指定属性的所有节点
		 * 
		 * @param	propName
		 * @param	propValue
		 * 
		 * @return 没有找到返回长度为零的集合，如果没有找到根返回null
		 */
		public function getNodesByProperty(propName:String, propValue:String):Vector.<XMLDataNode>
		{
			var nodes:Vector.<XMLDataNode> = null;
			if (_root != null)
			{
				nodes = new Vector.<XMLDataNode>();
				getNodesByPropertyRecursive(propName, propValue, _root, nodes);
			}
			
			return nodes;
		}
		
		private function getNodesByPropertyRecursive(propName:String, propValue:String, node:XMLDataNode, collection:Vector.<XMLDataNode>):void
		{
			if (node.getProperty(propName) == propValue)
			{
				collection.push(node);
			}
			
			for each(var child:XMLDataNode in node.children)
			{
				getNodesByPropertyRecursive(propName, propValue, child, collection);
			}
		}
		
		private function destroyRoot():void
		{
			if (_root != null)
			{
				_root.destroy();
				_root = null;
			}
		}
		
		//---------------------------------------------------------------------------------------------------------
		// 解析 XML 数据
		//---------------------------------------------------------------------------------------------------------
		
		public function parse(xml:XML):XML
		{
			destroyRoot();
			
			if (xml != null)
			{
				_root = parseNode(xml, null)
			}
			
			return xml;
		}
		
		private function parseNode(xml:XML, parent:XMLDataNode):XMLDataNode
		{
			var node:XMLDataNode = new XMLDataNode();
			node.parent = parent;
			node.name = String(xml.name());
			
			if (parent != null)
			{
				parent.addChild(node);
			}
			
			var attributesXMLList:XMLList = xml.attributes();
			for each(var attributeXML:XML in attributesXMLList)
			{
				node.setProperty(String(attributeXML.name()), String(attributeXML));
			}
			
			
			if (xml.hasComplexContent())
			{
				var childrenXMLList:XMLList = xml.children();
				for each(var childXML:XML in childrenXMLList)
				{
					parseNode(childXML, node);
				}
			}
			else
			{
				node.content = String(xml);
			}
			
			return node;
		}
		
		//---------------------------------------------------------------------------------------------------------
		// 实现 IDestroy 接口
		//---------------------------------------------------------------------------------------------------------
		
		public function destroy():void
		{
			destroyRoot();
		}
		
		//---------------------------------------------------------------------------------------------------------
		// ToString
		//---------------------------------------------------------------------------------------------------------
		
		public function toString():String
		{
			if (_root == null)
			{
				return "Empty XML data";
			}
			else
			{
				var str:String = nodeToString("", _root, "");
				
				return str;
			}
		}
		
		private function nodeToString(prefix:String, node:XMLDataNode, str:String):String
		{
			str += prefix + node.toString() + "\n";
			
			for each(var child:XMLDataNode in node.children)
			{
				str = nodeToString(prefix + "	", child, str);
			}
			
			return str;
		}
	}

}