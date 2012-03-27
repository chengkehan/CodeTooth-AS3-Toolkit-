package com.codeTooth.actionscript.algorithm.verify
{
	import com.codeTooth.actionscript.lang.exceptions.IllegalParameterException;
	import com.codeTooth.actionscript.lang.exceptions.NullPointerException;
	
	import flash.utils.ByteArray;

	/**
	 * 奇偶校验
	 */
	public class ParityCheck
	{
		/**
		 * 奇偶校验的位长度。
		 * 数据被奇偶校验封包后，会增加这里指定的尺寸，增加的位被用来奇偶校验。
		 * 数据被奇偶校验解包后，会减少这里指定的尺寸。
		 */
		public static const PARITY_CHECK_BYTE_LENGTH:uint = 1;
		
		/**
		 * 使用奇校验算法封包数据
		 * 
		 * @param data
		 * 
		 * @return 返回封包后的数据
		 */
		public static function OddParityCheckPack(data:ByteArray):ByteArray
		{
			checkNull(data);
			data.position = data.length;
			data.writeByte(hasEvenBitOne(data) ? 1 : 0);
			
			return data;
		}
		
		/**
		 * 使用奇校验算法解包数据
		 * 
		 * @param data
		 * 
		 * @return 返回解包后的数据。如果解包失败，返回null
		 */
		public static function OddParityCheckUnpack(data:ByteArray):ByteArray
		{
			checkNull(data);
			
			if(data.length < PARITY_CHECK_BYTE_LENGTH)
			{
				throw new IllegalParameterException("Illegal data size \"" + data.length + "\"");
			}
			
			if(hasEvenBitOne(data))
			{
				return null;
			}
			else
			{
				data.length -= PARITY_CHECK_BYTE_LENGTH;
				return data;
			}
		}
		
		/**
		 * 使用偶校验算法封包数据
		 * 
		 * @param data
		 * 
		 * @return 返回封包后的数据
		 */
		public static function evenParityCheckPack(data:ByteArray):ByteArray
		{
			checkNull(data);
			data.position = data.length;
			data.writeByte(hasEvenBitOne(data) ? 0 : 1);
			
			return data;
		}
		
		/**
		 * 使用偶校验算法解包数据
		 * 
		 * @param data
		 * 
		 * @return 返回解包后的数据。如果解包失败，返回null
		 */
		public static function evenParityCheckUnpack(data:ByteArray):ByteArray
		{
			checkNull(data);
			
			if(data.length < PARITY_CHECK_BYTE_LENGTH)
			{
				throw new IllegalParameterException("Illegal data size \"" + data.length + "\"");
			}
			
			if(hasEvenBitOne(data))
			{
				data.length -= PARITY_CHECK_BYTE_LENGTH;
				return data;
			}
			else
			{
				return null;
			}
			
			return data;
		}
		
		// 判断指定数据中，位为1的总是是否是偶数个
		// 把每个位依次进行异或，如果最后结果是0，就表示有偶数个bit1，如果最后结果是1就表示有奇数个bit1
		private static function hasEvenBitOne(data:ByteArray):Boolean
		{
			var xor:uint = 0;
			var size:uint = data.length;
			var byte:uint;
			var bitMask:uint;
			// 读取每个字节
			for(var i:uint = 0; i < size; i++)
			{
				bitMask = 1;
				byte = data[i];
				// 利用位掩码，依次异或当前字节中每一个位
				for(var j:uint = 0; j < 8; j++)
				{
					xor ^= ((byte & (bitMask << j)) >>> j);
				}
			}
			
			return xor == 0;
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