package com.codeTooth.actionscript.data 
{
	import com.codeTooth.actionscript.lang.utils.destroy.DestroyUtil;
	import com.codeTooth.actionscript.lang.utils.destroy.IDestroy;
	import flash.utils.Dictionary;
	
	public class XMLDataNode implements IDestroy
	{
		
		public function XMLDataNode() 
		{
			
		}
		
		//---------------------------------------------------------------------------------------------------------
		// Properties
		//---------------------------------------------------------------------------------------------------------
		
		private var _properties:Dictionary = null;
		
		public function setProperty(name:String, value:String):void
		{
			if (_properties == null)
			{
				_properties = new Dictionary();
			}
			
			_properties[name] = value;
		}
		
		public function getProperty(name:String):String
		{
			return _properties == null ? null : _properties[name];
		}
		
		public function get properties():Dictionary
		{
			return _properties;
		}
		
		private function destroyProperties():void
		{
			if (_properties != null)
			{
				DestroyUtil.breakMap(_properties);
				_properties = null;
			}
		}
		
		//---------------------------------------------------------------------------------------------------------
		// Children
		//---------------------------------------------------------------------------------------------------------
		
		private var _children:Vector.<XMLDataNode> = null;
		
		public function addChild(node:XMLDataNode):XMLDataNode
		{
			if (_children == null)
			{
				_children = new Vector.<XMLDataNode>();
			}
			
			_children.push(node);
			
			return node;
		}
		
		public function get children():Vector.<XMLDataNode>
		{
			return _children;
		}
		
		private function destroyChildren():void
		{
			if (_children != null)
			{
				var child:XMLDataNode;
				var numberChildren:int = _children.length;
				for (var i:int = 0; i < numberChildren; i++) 
				{
					child = _children[i];
					child.destroy();
					_children[i] = null;
				}
				_children.length = 0;
				_children = null;
			}
		}
		
		//---------------------------------------------------------------------------------------------------------
		// parent
		//---------------------------------------------------------------------------------------------------------
		
		private var _parent:XMLDataNode = null;
		
		public function set parent(node:XMLDataNode):void
		{
			_parent = node;
		}
		
		public function get parent():XMLDataNode
		{
			return _parent;
		}
		
		private function destroyParent():void
		{
			_parent = null;
		}
		
		//---------------------------------------------------------------------------------------------------------
		// Name
		//---------------------------------------------------------------------------------------------------------
		
		private var _name:String = null;
		
		public function set name(str:String):void
		{
			_name = str;
		}
		
		public function get name():String
		{
			return _name;
		}
		
		//---------------------------------------------------------------------------------------------------------
		// Content
		//---------------------------------------------------------------------------------------------------------
		
		private var _content:String = null;
		
		public function set content(str:String):void
		{
			_content = str;
		}
		
		public function get content():String
		{
			return _content;
		}
		
		//---------------------------------------------------------------------------------------------------------
		// 实现 IDestroy 接口
		//---------------------------------------------------------------------------------------------------------
		
		public function destroy():void
		{
			destroyChildren();
			destroyParent();
			destroyProperties();
		}
		
		//---------------------------------------------------------------------------------------------------------
		// ToString
		//---------------------------------------------------------------------------------------------------------
		
		public function toString():String
		{
			return "[object XMLDataNode(name:" + _name + ",content:" + _content + ")]";
		}
	}

}