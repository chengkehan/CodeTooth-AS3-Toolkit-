package com.codeTooth.actionscript.lang.utils.serialize.binaryTable
{
	import com.codeTooth.actionscript.lang.exceptions.NullPointerException;
	import com.codeTooth.actionscript.lang.utils.destroy.DestroyUtil;
	import com.codeTooth.actionscript.lang.utils.destroy.IDestroy;
	
	import flash.utils.ByteArray;

	public class BinaryRead implements IDestroy
	{
		private var _bytes:ByteArray = null;
		
		private var _read:Read = null;
		
		private var _fieldTypes:Vector.<int> = null;
		
		private var _lineCache:Array = null;
		
		public function BinaryRead(bytes:ByteArray)
		{
			if(bytes == null)
			{
				throw new NullPointerException("Null input bytes parameter.");
			}
			_bytes = bytes;
			_read = new Read(bytes);
			_lineCache = new Array();
			
			var numFields:uint = _read.readValue(Type.UINT);
			_fieldTypes = new Vector.<int>();
			for(var i:int = 0; i < numFields; i++)
			{
				_fieldTypes.push(_read.readValue(Type.BYTE));
			}
		}
		
		public function getBytes():ByteArray
		{
			return _read.getBytes();
		}
		
		public function readHeads():Vector.<String>
		{
			var heads:Vector.<String> = new Vector.<String>();
			var numFields:uint = _fieldTypes.length;
			for (var i:int = 0; i < numFields; i++) 
			{
				heads.push(_read.readValue(Type.STRING));
			}
			
			return heads;
		}
		
		public function readNumLines():uint
		{
			return _read.readValue(Type.UINT);
		}
		
		public function readLine():Array
		{
			var numFields:uint = _fieldTypes.length;
			for (var i:int = 0; i < numFields; i++) 
			{
				_lineCache[i] = _read.readValue(_fieldTypes[i]);
			}
			
			return _lineCache;
		}
		
		public function destroy():void
		{
			DestroyUtil.destroyObject(_read);
			_read = null;
			_lineCache = null;
		}
	}
}