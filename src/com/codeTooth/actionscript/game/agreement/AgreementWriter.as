package com.codeTooth.actionscript.game.agreement
{
	import com.codeTooth.actionscript.lang.exceptions.IllegalParameterException;
	import com.codeTooth.actionscript.lang.exceptions.NullPointerException;
	import com.codeTooth.actionscript.lang.exceptions.UnknownTypeException;
	
	import flash.utils.ByteArray;

	/**
	 * 协议书写器
	 */
	public class AgreementWriter
	{
		// 缓冲区
		private static var _cache:ByteArray = new ByteArray();
		
		/**
		 * 根据指定的协议数据对象和协议格式对象，将数据写入二进制缓冲中
		 * 
		 * @param cache 提供的二进制缓冲，用来写入协议数据
		 * @param agreementItem 协议格式对象
		 * @param agreementObject 协议数据对象
		 * 
		 * @return 返回写完协议数据的二进制缓冲
		 * 
		 * @throws com.codeTooth.actionscript.lang.exceptions.NullPointerException 
		 * 指定的二进制缓冲或协议格式对象或协议数据对象是null
		 * @throws com.codeTooth.actionscript.lang.exceptions.IllegalParameterException 
		 * 协议的数据太长，超出了限制的长度
		 */
		public static function write(cache:ByteArray, agreementItem:AgreementItem, agreementObject:Object):ByteArray
		{
			if(cache == null)
			{
				throw new NullPointerException("Null cache");
			}
			if(agreementItem == null)
			{
				throw new NullPointerException("Null agreementItem");
			}
			if(agreementObject == null)
			{
				throw new NullPointerException("Null agreementObject");
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
				for each(var contentXML:XML in contentXMLList)
				{
					writeValue(_cache, agreementObject[String(contentXML.@name)], contentXML);
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
		
		private static function writeObject(cache:ByteArray, obj:Object, objXML:XML):void
		{
			if(obj == null)
			{
				cache.writeByte(0);
			}
			else
			{
				cache.writeByte(1);
				
				var valueXMLList:XMLList = objXML.value;
				for each(var valueXML:XML in valueXMLList)
				{
					writeValue(cache, obj[String(valueXML.@name)], valueXML);
				}
			}
		}
		
		private static function writeArray(cache:ByteArray, arr:Object, arrXML:XML):void
		{
			if(arr == null)
			{
				cache.writeByte(0);
			}
			else
			{
				cache.writeByte(1);
				
				var length:uint = arr.length;
				if(length > Agreement.ARRAY_LENGTH_MAX_VALUE)
				{
					throw new IllegalParameterException(
						"Illegal array length \"" + length + "\", limit \"" + Agreement.ARRAY_LENGTH_MAX_VALUE + "\""
					);
				}
				cache.writeUnsignedInt(arr.length);
				
				var arrItemXML:XML = arrXML.value[0];
				for(var i:uint; i < length; i++)
				{
					writeValue(cache, arr[i], arrItemXML);
				}
			}
		}
		
		private static function writeVector(cache:ByteArray, vector:Object, vectorXML:XML):void
		{
			if(vector == null)
			{
				cache.writeByte(0);
			}
			else
			{
				cache.writeByte(1);
				
				var length:uint = vector.length;
				if(length > Agreement.VECTOR_LENGTH_MAX_VALUE)
				{
					throw new IllegalParameterException(
						"Illegal vector length \"" + length + "\", limit \"" + Agreement.VECTOR_LENGTH_MAX_VALUE + "\""
					);
				}
				cache.writeUnsignedInt(vector.length);
				
				var vectorItemXML:XML = vectorXML.value[0];
				for(var i:uint = 0; i < length; i++)
				{
					writeValue(cache, vector[i], vectorItemXML);
				}
			}
		}
		
		private static function writeValue(cache:ByteArray, value:Object, valueXML:XML):void
		{
			var typeStr:String = String(valueXML.@type);
			if(typeStr == Agreement.VALUE_TYPE_INT)
			{
				writeInt(cache, int(value));
			}
			else if(typeStr == Agreement.VALUE_TYPE_UINT)
			{
				writeUnsignedInt(cache, uint(value));
			}
			else if(typeStr == Agreement.VALUE_TYPE_DOUBLE)
			{
				writeDouble(cache, Number(value));
			}
			else if(typeStr == Agreement.VALUE_TYPE_FLOAT)
			{
				writeFloat(cache, Number(value));
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