package com.codeTooth.actionscript.lang.utils.serialize 
{
	import com.codeTooth.actionscript.algorithm.encodeDecode.Base64;
	import com.codeTooth.actionscript.lang.utils.ArrayUtil;
	import com.codeTooth.actionscript.lang.utils.Common;
	import flash.display.BitmapData;
	
	/**
	 * 序列化助手
	 */
	public class SerializeUtil 
	{
		/**
		 * 序列化一张位图
		 * 
		 * @param	bmpd
		 * 
		 * @return	如果输入null，则返回null
		 */
		public static function serializeBitmapData(bmpd:BitmapData):String
		{
			return Base64.encodeBitmapData(bmpd);
		}
		
		/**
		 * 序列化多张位图
		 * 
		 * @param	bmpds
		 * 
		 * @return	返回一个xml对象，xml中的没一个子节点是一张序列化后的位图数据。如果输入null，则返回null
		 */
		public static function serializeBitmapDatas(bmpds:Vector.<BitmapData>):XML
		{
			if (bmpds == null)
			{
				return null;
			}
			else
			{
				var xml:XML = new XML(<bitmapDatas/>);
				var bmpdXML:XML;
				for each(var bmpd:BitmapData in bmpds)
				{
					if (bmpd != null)
					{
						bmpdXML = new XML(<bitmapData/>);
						bmpdXML.appendChild(Base64.encodeBitmapData(bmpd));
						xml.appendChild(bmpdXML);
					}
				}
				
				return null;
			}
		}
		
		/**
		 * 反序列化一张位图
		 * 
		 * @param	input	入参应该是serializeBitmapData方法的返回值
		 * 
		 * @return	如果输入null，则返回null
		 */
		public static function deserializeBitmapData(input:String):BitmapData
		{
			return Base64.decodeToBitmapData(input);
		}
		
		/**
		 * 反序列化多张位图
		 * 
		 * @param	input	入参应该是serializeBitmapDatas方法的返回值
		 * 
		 * @return	如果输入null，则返回null
		 */
		public static function deserializeBitmapDatas(input:XML):Vector.<BitmapData>
		{
			if (input == null)
			{
				return null;
			}
			else
			{
				var bmpdXMLList:XMLList = input.children();
				var bmpds:Vector.<BitmapData> = new Vector.<BitmapData>(bmpdXMLList.length());
				var index:int = 0;
				for each(var bmpdXML:XML in bmpdXMLList)
				{
					bmpds[index++] = Base64.decodeToBitmapData(String(bmpdXML));
				}
				
				return bmpds;
			}
		}
		
		/**
		 * 序列化数据，数组中的元素是简单类型
		 * 
		 * @param	array
		 * 
		 * @return	输入null，返回null
		 */
		public static function serializeSimpleArray(array:Array):String
		{
			if (array == null)
			{
				return null;
			}
			else
			{
				return array.join(Common.DELIM);
			}
		}
		
		/**
		 * 反序列化成数组，结果数组中的元素是字符串，简单类型的元素在使用时类型会进行自动的转换
		 * 
		 * @param	input
		 * 
		 * @return	输入null，返回null
		 */
		public static function deserializeSimpleArray(input:String):Array
		{
			if (input == null)
			{
				return null;
			}
			else
			{
				return input.split(Common.DELIM);
			}
		}
		
		/**
		 * 序列化Vector，Vector中的元素是简单类型
		 * 
		 * @param	v
		 * 
		 * @return	输入null，返回null
		 */
		public static function serializeSimpleVector(v:Object):String
		{
			if (v == null)
			{
				return null;
			}
			else
			{
				return v.join(Common.DELIM);
			}
		}
		
		/**
		 * 反序列化成Vector，结果Vector中的元素是字符串，简单类型的元素在使用时类型会进行自动的转换
		 * 
		 * @param	input
		 * 
		 * @return	输入null，返回null
		 */
		public static function deserializeSimpleVector(input:String):*
		{
			if (input == null)
			{
				return null;
			}
			else
			{
				return ArrayUtil.arrayToVector(input.split(Common.DELIM));
			}
		}
	}

}