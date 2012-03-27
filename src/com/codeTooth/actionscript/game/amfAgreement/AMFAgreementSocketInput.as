package com.codeTooth.actionscript.game.amfAgreement
{
	import com.codeTooth.actionscript.lang.exceptions.NullPointerException;
	import com.codeTooth.actionscript.lang.utils.destroy.IDestroy;
	
	import flash.utils.ByteArray;

	public class AMFAgreementSocketInput implements IDestroy
	{
		public function AMFAgreementSocketInput(amfAgreementDataCallback:Function/*func(bytes:ByteArray):void*/)
		{
			_buffer = new ByteArray();
			setAMFAgreementDataCallback(amfAgreementDataCallback);
		}
		
		public function input(cache:ByteArray):Boolean
		{
			if(cache == null)
			{
				throw new NullPointerException("Null cache");
			}
			
			var cacheLength:uint = cache.length;
			var cacheOrigPosition:uint = cache.position;
			// 判读是否可以读取到协议的长度
			if(cacheLength >= AMFAgreement.AMF_AGREEMENT_LENGTH_END_INDEX)
			{
				// 读取协议头
				AMFAgreementReader.readHead(cache);
				// 读取协议ID
				AMFAgreementReader.readAgreementID(cache);
				// 读取协议长度
				var bodyLength:uint = AMFAgreementReader.readLength(cache);
				// 协议的总长度
				var agreementLength:uint = bodyLength + AMFAgreement.AMF_AGREEMENT_LENGTH_END_INDEX;
				// 整条协议已经读到了缓冲区中，开始读取协议数据
				if(cacheLength >= agreementLength)
				{
					// 将协议数据读取到协议缓冲区中
					_buffer.clear();
					_buffer.writeBytes(cache, cacheOrigPosition, agreementLength);
					
					// 把缓冲区中协议以后的数据提前（协议以后多出来的数据很可能是下一条协议的开始部分，下一条协议还没有完全读取到缓冲区中），
					// 形成新的缓冲区（以等待下一条协议的顺利读取）
					var moveToIndex:uint = 0;
					for(var i:uint = cacheOrigPosition + agreementLength; i < cacheLength; i++)
					{
						cache[cacheOrigPosition + (moveToIndex++)] = cache[i];
					}
					cache.length = cacheLength - agreementLength;
					cache.position = cacheOrigPosition;
					
					// 处理读取到的协议数据
					_buffer.position = 0;
					_amfAgreementDataCallback(_buffer);
					
					// 如果缓冲区中还有数据，试着看看能不能读到一条完整的协议
					if(cache.length - cacheOrigPosition > 0)
					{
						input(cache);
					}
					
					return true;
				}
			}
			
			cache.position = cacheOrigPosition;
			return false;
		}
		
		//----------------------------------------------------------------------------------------------------------------------------------
		// 收到协议数据时触发的回调
		//----------------------------------------------------------------------------------------------------------------------------------
		
		private var _amfAgreementDataCallback:Function/*func(bytes:ByteArray):void*/ = null;
		
		public function setAMFAgreementDataCallback(func:Function):void
		{
			if(func == null)
			{
				throw new NullPointerException("Null callback");
			}
			
			_amfAgreementDataCallback = func;
		}
		
		public function getAMFAgreementDataCallback():Function
		{
			return _amfAgreementDataCallback;
		}
		
		//----------------------------------------------------------------------------------------------------------------------------------
		// 缓冲
		//----------------------------------------------------------------------------------------------------------------------------------
		
		private var _buffer:ByteArray = null;
		
		public function clearBuffer():void
		{
			_buffer.clear();
		}
		
		private function destroyBuffer():void
		{
			if(_buffer != null)
			{
				_buffer.clear();
				_buffer = null;
			}
		}
		
		//----------------------------------------------------------------------------------------------------------------------------------
		// 实现 IDestroy 接口
		//----------------------------------------------------------------------------------------------------------------------------------
		
		public function destroy():void
		{
			destroyBuffer();
			_amfAgreementDataCallback = null;
		}
	}
}