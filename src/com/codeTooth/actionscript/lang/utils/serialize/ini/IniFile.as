package com.codeTooth.actionscript.lang.utils.serialize.ini
{
	import com.adobe.utils.StringUtil;
	import com.codeTooth.actionscript.lang.utils.Common;
	import com.codeTooth.actionscript.lang.utils.destroy.DestroyUtil;
	import com.codeTooth.actionscript.lang.utils.destroy.IDestroy;
	import com.codeTooth.actionscript.lang.utils.serialize.ISerializable;

	public class IniFile implements IDestroy, ISerializable
	{
		private var _newLine:String = Common.NEW_LINE_N;

		private var _lines:Vector.<IniFileLine> = null;
		
		public function IniFile()
		{
			_lines = new Vector.<IniFileLine>();
		}
		
		public function get newLine():String
		{
			return _newLine;
		}
		
		public function set newLine(value:String):void
		{
			_newLine = value;
		}

		public function getValue(key:String):*
		{
			for each(var line:IniFileLine in _lines)
			{
				if(line.isComment)
				{
					continue;
				}
				
				if(line.key == key)
				{
					return line.value;
				}
			}
			
			return null;
		}
		
		public function setValue(key:String, value:Object):Boolean
		{
			for each(var line:IniFileLine in _lines)
			{
				if(line.isComment)
				{
					continue;
				}
				
				if(line.key == key)
				{
					line.value = String(value);
					return true;
				}
			}
			
			return false;
		}
		
		public function containsValue(key:String):Boolean
		{
			for each(var line:IniFileLine in _lines)
			{
				if(line.isComment)
				{
					continue;
				}
				
				if(line.key == key)
				{
					return true;
				}
			}
			
			return false;
		}
		
		public function deserialize(data:Object):Boolean
		{
			DestroyUtil.breakVector(_lines);
			var input:String = String(data);
			var inputLines:Array = input.split(_newLine);
			for each(var inputLine:String in inputLines)
			{
				if(StringUtil.trim(inputLine) == Common.EMPTY_STRING)
				{
					continue;	
				}
				
				if(inputLine.charAt(0) == Common.SHARP)
				{
					_lines.push(new IniFileLine(true, null, inputLine));
				}
				else
				{
					var values:Array = inputLine.split(Common.EQUAL);
					_lines.push(new IniFileLine(false, values[0], values[1]));
				}
			}
			
			return false;
		}

		public function serialize():*
		{
			var output:String = Common.EMPTY_STRING;
			var numLines:uint = _lines.length;
			for (var i:int = 0; i < numLines; i++) 
			{
				var line:IniFileLine = _lines[i];
				
				if(line.isComment)
				{
					output += line.value;
				}
				else
				{
					output += line.key + Common.EQUAL + line.value;
				}
				
				if(i != numLines - 1)
				{
					output += _newLine;
				}
			}
			
			return output;
		}

		public function destroy():void
		{
			DestroyUtil.breakVector(_lines);
			_lines = null;
		}
	}
}