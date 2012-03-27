package com.codeTooth.actionscript.game.amfAgreement
{
	import com.codeTooth.actionscript.lang.utils.destroy.IDestroy;
	
	import flash.events.IEventDispatcher;

	/**
	 * AMF协议加载器
	 */
	public interface IAMFAgreementLoader extends IEventDispatcher, IDestroy
	{
		/**
		 * 开始加载协议
		 * 
		 * @param source
		 */
		function load(source:Object):void;
		
		/**
		 * 获得协议的XML表示形式
		 * 
		 * @return 
		 */
		function getAMFAgreementXML():XML;
		
		/**
		 * 关闭加载流
		 */
		function close():void;
	}
}