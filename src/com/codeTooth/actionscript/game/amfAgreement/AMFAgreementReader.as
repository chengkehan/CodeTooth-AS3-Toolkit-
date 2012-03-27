package com.codeTooth.actionscript.game.amfAgreement
{
	import com.codeTooth.actionscript.lang.exceptions.NullPointerException;
	
	import flash.utils.ByteArray;

	/**
	 * @private
	 * 
	 * 协议数据读取器
	 */
	internal class AMFAgreementReader
	{
		/**
		 * 开始读取AMF协议数据
		 * 
		 * @param buffer 字节数组缓冲区
		 * 
		 * @return 返回读取到的对象
		 */
		public static function read(buffer:ByteArray):Object
		{
			if(buffer == null)
			{
				throw new NullPointerException("Null buffer");
			}
			
			// 读取head
			readHead(buffer);
			// 读取id
			readAgreementID(buffer);
			// 读取length
			readLength(buffer);
			
			// 读取AMF
			return buffer.readObject();
		}
		
		public static function readHead(buffer:ByteArray):uint
		{
			return buffer.readUnsignedByte();
		}
		
		public static function readAgreementID(buffer:ByteArray):uint
		{
			return buffer.readUnsignedShort();
		}
		
		public static function readLength(buffer:ByteArray):uint
		{
			return buffer.readUnsignedShort();
		}
	}
}