package com.codeTooth.actionscript.lang.utils.serialize.binaryTable
{
	import com.codeTooth.actionscript.lang.utils.destroy.IDestroy;
	
	import flash.utils.ByteArray;
	import com.codeTooth.actionscript.lang.exceptions.IllegalParameterException;
	import com.codeTooth.actionscript.lang.exceptions.NullPointerException;

	internal class Write implements IDestroy
	{
		private var _bytes:ByteArray = null;
		
		private var _operator:Array = null;
		
		public function Write(bytes:ByteArray)
		{
			if(bytes == null)
			{
				throw new NullPointerException("Null input bytes parameter.");
			}
			_bytes = bytes;
			
			_operator = new Array();
			_operator[Type.BYTE] = _bytes.writeByte;
			_operator[Type.UBYTE] = _bytes.writeByte;
			_operator[Type.SHORT] = _bytes.writeShort;
			_operator[Type.USHORT] = _bytes.writeShort;
			_operator[Type.INT] = _bytes.writeInt;
			_operator[Type.UINT] = _bytes.writeUnsignedInt;
			_operator[Type.FLOAT] = _bytes.writeFloat;
			_operator[Type.DOUBLE] = _bytes.writeDouble;
			_operator[Type.STRING] = _bytes.writeUTF;
		}
		
		public function getBytes():ByteArray
		{
			return _bytes;
		}
		
		public function writeValue(value:Object, type:int):void
		{
			var operator:Function = _operator[type];
			if(operator == null)
			{
				throw new IllegalParameterException("Illegal input type \"" + type + "\"");
			}
			operator(value);
		}
		
		public function destroy():void
		{
			_bytes = null;
		}
	}
}