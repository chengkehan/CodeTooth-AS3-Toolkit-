package com.codeTooth.actionscript.lang.utils.serialize.binaryTable
{
	import com.codeTooth.actionscript.lang.utils.destroy.DestroyUtil;
	import com.codeTooth.actionscript.lang.utils.destroy.IDestroy;
	
	import flash.utils.ByteArray;
	import com.codeTooth.actionscript.lang.exceptions.NullPointerException;
	import com.codeTooth.actionscript.lang.exceptions.IllegalParameterException;

	public class BinaryWrite implements IDestroy
	{
		private var _write:Write = null;
		
		private var _fieldTypes:Vector.<int> = null;
		
		public function BinaryWrite(bytes:ByteArray, fieldTypes:Vector.<int>)
		{
			if(bytes == null)
			{
				throw new NullPointerException("Null input bytes parameter.");
			}
			if(fieldTypes == null)
			{
				throw new NullPointerException("Null input fieldTypes parameter.");
			}
			_write = new Write(bytes);
			_fieldTypes = fieldTypes;
			
			_write.writeValue(_fieldTypes.length, Type.UINT);
			for each(var fieldType:int in _fieldTypes)
			{
				_write.writeValue(fieldType, Type.UBYTE);
			}
		}
		
		public function getBytes():ByteArray
		{
			return _write.getBytes();
		}
		
		public function writeHeads(heads:Vector.<String>):void
		{
			if(heads == null)
			{
				throw new NullPointerException("Null input heads parameter.");
			}
			if(heads.length != _fieldTypes.length)
			{
				throw new IllegalParameterException("Illegal length, heads length \"" + heads.length + "\", fieldTypes length \"" + _fieldTypes.length + "\", not equal.");
			}
			
			for each(var head:String in heads)
			{
				_write.writeValue(head, Type.STRING);
			}
		}
		
		public function writeNumLines(numLines:uint):void
		{
			_write.writeValue(numLines, Type.UINT);
		}
		
		public function writeLine(line:Array):void
		{
			if(line == null)
			{
				throw new NullPointerException("Null input line parameter.");
			}
			if(line.length != _fieldTypes.length)
			{
				throw new IllegalParameterException("Illegal length, line length \"" + line.length + ", fieldTypes length \"" + _fieldTypes.length + "\", not equal.");
			}
			
			var index:int = 0;
			for each(var fieldType:int in _fieldTypes)
			{
				_write.writeValue(line[index], fieldType);
				index++;
			}
		}
		
		public function destroy():void
		{
			DestroyUtil.destroyObject(_write);
			_write = null;
		}
	}
}