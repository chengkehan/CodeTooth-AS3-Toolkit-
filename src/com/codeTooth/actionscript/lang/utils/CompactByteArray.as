package com.codeTooth.actionscript.lang.utils
{
	import com.codeTooth.actionscript.lang.utils.destroy.IDestroy;
	
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	import com.codeTooth.actionscript.lang.exceptions.NullPointerException;

	/**
	 * 紧凑的ByteArray。
	 * 目前只支持对Int类型的写入和读取操作。
	 * 对于Int类型的小值，使用少于4个字节的空间来存储，以此来达到压缩数据的目的。
	 * 
	 * <pre>
	 * Useage:
	 * // New object
	 * var bytes:CompactByteArray = new CompactByteArray();
	 * // Start write data
	 * bytes.startWrite();
	 * // Writing
	 * bytes.writeInt(1);
	 * bytes.writeInt(2);
	 * bytes.writeInt(3);
	 * // Output: 3(bytes) instead of 12(bytes)
	 * trace(bytes.length);
	 * // Start read data
	 * bytes.startRead();
	 * // Reading
	 * // Output: 1
	 * bytes.readInt();
	 * // Output: 2
	 * bytes.readInt();
	 * // Output: 3
	 * bytes.readInt();
	 * </pre>
	 */
	public class CompactByteArray implements IDestroy
	{
		private var _bytes:ByteArray = null;
		
		private var _position:int = 0;
		
		/**
		 * 提供给数据操作的缓冲区。
		 * 如果不提供，则会内部默认创建一个。
		 * 
		 * @param buffer
		 */
		public function CompactByteArray(buffer:ByteArray = null)
		{
			_bytes = buffer == null ? new ByteArray() : buffer;
			_bytes.endian = Endian.BIG_ENDIAN;
		}
		
		public function clear():void
		{
			_bytes.clear();
			_position = 0;
		}
		
		public function startWrite():void
		{
			_position = 0;
		}
		
		public function writeBytes(srcBytes:ByteArray, srcOffset:int, numBytes:uint):void
		{
			if(srcBytes == null)
			{
				throw new NullPointerException("Null input srcBytes parameter.");
			}
			_bytes.writeBytes(srcBytes, srcOffset, numBytes);
		}
		
		// 00000000000000000000000001111111
		// 00000000000000000011111110000000
		// 00000000000111111100000000000000
		// 00001111111000000000000000000000
		public function writeInt(value:int):void
		{
			var buffer1:int = value & 127;
			var buffer2:int = (value >>> 7) & 127;
			var buffer3:int = (value >>> 14) & 127;
			var buffer4:int = (value >>> 21) & 127;
			var buffer5:int = value >>> 28;
			if(buffer2 || buffer3 || buffer4 || buffer5)
			{
				_bytes[_position++] = 128 | buffer1;
			}
			else
			{
				_bytes[_position++] = buffer1;
			}
			if(buffer3 || buffer4 || buffer5)
			{
				_bytes[_position++] = 128 | buffer2;
			}
			else
			{
				if(buffer2)
				{
					_bytes[_position++] = buffer2;
				}
			}
			if(buffer4 || buffer5)
			{
				_bytes[_position++] = 128 | buffer3;
			}
			else
			{
				if(buffer3)
				{
					_bytes[_position++] = buffer3;
				}
			}
			if(buffer5)
			{
				_bytes[_position++] = 128 | buffer4;
				_bytes[_position++] = buffer5;
			}
			else
			{
				if(buffer4)
				{
					_bytes[_position++] = buffer4;
				}
			}
		}
		
		public function startRead():void
		{
			_position = 0;
		}
		
		public function readBytes(targetBytes:ByteArray, srcOffset:int, numBytes:int):void
		{
			if(targetBytes == null)
			{
				throw new NullPointerException("Null input targetBytes parameter.");
			}
			targetBytes.writeBytes(_bytes, srcOffset, numBytes);
		}
		
		public function readInt():int
		{
			var buffer1:int = 0;
			var buffer2:int = 0;
			var buffer3:int = 0;
			var buffer4:int = 0;
			var buffer5:int = 0;
			
			var value:int = _bytes[_position++];
			buffer1 = value & 127;
			if(value >>> 7)
			{
				value = _bytes[_position++];
				buffer2 = value & 127;
				if(value >>> 7)
				{
					value = _bytes[_position++];
					buffer3 = value & 127;
					if(value >>> 7)
					{
						value = _bytes[_position++];
						buffer4 = value & 127;
						if(value >>> 7)
						{
							value = _bytes[_position++];
							buffer5 = value;
						}
					}
				}
			}
			
			return buffer1 + (buffer2 << 7) + (buffer3 << 14) + (buffer4 << 21) + (buffer5 << 28);
		}
		
		public function get length():int
		{
			return _bytes.length;
		}
		
		public function getAsciiString():String
		{
			var str:String = "";
			var length:int = _bytes.length;
			for (var i:int = 0; i < length; i++) 
			{
				str += String.fromCharCode(_bytes[i]);
			}
			return str;
		}
		
		public function setAsciiString(str:String):void
		{
			if(str == null)
			{
				return;
			}
			var length:int = str.length;
			for (var i:int = 0; i < length; i++) 
			{
				_bytes[i] = str.charCodeAt(i);
			}
		}
		
		public function toString():String
		{
			return _bytes.toString();
		}
		
		public function destroy():void
		{
			if(_bytes != null)
			{
				_bytes.clear();
				_bytes = null;
				_position = 0;
			}
		}
	}
}