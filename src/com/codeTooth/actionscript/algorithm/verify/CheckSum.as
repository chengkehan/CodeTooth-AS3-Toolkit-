package com.codeTooth.actionscript.algorithm.verify
{
	import com.codeTooth.actionscript.lang.exceptions.IllegalParameterException;
	import com.codeTooth.actionscript.lang.exceptions.NullPointerException;
	
	import flash.utils.ByteArray;

	/**
	 * 校验和。
	 * 在指定的数据后追加一定的字节，追加的字节所表示的数和指定数据中所有字节总和的和为零。
	 * 在较多的数据上Short校验和比Byte校验和更好。
	 */
	public class CheckSum
	{
		/**
		 * Byte校验和算法追加的字节长度
		 */
		public static const CHECK_SUM_BYTE_BYTE_LENGTH:uint = 2;
		
		/**
		 * Short校验和算法追加的字节长度
		 */
		public static const CHECK_SUM_SHORT_BYTE_LENGTH:uint = 4;
		
		private static var _tempBytes:ByteArray = new ByteArray();
		
		/**
		 * Byte校验和算法打包数据
		 * 
		 * @param data
		 * 
		 * @return 
		 */
		public static function checkSumBytePack(data:ByteArray):ByteArray
		{
			checkNull(data);
			data.position = data.length;
			data.writeShort(-getByteSum(data));
			
			return data;
		}
		
		/**
		 * Byte校验和算法解包数据
		 * 
		 * @param data
		 * 
		 * @return 返回解包后的数据，如果解包失败返回null
		 */
		public static function checkSumByteUnpack(data:ByteArray):ByteArray
		{
			checkNull(data);
			
			if(data.length < CHECK_SUM_BYTE_BYTE_LENGTH)
			{
				throw new IllegalParameterException("Illegal data size \"" + data.length + "\"");
			}
			
			data.position = data.length - CHECK_SUM_BYTE_BYTE_LENGTH;
			var oldSum:int = data.readShort();
			data.length -= CHECK_SUM_BYTE_BYTE_LENGTH;
			var newSum:uint = getByteSum(data);
			
			if(newSum + oldSum == 0)
			{
				data.position = data.length;
				return data;
			}
			else
			{
				return null;
			}
		}
		
		// 获得Byte校验和
		// 将数据的每一个字节相加后对256取模
		private static function getByteSum(data:ByteArray):uint
		{
			_tempBytes.clear();
			var size:uint = data.length;
			var sum:uint = 0;
			for(var i:uint = 0; i < size; i++)
			{
				sum += data[i];
			}
			
			_tempBytes.writeByte(sum);
			_tempBytes.position = 0;
			return _tempBytes.readUnsignedByte();
		}
		
		/**
		 * Short校验和算法打包数据
		 * 
		 * @param data
		 * 
		 * @return 
		 */
		public static function checkSumShortPack(data:ByteArray):ByteArray
		{
			checkNull(data);
			data.position = data.length;
			data.writeInt(-getShortSum(data));
			
			return data;
		}
		
		/**
		 * Short校验和算法解包数据
		 * 
		 * @param data
		 * 
		 * @return 返回解包后的数据，如果解包失败返回null
		 */
		public static function checkSumShortUnpack(data:ByteArray):ByteArray
		{
			checkNull(data);
			
			if(data.length < CHECK_SUM_SHORT_BYTE_LENGTH)
			{
				throw new IllegalParameterException("Illegal data size \"" + data.length + "\"");
			}
			
			data.position = data.length - CHECK_SUM_SHORT_BYTE_LENGTH;
			var oldSum:int = data.readInt();
			data.length -= CHECK_SUM_SHORT_BYTE_LENGTH;
			var newSum:uint = getShortSum(data);
			
			if(oldSum + newSum == 0)
			{
				data.position = data.length;
				return data;
			}
			else
			{
				return null;
			}
		}
		
		// 获得Short校验和
		// 把数据的每一个字节相加后对65536取模
		private static function getShortSum(data:ByteArray):uint
		{
			_tempBytes.clear();
			var size:uint = data.length;
			var sum:uint = 0;
			for(var i:uint = 0; i < size; i++)
			{
				sum += data[i];
			}
			
			_tempBytes.writeShort(sum);
			_tempBytes.position = 0;
			return _tempBytes.readUnsignedShort();
		}
		
		private static function checkNull(data:ByteArray):void
		{
			if(data == null)
			{
				throw new NullPointerException("Null data");
			}
		}
	}
}