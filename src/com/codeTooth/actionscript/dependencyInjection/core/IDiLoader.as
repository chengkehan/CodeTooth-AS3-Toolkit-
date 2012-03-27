package com.codeTooth.actionscript.dependencyInjection.core 
{		
	import com.codeTooth.actionscript.lang.utils.destroy.IDestroy;
	
	import flash.events.IEventDispatcher;
	
	/**
	 * 注入加载器接口
	 */
	public interface IDiLoader extends IEventDispatcher, IDestroy
	{
		/**
		 * 开始加载注入内容
		 * 
		 * @param source	加载源
		 */		
		function load(source:Object):void;
		
		/**
		 * 关闭正在进行的加载流
		 */		
		function close():void;
		
		/**
		 * 获得加载的注入内容的XML格式
		 * 
		 * @return
		 */		
		function getLoadedData():XML;
		
		/**
		 * 设置获取本地数据的函数
		 * 
		 * @param getLocalFunction
		 */		
		function setGetLocalFunction(getLocalFunction:Function):void;
	}
}