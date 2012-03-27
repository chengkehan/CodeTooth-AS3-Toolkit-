package com.codeTooth.actionscript.game.amfAgreement
{
	import com.codeTooth.actionscript.lang.utils.destroy.IDestroy;

	/**
	 * 将加载到的AMF协议数据，转换成可以识别的XML形式
	 */
	public interface IAMFAgreementParser extends IDestroy
	{
		/**
		 * 开始转换成协议的XML形式
		 * 
		 * @param data 需要转换的数据
		 * 
		 * @return 转换的结果
		 */
		function parse(data:Object):XML;
	}
}