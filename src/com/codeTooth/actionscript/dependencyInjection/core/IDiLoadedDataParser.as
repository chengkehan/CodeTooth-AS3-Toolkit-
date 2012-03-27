package com.codeTooth.actionscript.dependencyInjection.core 
{
	import com.codeTooth.actionscript.lang.utils.destroy.IDestroy;
	
	/**
	 * 注入内容解析器，
	 * 注入的内容可能是各种格式的，
	 * 解析器负责将不同的加载内容翻译成能够理解的XML格式
	 */	
	
	public interface IDiLoadedDataParser extends IDestroy
	{	
		/**
		 * 添加一个注入的内容
		 * 
		 * @param data 需要解析的数据
		 * 
		 * @throws com.codeTooth.actionscript.lang.exceptions.NullPointerException 
		 * 入参是null
		 */		
		function addData(data:Object):void;
		
		/**
		 * 清除所有添加的
		 */		
		function clear():void;
		
		/**
		 * 解析所有添加的内容，
		 * 并返回统一的XML格式
		 * 
		 * @return
		 */		
		function parse():XML;
	}
}