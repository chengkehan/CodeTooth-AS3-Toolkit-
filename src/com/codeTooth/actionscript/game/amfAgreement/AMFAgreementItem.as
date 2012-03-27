package com.codeTooth.actionscript.game.amfAgreement
{
	import com.codeTooth.actionscript.lang.exceptions.NullPointerException;
	import com.codeTooth.actionscript.lang.utils.destroy.IDestroy;
	
	import flash.system.ApplicationDomain;

	/**
	 * 协议对象
	 */
	public class AMFAgreementItem implements IDestroy
	{
		private var _id:uint = 0;
		
		private var _module:String = null;
		
		private var _command:String = null;
		
		private var _isStatic:Boolean = false;
		
		private var _isSingle:Boolean = false;
		
		private var _moduleClazz:Class = null;
		
		/**
		 * 构造函数
		 * 
		 * @param id 协议的ID
		 * @param module 协议调用的模块
		 * @param command 协议调用的命令
		 * @param isStatic 命令是否是静态的
		 * @param isSingle 模块是否是单例
		 */
		public function AMFAgreementItem(id:uint, module:String, command:String, isStatic:Boolean, isSingle:Boolean)
		{
			_id = id;
			_module = module;
			_command = command;
			_isStatic = isStatic;
			_isSingle = isSingle;
		}

		public function get id():uint
		{
			return _id;
		}

		public function get module():String
		{
			return _module;
		}

		public function get command():String
		{
			return _command;
		}

		public function get isStatic():Boolean
		{
			return _isStatic;
		}

		public function get isSingle():Boolean
		{
			return _isSingle;
		}
		
		internal function getModuleClazz():Class
		{
			return _moduleClazz;
		}
		
		internal function createModuleClazz(appDomain:ApplicationDomain, clazzCheck:Boolean):void
		{
			if(appDomain == null)
			{
				throw new NullPointerException("Null appDomain");
			}
			
			_moduleClazz = null;
			if(clazzCheck && !appDomain.hasDefinition(_module))
			{
				return;
			}
			
			_moduleClazz = Class(appDomain.getDefinition(_module));
		}
		
		//----------------------------------------------------------------------------------------------------------------------------------
		// 实现 IDestroy 接口
		//----------------------------------------------------------------------------------------------------------------------------------
		
		public function destroy():void
		{
			_moduleClazz = null;
		}
		
		//----------------------------------------------------------------------------------------------------------------------------------
		// 重写 toString
		//----------------------------------------------------------------------------------------------------------------------------------
		
		public function toString():String
		{
			return "[object AMFAgreementItem(id:" + _id + ", module:" + _module + ", command:" + _command + ", isStatic:" + _isStatic + ", isSingle:" + _isSingle + ")]";
		}
	}
}