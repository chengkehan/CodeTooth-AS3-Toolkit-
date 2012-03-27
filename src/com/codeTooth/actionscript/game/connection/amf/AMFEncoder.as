package com.codeTooth.actionscript.game.connection.amf
{
	import com.codeTooth.actionscript.lang.exceptions.IllegalOperationException;
	import com.codeTooth.actionscript.lang.exceptions.IllegalParameterException;
	import com.codeTooth.actionscript.lang.exceptions.NullPointerException;
	import com.codeTooth.actionscript.lang.utils.Common;
	import com.codeTooth.actionscript.lang.utils.destroy.IDestroy;
	
	import flash.utils.ByteArray;

	/**
	 * AMF编码
	 */
	public class AMFEncoder implements IDestroy
	{
		/**
		 * AMF头
		 */
		public static const AMF_HEAD:uint = Common.BYTE_MAX;
		
		/**
		 * AMF头的下一位索引
		 */
		public static const AMF_HEAD_END_INDEX:uint = 1;
		
		/**
		 * AMF数据长度的最大值
		 */
		public static const AMF_LENGTH_MAX_VALUE:uint = Common.SHORT_MAX;
		
		/**
		 * AMF数据长度的下一位索引
		 */
		public static const AMF_LENGTH_END_INDEX:uint = 3;
		
		
		private var _buffer:ByteArray = null;
		
		/**
		 * 构造函数
		 */
		public function AMFEncoder()
		{
			_buffer = new ByteArray();
		}
		
		/**
		 * 编码AMF数据。在数据前加上头和长度信息
		 * 
		 * @param cache 
		 * @param data 
		 * 
		 * @return 
		 * 
		 * @throws com.codeTooth.actionscript.lang.exceptions.NullPointerException 
		 * 指定的缓冲区是null
		 * @throws com.codeTooth.actionscript.lang.exceptions.IllegalParameterException 
		 * 非法的AMF尺寸
		 */
		public function encode(cache:ByteArray, data:Object):ByteArray
		{
			if(cache == null)
			{
				throw new NullPointerException("Null cache");
			}
			
			_buffer.clear();
			_buffer.writeObject(data);
			
			var bufferLength:uint = _buffer.length;
			if(bufferLength > AMF_LENGTH_MAX_VALUE)
			{
				throw new IllegalOperationException(
					"Illegal amf data length \"" + bufferLength + "\". Max amf data length is \"" + AMF_LENGTH_MAX_VALUE + "\""
				);
			}
			
			cache.writeByte(AMF_HEAD);
			cache.writeShort(bufferLength);
			cache.writeBytes(_buffer, 0, bufferLength);
			
			return cache;
		}
		
		//----------------------------------------------------------------------------------------------------------------------------------
		// 实现 IDestroy 接口
		//----------------------------------------------------------------------------------------------------------------------------------
		
		public function destroy():void
		{
			if(_buffer != null)
			{
				_buffer.clear();
				_buffer = null;
			}
		}
	}
}