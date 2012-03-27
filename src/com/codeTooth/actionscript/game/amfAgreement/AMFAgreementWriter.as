package com.codeTooth.actionscript.game.amfAgreement
{
	import com.codeTooth.actionscript.game.connection.amf.AMFEncoder;
	import com.codeTooth.actionscript.lang.exceptions.IllegalParameterException;
	import com.codeTooth.actionscript.lang.exceptions.NullPointerException;
	
	import flash.utils.ByteArray;

	/**
	 * @private
	 * 
	 * 协议数据写入器
	 */
	internal class AMFAgreementWriter
	{
		// 临时缓存
		private static var _cache:ByteArray = new ByteArray();
		
		/**
		 * 开始向提供的缓冲写入AMF协议
		 * 
		 * @param agreementID 协议的ID
		 * @param buffer 提供的缓冲
		 * @param data AMF数据对象
		 * 
		 * @return 返回提供的缓冲
		 * 
		 * @throws com.codeTooth.actionscript.lang.exceptions.NullPointerException 
		 * 指定的缓冲是null 
		 * @throws com.codeTooth.actionscript.lang.exceptions.IllegalParameterException 
		 * 协议ID大于限定的值或协议长度超过了限定的范围 
		 */
		public static function write(agreementID:uint, buffer:ByteArray, data:Object):ByteArray
		{
			if(buffer == null)
			{
				throw new NullPointerException("Null buffer");
			}
			if(agreementID > AMFAgreement.AMF_AGREEMENT_ID_MAX)
			{
				// 指定的协议ID超过了限定的最大值
				throw new IllegalParameterException(
					"Illegal agreementID value \"" + agreementID + "\". Max value is \"" + agreementID + "\""
				);
			}
			
			_cache.clear();
			_cache.writeObject(data);
			var cacheLength:uint = _cache.length;
			if(cacheLength > AMFAgreement.AMF_LENGTH_MAX_VALUE)
			{
				// 协议的长度超出了限定的最大值
				throw new IllegalParameterException(
					"Illegal amf data length \"" + cacheLength + "\". Max amf data length is \"" + AMFAgreement.AMF_LENGTH_MAX_VALUE + "\""
				);
			}
			
			// 写入head
			buffer.writeByte(AMFEncoder.AMF_HEAD);
			// 写入id
			buffer.writeShort(agreementID);
			// 写入length
			buffer.writeShort(cacheLength);
			// 写入AMF
			buffer.writeBytes(_cache, 0, _cache.length);
			
			return buffer;
		}
	}
}