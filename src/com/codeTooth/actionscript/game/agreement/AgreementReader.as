package com.codeTooth.actionscript.game.agreement
{
	import com.adobe.utils.StringUtil;
	import com.codeTooth.actionscript.lang.exceptions.IllegalOperationException;
	import com.codeTooth.actionscript.lang.exceptions.UnknownTypeException;
	import com.codeTooth.actionscript.lang.exceptions.NullPointerException;
	import com.codeTooth.actionscript.lang.utils.Assert;
	import com.codeTooth.actionscript.lang.utils.Common;
	
	import flash.system.ApplicationDomain;
	import flash.utils.ByteArray;
	
	/**
	 * 协议读取器
	 */
	public class AgreementReader
	{
		private static var _ignoreDefinition:Boolean = false;
		
		/**
		 * 读取协议数据，根据协议格式对象生成相应的协议数据对象
		 * 
		 * @param data 协议的二进制数据
		 * @param agreementItem 协议格式对象
		 * @param appDomain 所使用的应用程序域
		 * 
		 * @throws com.codeTooth.actionscript.lang.exceptions.NullPointerException 
		 * 指定的协议格式对象或协议数据或应用程序域是null
		 */
		public static function read(data:ByteArray, agreementItem:AgreementItem, appDomain:ApplicationDomain, ignoreDefinition:Boolean):*
		{
			checkDataNull(data);
			if(agreementItem == null)
			{
				throw new NullPointerException("Null agreementItem");
			}
			if(appDomain == null)
			{
				throw new NullPointerException("Null appDomain");
			}
			
			_ignoreDefinition = ignoreDefinition;
			
			readHead(data);
			readID(data);
			
			// 读取协议的长度
			readLength(data);
			
			// 创建协议数据对象
			// 如果在格式对象中指定的类型，则创建指定类型的数据对象，否则就创建Object类型的对象
			var agreementObject:Object = agreementItem.definition == null || _ignoreDefinition ? 
				new Object() : 
				new (Class(appDomain.getDefinition(agreementItem.definition)))();
			var contentXMLList:XMLList = agreementItem.getContentXMLList();
			// 为数据对象赋值
			if(contentXMLList != null)
			{
				for each(var contentXML:XML in contentXMLList)
				{
					agreementObject[String(contentXML.@name)] = readValue(data, contentXML, appDomain);
				}
			}
			
			return agreementObject;
		}
		
		public static function readHead(data:ByteArray):uint
		{
			checkDataNull(data);
			return data.readUnsignedByte();
		}
		
		public static function readID(data:ByteArray):uint
		{
			checkDataNull(data);
			return data.readUnsignedShort();
		}
		
		public static function readLength(data:ByteArray):uint
		{
			return data.readUnsignedShort();
		}
		
		private static function readInt(data:ByteArray):int
		{
			return data.readInt();
		}
		
		private static function readUnsignedInt(data:ByteArray):uint
		{
			return data.readUnsignedInt();
		}
		
		private static function readDouble(data:ByteArray):Number
		{
			return data.readDouble();
		}
		
		private static function readFloat(data:ByteArray):Number
		{
			return data.readFloat();
		}
		
		private static function readString(data:ByteArray):String
		{
			if(data.readByte() == 0)
			{
				return null;
			}
			else
			{
				return data.readUTF();
			}
		}
		
		private static function readObject(data:ByteArray, objectXML:XML, appDomain:ApplicationDomain):Object
		{
			if(data.readByte() == 0)
			{
				return null;
			}
			else
			{
				var obj:Object = 
					objectXML.@definition == undefined || StringUtil.isEmpty(String(objectXML.@definition)) || _ignoreDefinition ? 
					new Object() : 
					new (Class(appDomain.getDefinition(String(objectXML.@definition))))();
				
				var valueXMLList:XMLList = objectXML.value;
				for each(var valueXML:XML in valueXMLList)
				{
					obj[String(valueXML.@name)] = readValue(data, valueXML, appDomain);
				}
				
				return obj;
			}
		}
		
		private static function readArray(data:ByteArray, arrayXML:XML, appDomain:ApplicationDomain):Array
		{
			if(data.readByte() == 0)
			{
				return null;
			}
			else
			{
				var length:uint = data.readUnsignedInt();
				var arr:Array = new Array(length);
				var arrItemXML:XML = arrayXML.value[0];
				
				for(var i:uint = 0; i < length; i++)
				{
					arr[i] = readValue(data, arrItemXML, appDomain);
				}
				
				return arr;
			}
		}
		
		private static function readVector(data:ByteArray, vectorXML:XML, appDomain:ApplicationDomain):Object
		{
			if(data.readByte() == 0)
			{
				return null;
			}
			else
			{
				var length:uint = data.readUnsignedInt();
				var type:String = "Vector.<" + (_ignoreDefinition ? "Object" : String(vectorXML.@definition)) + ">";
				var clazz:Class = Class(appDomain.getDefinition(type));
				var vector:Object = new clazz(length);
				var vectorItemXML:XML = vectorXML.value[0];
				
				for(var i:uint = 0; i < length; i++)
				{
					vector[i] = readValue(data, vectorItemXML, appDomain);
				}
				
				return vector;
			}
		}
		
		private static function readValue(data:ByteArray, valueXML:XML, appDomain:ApplicationDomain):Object
		{
			var typeStr:String = String(valueXML.@type);
			if(typeStr == Agreement.VALUE_TYPE_INT)
			{
				return readInt(data);
			}
			else if(typeStr == Agreement.VALUE_TYPE_UINT)
			{
				return readUnsignedInt(data);
			}
			else if(typeStr == Agreement.VALUE_TYPE_DOUBLE)
			{
				return readDouble(data);
			}
			else if(typeStr == Agreement.VALUE_TYPE_FLOAT)
			{
				return readFloat(data);
			}
			else if(typeStr == Agreement.VALUE_TYPE_STRING)
			{
				return readString(data);
			}
			else if(typeStr == Agreement.VALUE_TYPE_OBJECT)
			{
				return readObject(data, valueXML, appDomain);
			}
			else if(typeStr == Agreement.VALUE_TYPE_ARRAY)
			{
				return readArray(data, valueXML, appDomain);
			}
			else if(typeStr == Agreement.VALUE_TYPE_VECTOR)
			{
				return readVector(data, valueXML, appDomain);
			}
			else
			{
				throw new UnknownTypeException("Unknown value type \"" + typeStr + "\"");
				return null;
			}
		}
		
		private static function checkDataNull(data:ByteArray):void
		{
			if(data == null)
			{
				throw new NullPointerException("Null data");
			}
		}
	}
}