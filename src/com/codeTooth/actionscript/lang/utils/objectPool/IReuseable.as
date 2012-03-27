package com.codeTooth.actionscript.lang.utils.objectPool
{
	/**
	 * 可复用对象实现的接口。
	 */	
	public interface IReuseable
	{
		/**
		 * 调用此方法后，对象进行复位。
		 */		
		function reuse():void; 
	}
}