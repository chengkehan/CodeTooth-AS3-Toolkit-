package com.codeTooth.actionscript.lang.utils.serialize.binaryTable
{
	import flash.utils.ByteArray;

	/**
	 * 二进制的表。
	 * 协议xml形式的表格，在发布的时候，如果能使用二进制的形式进行存储，那么将会更有效率。
	 * 这里提供最基本的形式读取和写入表格中的数据
	 */
	public class BinaryTable
	{
		/**
		 * 获得读取器
		 * 
		 * @param bytes 存储了数据的字节数组
		 * 
		 * @return 
		 */
		public static function getBinaryRead(bytes:ByteArray):BinaryRead
		{
			return new BinaryRead(bytes);
		}
		
		/**
		 * 获得写入器
		 * 
		 * @param bytes 将要用来存储数据的字节数组
		 * @param filedTypes 每个字段的类型。详见Type.as
		 * 
		 * @return 
		 */
		public static function getBinaryWrite(bytes:ByteArray, filedTypes:Vector.<int>):BinaryWrite
		{
			return new BinaryWrite(bytes, filedTypes);
		}
	}
}