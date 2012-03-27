package com.codeTooth.actionscript.game.amfAgreement
{
	import com.codeTooth.actionscript.lang.exceptions.NullPointerException;
	import com.codeTooth.actionscript.lang.utils.destroy.DestroyUtil;
	import com.codeTooth.actionscript.lang.utils.destroy.IDestroy;
	
	import flash.utils.ByteArray;

	/**
	 * @private
	 * 
	 * 协议执行器
	 */
	internal class AMFAgreementExecutor implements IDestroy
	{
		private var _singletons:Array = null;
		
		public function AMFAgreementExecutor()
		{
			_singletons = new Array();
		}
		
		/**
		 * 执行一条协议
		 * 
		 * @param agreementItem	协议对象
		 * @param buffer 指定的包含协议数据的缓冲区
		 * 
		 * @throws com.codeTooth.actionscript.lang.exceptions.NullPointerException 
		 * 入参是null
		 */
		public function execute(agreementItem:AMFAgreementItem, buffer:ByteArray):void
		{
			if(agreementItem == null)
			{
				throw new NullPointerException("Null agreementItem");
			}
			if(buffer == null)
			{
				throw new NullPointerException("Null buffer");
			}
			
			// 如果是静态调用，则直接调用静态方法
			if(agreementItem.isStatic)
			{
				agreementItem.getModuleClazz()[agreementItem.command](AMFAgreementReader.read(buffer));
			}
			else
			{
				// 如果是单例，则创建单例对象
				// 否则每次否创建一个新的对象
				var agreementObject:Object = null;
				if(agreementItem.isSingle)
				{
					if(_singletons[agreementItem.id] == null)
					{
						agreementObject = new (agreementItem.getModuleClazz())();
						_singletons[agreementItem.id] = agreementObject;
					}
					else
					{
						agreementObject = _singletons[agreementItem.id];
					}
				}
				else
				{
					agreementObject = new (agreementItem.getModuleClazz())();
				}
				
				// 调用对象的方法，执行协议
				agreementObject[agreementItem.command](AMFAgreementReader.read(buffer));
			}

		}
		
		//----------------------------------------------------------------------------------------------------------------------------------
		// 实现 IDestroy 方法
		//----------------------------------------------------------------------------------------------------------------------------------
		
		public function destroy():void
		{
			DestroyUtil.destroyArray(_singletons);
			_singletons = null;
		}
		
	}
}