package com.codeTooth.actionscript.game.agreement
{
	import com.codeTooth.actionscript.lang.exceptions.IllegalParameterException;
	import com.codeTooth.actionscript.lang.exceptions.NullPointerException;
	import com.codeTooth.actionscript.lang.exceptions.UnknownTypeException;
	
	import flash.utils.ByteArray;
	
	/**
	 * @private
	 * 
	 * XML协议书写器
	 */
	public class AgreementXMLWriter
	{
		// 缓冲区
		private static var _cache:ByteArray = new ByteArray();
		
		/**
		 * 根据指定的协议数据对象和协议格式对象，将数据写入二进制缓冲中
		 * 
		 * @param cache 提供的二进制缓冲，用来写入协议数据
		 * @param agreementItem 协议格式对象
		 * @param agreementXML 协议XML数据对象
		 * 
		 * @return 返回写完协议数据的二进制缓冲
		 * 
		 * @throws com.codeTooth.actionscript.lang.exceptions.NullPointerException 
		 * 指定的二进制缓冲或协议格式对象或协议XML数据对象是null
		 * @throws com.codeTooth.actionscript.lang.exceptions.IllegalParameterException 
		 * 协议的数据太长，超出了限制的长度
		 */
		public static function write(cache:ByteArray, agreementItem:AgreementItem, agreementXML:XML):ByteArray
		{
			if(cache == null)
			{
				throw new NullPointerException("Null cache");
			}
			if(agreementItem == null)
			{
				throw new NullPointerException("Null agreementItem");
			}
			if(agreementXML == null)
			{
				throw new NullPointerException("Null agreementXML");
			}
			
			// 写入协议头
			writeHead(cache, agreementItem.head);
			// 写入协议ID
			writeID(cache, agreementItem.id);
			
			// 临时缓冲区清空
			_cache.clear();
			// 向临时缓冲中写入协议数据
			var contentXMLList:XMLList = agreementItem.getContentXMLList();
			if(contentXMLList != null)
			{
				var index:uint = 0;
				for each(var contentXML:XML in contentXMLList)
				{
					writeValue(_cache, agreementXML.children()[index++], contentXML);
				}
			}
			
			// 验证缓冲区的长度是否合法
			if(_cache.length > Agreement.AGREEMENT_LENGTH_MAX_BYTE)
			{
				throw new IllegalParameterException(
					"Illegal agreement length \"" + _cache.length + "\", limit \"" + Agreement.AGREEMENT_LENGTH_MAX_BYTE + "\""
				);
			}
			// 写入协议的长度
			writeLength(cache, _cache.length);
			// 把临时缓冲中的数据写入缓冲中
			writeAgreementObject(cache, _cache);
			
			return cache;
		}
		
		private static function writeHead(cache:ByteArray, head:uint):void
		{
			cache.writeByte(head);
		}
		
		private static function writeID(cache:ByteArray, id:uint):void
		{
			cache.writeShort(id);
		}
		
		private static function writeLength(cache:ByteArray, length:uint):void
		{
			cache.writeShort(length);
		}
		
		private static function writeAgreementObject(cache:ByteArray, data:ByteArray):void
		{
			cache.writeBytes(data, 0, data.length);
		}
		
		private static function writeInt(cache:ByteArray, value:int):void
		{
			cache.writeInt(value);
		}
		
		private static function writeUnsignedInt(cache:ByteArray, value:uint):void
		{
			cache.writeUnsignedInt(value);
		}
		
		private static function writeDouble(cache:ByteArray, value:Number):void
		{
			cache.writeDouble(value);
		}
		
		private static function writeFloat(cache:ByteArray, value:Number):void
		{
			cache.writeFloat(value);
		}
		
		private static function writeString(cache:ByteArray, str:String):void
		{
			if(str == null)
			{
				cache.writeByte(0);
			}
			else
			{
				cache.writeByte(1);
				cache.writeUTF(str);
			}
		}
		
		private static function writeObject(cache:ByteArray, xml:XML, objXML:XML):void
		{
			if(xml == null)
			{
				cache.writeByte(0);
			}
			else
			{
				cache.writeByte(1);
				
				var valueXMLList:XMLList = objXML.value;
				var index:uint = 0;
				for each(var valueXML:XML in valueXMLList)
				{
					writeValue(cache, xml.children()[index++], valueXML);
				}
			}
		}
		
		private static function writeArray(cache:ByteArray, arr:XML, arrXML:XML):void
		{
			if(arr == null)
			{
				cache.writeByte(0);
			}
			else
			{
				cache.writeByte(1);
				
				var children:XMLList = arr.children();
				var length:uint = children.length();
				if(length > Agreement.ARRAY_LENGTH_MAX_VALUE)
				{
					throw new IllegalParameterException(
						"Illegal array length \"" + length + "\", limit \"" + Agreement.ARRAY_LENGTH_MAX_VALUE + "\""
					);
				}
				cache.writeUnsignedInt(children.length());
				
				var arrItemXML:XML = arrXML.value[0];
				for(var i:uint; i < length; i++)
				{
					writeValue(cache, children[i], arrItemXML);
				}
			}
		}
		
		private static function writeVector(cache:ByteArray, vector:XML, vectorXML:XML):void
		{
			if(vector == null)
			{
				cache.writeByte(0);
			}
			else
			{
				cache.writeByte(1);
				
				var children:XMLList = vector.children();
				var length:uint = children.length;
				if(length > Agreement.VECTOR_LENGTH_MAX_VALUE)
				{
					throw new IllegalParameterException(
						"Illegal vector length \"" + length + "\", limit \"" + Agreement.VECTOR_LENGTH_MAX_VALUE + "\""
					);
				}
				cache.writeUnsignedInt(children.length);
				
				var vectorItemXML:XML = vectorXML.value[0];
				for(var i:uint = 0; i < length; i++)
				{
					writeValue(cache, children[i], vectorItemXML);
				}
			}
		}
		
		private static function writeValue(cache:ByteArray, value:XML, valueXML:XML):void
		{
			var typeStr:String = String(valueXML.@type);
			if(typeStr == Agreement.VALUE_TYPE_INT)
			{
				writeInt(cache, int(String(value)));
			}
			else if(typeStr == Agreement.VALUE_TYPE_UINT)
			{
				writeUnsignedInt(cache, uint(String(value)));
			}
			else if(typeStr == Agreement.VALUE_TYPE_DOUBLE)
			{
				writeDouble(cache, Number(String(value)));
			}
			else if(typeStr == Agreement.VALUE_TYPE_FLOAT)
			{
				writeFloat(cache, Number(String(value)));
			}
			else if(typeStr == Agreement.VALUE_TYPE_STRING)
			{
				writeString(cache, String(value));
			}
			else if(typeStr == Agreement.VALUE_TYPE_OBJECT)
			{
				writeObject(cache, value, valueXML);
			}
			else if(typeStr == Agreement.VALUE_TYPE_ARRAY)
			{
				writeArray(cache, value, valueXML);
			}
			else if(typeStr == Agreement.VALUE_TYPE_VECTOR)
			{
				writeVector(cache, value, valueXML);
			}
			else
			{
				throw new UnknownTypeException("Unknown value type \"" + typeStr + "\"");
				return null;
			}
		}
	}
}