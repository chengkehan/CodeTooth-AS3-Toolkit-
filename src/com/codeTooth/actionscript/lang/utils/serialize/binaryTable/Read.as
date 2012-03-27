package com.codeTooth.actionscript.lang.utils.serialize.binaryTable
{
	import com.codeTooth.actionscript.lang.utils.destroy.IDestroy;
	
	import flash.utils.ByteArray;
	import com.codeTooth.actionscript.lang.exceptions.IllegalParameterException;
	import com.codeTooth.actionscript.lang.exceptions.NullPointerException;

	internal class Read implements IDestroy
	{
		private var _bytes:ByteArray = null;
		
		private var _operator:Array = null;
		
		public function Read(bytes:ByteArray)
		{
			if(bytes == null)
			{
				throw new NullPointerException("Null input bytes parameter.");
			}
			_bytes = bytes;
			
			_operator = new Array();
			_operator[Type.BYTE] = _bytes.readByte;
			_operator[Type.UBYTE] = _bytes.readUnsignedByte;
			_operator[Type.SHORT] = _bytes.readShort;
			_operator[Type.USHORT] = _bytes.readUnsignedShort;
			_operator[Type.INT] = _bytes.readInt;
			_operator[Type.UINT] = _bytes.readUnsignedInt;
			_operator[Type.FLOAT] = _bytes.readFloat;
			_operator[Type.DOUBLE] = _bytes.readDouble;
			_operator[Type.STRING] = _bytes.readUTF;
		}
		
		public function getBytes():ByteArray
		{
			return _bytes;
		}
		
		public function readValue(type:int):*
		{
			var operator:Function = _operator[type];
			if(operator == null)
			{
				throw new IllegalParameterException("Illegal input type \"" + type + "\"");
			}
			return operator();
		}
		
		public function destroy():void
		{
			_bytes = null;
		}
	}
}