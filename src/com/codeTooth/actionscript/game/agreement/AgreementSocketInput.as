package com.codeTooth.actionscript.game.agreement
{
	import com.codeTooth.actionscript.game.agreement.AgreementReader;
	import com.codeTooth.actionscript.lang.exceptions.NullPointerException;
	import com.codeTooth.actionscript.lang.utils.destroy.IDestroy;
	
	import flash.net.Socket;
	import flash.utils.ByteArray;

	/**
	 * Socket协议输入
	 */
	public class AgreementSocketInput implements IDestroy
	{
		/**
		 * 构造函数
		 * 
		 * @param agreementDataCallback 读取一条协议完成时，把读取到的协议数据传给此处理函数。函数原型func(agreementData:ByteArray):void
		 * 
		 * @throws com.codeTooth.actionscript.lang.exceptions.NullPointerException 
		 * 入参是null
		 */
		public function AgreementSocketInput(agreementDataCallback:Function):void
		{
			setAgreementDataCallback(agreementDataCallback);
			_agreementCache = new ByteArray();
		}
		
		/**
		 * 从Socket的缓冲区读取到的数据，传入此函数，进行处理
		 * 
		 * @param cache 从Socket中读取数据的缓冲区
		 * 
		 * @throws com.codeTooth.actionscript.lang.exceptions.NullPointerException 
		 * 入参是null
		 */
		public function input(cache:ByteArray):Boolean
		{
			if(cache == null)
			{
				throw new NullPointerException("Null cache");
			}
			
			var cacheLength:uint = cache.length;
			var cacheOrigPosition:uint = cache.position;
			// 判读是否可以读取到协议的长度
			if(cacheLength >= Agreement.AGREEMENT_LENGTH_END_INDEX)
			{
				// 读取协议头
				AgreementReader.readHead(cache);
				// 读取协议ID
				AgreementReader.readID(cache);
				// 读取协议长度
				var bodyLength:uint = AgreementReader.readLength(cache);
				// 协议的总长度
				var agreementLength:uint = bodyLength + Agreement.AGREEMENT_LENGTH_END_INDEX;
				// 整条协议已经读到了缓冲区中，开始读取协议数据
				if(cacheLength >= agreementLength)
				{
					// 将协议数据读取到协议缓冲区中
					_agreementCache.clear();
					_agreementCache.writeBytes(cache, cacheOrigPosition, agreementLength);
					
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
					_agreementCache.position = 0;
					_agreementDataCallback(_agreementCache);
					
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
		// 协议处理器
		//----------------------------------------------------------------------------------------------------------------------------------
		
		// 协议处理函数，把读到的协议数据交给此函数进行处理
		private var _agreementDataCallback:Function/*func(agreementData:ByteArray):void*/ = null;
		
		public function setAgreementDataCallback(func:Function):void
		{
			if(func == null)
			{
				throw new NullPointerException("Null agreementDataCallback");
			}
			_agreementDataCallback = func;
		}
		
		public function getAgreementDataCallback():Function
		{
			return _agreementDataCallback;
		}
		
		//----------------------------------------------------------------------------------------------------------------------------------
		// 协议缓冲
		//----------------------------------------------------------------------------------------------------------------------------------
		
		// 协议数据缓冲
		private var _agreementCache:ByteArray = null;
		
		/**
		 * 清空缓冲
		 */
		public function clearCache():void
		{
			_agreementCache.clear();
		}
		
		private function destroyAgreementCache():void
		{
			if(_agreementCache != null)
			{
				_agreementCache.clear();
				_agreementCache = null;
			}
		}
		
		//----------------------------------------------------------------------------------------------------------------------------------
		// 实现 IDestroy 接口
		//----------------------------------------------------------------------------------------------------------------------------------
		
		public function destroy():void
		{
			destroyAgreementCache();
			_agreementDataCallback = null;
		}
	}
}