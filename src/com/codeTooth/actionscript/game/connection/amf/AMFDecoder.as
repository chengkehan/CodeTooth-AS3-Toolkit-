package com.codeTooth.actionscript.game.connection.amf
{
	import com.codeTooth.actionscript.lang.exceptions.NullPointerException;
	import com.codeTooth.actionscript.lang.exceptions.UnknownTypeException;
	import com.codeTooth.actionscript.lang.utils.destroy.IDestroy;
	
	import flash.utils.ByteArray;

	/**
	 * AMF解码
	 */
	public class AMFDecoder implements IDestroy
	{
		
		/**
		 * 构造函数
		 * 
		 * @param decodeCallback 读取到AMF数据后立刻回调此函数。原型func(cache:ByteArray):void
		 */
		public function AMFDecoder(decodeCallback:Function)
		{
			_decodeCache = new ByteArray();
			setDecodeCallback(decodeCallback);
		}
		
		/**
		 * 开始解码一个AMF数据
		 * 
		 * @param cache 传入字节数组的缓冲区
		 * 
		 * @return 
		 * 
		 * @throws com.codeTooth.actionscript.lang.exceptions.UnknownTypeException 
		 * 无法解析的AMF头数据
		 */
		public function decode(cache:ByteArray):Boolean
		{
			if(cache == null)
			{
				throw new NullPointerException("Null cache");
			}
			
			var cacheSize:uint = cache.length;
			var cacheOrigPosition:uint = cache.position;
			// 缓冲区的长度足够长
			if(cacheSize >= AMFEncoder.AMF_LENGTH_END_INDEX)
			{
				// 符合AMF的头
				if(cache.readUnsignedByte() != AMFEncoder.AMF_HEAD)
				{
					throw new UnknownTypeException("Illegal amf head data.");
				}
				
				// 读取AMF数据部分的长度
				var length:uint = cache.readUnsignedShort();
				// 计算AMF的整体长度
				var amfSize:uint = AMFEncoder.AMF_LENGTH_END_INDEX + length;
				// 缓冲区的尺寸符合要求
				if(cacheSize >= amfSize)
				{
					// 将数据写入AMF缓冲区
					_decodeCache.clear();
					_decodeCache.writeBytes(cache, cacheOrigPosition + AMFEncoder.AMF_LENGTH_END_INDEX, length);
					
					// 读取完AMf数据之后，缓冲区中还有数据的话，把这些数据提前（这些数据是下一条AMF数据的开始）
					var index:uint = 0;
					for(var i:uint = cacheOrigPosition + amfSize; i < cacheSize; i++)
					{
						cache[cacheOrigPosition + (index++)] = cache[i];
					}
					cache.length = cacheSize - amfSize;
					cache.position = cacheOrigPosition;
					
					// 回调
					_decodeCache.position = 0;
					_decodeCallback(_decodeCache);
					
					// 如果缓冲区中还有数据，试试看能不能再读出来MF数据
					if(cache.length - cacheOrigPosition > 0)
					{
						decode(cache);
					}
					
					return true;
				}
			}
			
			cache.position = cache.length;
			return false;
		}
		
		//----------------------------------------------------------------------------------------------------------------------------------
		// 收到AMF数据后回调
		//----------------------------------------------------------------------------------------------------------------------------------
		
		// 读取到AMF数据后会马上调用此函数
		private var _decodeCallback:Function/*func(amfData:ByteArray):void*/ = null;
		
		public function setDecodeCallback(func:Function):void
		{
			if(func == null)
			{
				throw new NullPointerException("Null func");
			}
			
			_decodeCallback = func
		}
		
		public function getDecodeCallback():Function
		{
			return _decodeCallback
		}
		
		//----------------------------------------------------------------------------------------------------------------------------------
		// AMF缓冲区
		//----------------------------------------------------------------------------------------------------------------------------------
		
		// AMF数据的缓冲区，读取到的AMF数据会放在这里
		private var _decodeCache:ByteArray = null;
		
		public function clearCache():void
		{
			_decodeCache.clear();
		}
		
		private function destroyDecodeCache():void
		{
			if(_decodeCache != null)
			{
				_decodeCache.clear();
				_decodeCache = null;
			}
		}
		
		//----------------------------------------------------------------------------------------------------------------------------------
		// 实现 IDestroy 接口
		//----------------------------------------------------------------------------------------------------------------------------------
		
		public function destroy():void
		{
			destroyDecodeCache();
			_decodeCallback = null;
		}
	}
}