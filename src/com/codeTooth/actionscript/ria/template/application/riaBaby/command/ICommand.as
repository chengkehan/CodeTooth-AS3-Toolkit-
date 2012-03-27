package com.codeTooth.actionscript.ria.template.application.riaBaby.command 
{
	/**
	 * 命令接口
	 */
	public interface ICommand
	{
		/**
		 * 开始执行命令
		 * 
		 * @param	data 执行命令所需的数据
		 * 
		 * @return 命令的返回值
		 */
		function execute(data:Object = null):*;
	}
	
}