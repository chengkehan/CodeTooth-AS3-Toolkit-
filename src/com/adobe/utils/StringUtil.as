/*
  Copyright (c) 2008, Adobe Systems Incorporated
  All rights reserved.

  Redistribution and use in source and binary forms, with or without 
  modification, are permitted provided that the following conditions are
  met:

  * Redistributions of source code must retain the above copyright notice, 
    this list of conditions and the following disclaimer.
  
  * Redistributions in binary form must reproduce the above copyright
    notice, this list of conditions and the following disclaimer in the 
    documentation and/or other materials provided with the distribution.
  
  * Neither the name of Adobe Systems Incorporated nor the names of its 
    contributors may be used to endorse or promote products derived from 
    this software without specific prior written permission.

  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS
  IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
  THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
  PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR 
  CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
  EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
  PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
  PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
  LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
  NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

package com.adobe.utils
{
	import com.codeTooth.actionscript.lang.utils.Common;
	
	/**
	* 	Class that contains static utility methods for manipulating Strings.
	* 
	* 	@langversion ActionScript 3.0
	*	@playerversion Flash 9.0
	*	@tiptext
	*/		
	public class StringUtil
	{

		
		/**
		*	Does a case insensitive compare or two strings and returns true if
		*	they are equal.
		* 
		*	@param s1 The first string to compare.
		*
		*	@param s2 The second string to compare.
		*
		*	@returns A boolean value indicating whether the strings' values are 
		*	equal in a case sensitive compare.	
		*
		* 	@langversion ActionScript 3.0
		*	@playerversion Flash 9.0
		*	@tiptext
		*/			
		public static function stringsAreEqual(s1:String, s2:String, 
											caseSensitive:Boolean):Boolean
		{
			if(caseSensitive)
			{
				return (s1 == s2);
			}
			else
			{
				return (s1.toUpperCase() == s2.toUpperCase());
			}
		}
		
		/**
		*	Removes whitespace from the front and the end of the specified
		*	string.
		* 
		*	@param input The String whose beginning and ending whitespace will
		*	will be removed.
		*
		*	@returns A String with whitespace removed from the begining and end	
		*
		* 	@langversion ActionScript 3.0
		*	@playerversion Flash 9.0
		*	@tiptext
		*/			
		public static function trim(input:String):String
		{
			return StringUtil.ltrim(StringUtil.rtrim(input));
		}

		/**
		*	Removes whitespace from the front of the specified string.
		* 
		*	@param input The String whose beginning whitespace will will be removed.
		*
		*	@returns A String with whitespace removed from the begining	
		*
		* 	@langversion ActionScript 3.0
		*	@playerversion Flash 9.0
		*	@tiptext
		*/	
		public static function ltrim(input:String):String
		{
			var size:Number = input.length;
			for(var i:Number = 0; i < size; i++)
			{
				if(input.charCodeAt(i) > 32)
				{
					return input.substring(i);
				}
			}
			return "";
		}

		/**
		*	Removes whitespace from the end of the specified string.
		* 
		*	@param input The String whose ending whitespace will will be removed.
		*
		*	@returns A String with whitespace removed from the end	
		*
		* 	@langversion ActionScript 3.0
		*	@playerversion Flash 9.0
		*	@tiptext
		*/	
		public static function rtrim(input:String):String
		{
			var size:Number = input.length;
			for(var i:Number = size; i > 0; i--)
			{
				if(input.charCodeAt(i - 1) > 32)
				{
					return input.substring(0, i);
				}
			}

			return "";
		}

		/**
		*	Determines whether the specified string begins with the spcified prefix.
		* 
		*	@param input The string that the prefix will be checked against.
		*
		*	@param prefix The prefix that will be tested against the string.
		*
		*	@returns True if the string starts with the prefix, false if it does not.
		*
		* 	@langversion ActionScript 3.0
		*	@playerversion Flash 9.0
		*	@tiptext
		*/	
		public static function beginsWith(input:String, prefix:String):Boolean
		{			
			return (prefix == input.substring(0, prefix.length));
		}	

		/**
		*	Determines whether the specified string ends with the spcified suffix.
		* 
		*	@param input The string that the suffic will be checked against.
		*
		*	@param prefix The suffic that will be tested against the string.
		*
		*	@returns True if the string ends with the suffix, false if it does not.
		*
		* 	@langversion ActionScript 3.0
		*	@playerversion Flash 9.0
		*	@tiptext
		*/	
		public static function endsWith(input:String, suffix:String):Boolean
		{
			return (suffix == input.substring(input.length - suffix.length));
		}	

		/**
		*	Removes all instances of the remove string in the input string.
		* 
		*	@param input The string that will be checked for instances of remove
		*	string
		*
		*	@param remove The string that will be removed from the input string.
		*
		*	@returns A String with the remove string removed.
		*
		* 	@langversion ActionScript 3.0
		*	@playerversion Flash 9.0
		*	@tiptext
		*/	
		public static function remove(input:String, remove:String):String
		{
			return StringUtil.replace(input, remove, "");
		}
		
		/**
		*	Replaces all instances of the replace string in the input string
		*	with the replaceWith string.
		* 
		*	@param input The string that instances of replace string will be 
		*	replaces with removeWith string.
		*
		*	@param replace The string that will be replaced by instances of 
		*	the replaceWith string.
		*
		*	@param replaceWith The string that will replace instances of replace
		*	string.
		*
		*	@returns A new String with the replace string replaced with the 
		*	replaceWith string.
		*
		* 	@langversion ActionScript 3.0
		*	@playerversion Flash 9.0
		*	@tiptext
		*/
		public static function replace(input:String, replace:String, replaceWith:String):String
		{
			return input.split(replace).join(replaceWith);
		}
		
		
		/**
		*	Specifies whether the specified string is either non-null, or contains
		*  	characters (i.e. length is greater that 0)
		* 
		*	@param s The string which is being checked for a value
		*
		* 	@langversion ActionScript 3.0
		*	@playerversion Flash 9.0
		*	@tiptext
		*/		
		public static function stringHasValue(s:String):Boolean
		{
			//todo: this needs a unit test
			return (s != null && s.length > 0);			
		}
		
		/**
		 * 判断是否是空字符串
		 * 
		 * @param	str
		 * 
		 * @return
		 */
		public static function isEmpty(str:String):Boolean
		{
			return str == "";
		}
		
		/**
		 * 将指定的字符串转换成布尔类型。字符串"true"将会被转换成布尔true，其他的任何字符串将会被转换成布尔false。
		 * 
		 * @param	str
		 * 
		 * @return
		 */
		public static function toBoolean(str:String):Boolean
		{
			return str == "true" ? true : false;
		}
		
		/**
		 * 判断一个字符串是否有可能是布尔值
		 * 
		 * @param	str
		 * 
		 * @return
		 */
		public static function mayBeBoolean(str:String):Boolean
		{
			return str == "true" || str == "false";
		}
		
		/**
		 * 判断一个字符串是否有可能是数字
		 * 
		 * @param	str
		 * 
		 * @return
		 */
		public static function mayBeNumber(str:String):Boolean
		{
			if (str == "")
			{
				return false;
			}
			else
			{
				var tValue:Number = Number(str);
				
				return !isNaN(tValue);
			}
		}
		
		/**
		 * 判断一个字符串是否可能是正数
		 * 
		 * @param	str
		 * 
		 * @return
		 */
		public static function mayBePositiveNumber(str:String):Boolean
		{
			return mayBeNumber(str) && Number(str) > 0;
		}
		
		/**
		 * 判断一个字符串是否可能是负数
		 * 
		 * @param	str
		 * 
		 * @return
		 */
		public static function mayBeNegativeNumber(str:String):Boolean
		{
			return mayBeNumber(str) && Number(str) < 0;
		}
		
		/**
		 * 判断一个字符串是否有可能是零
		 * 
		 * @param	str
		 * 
		 * @return
		 */
		public static function mayBeZero(str:String):Boolean
		{
			return mayBeNumber(str) && Number(str) == 0
		}
		
		/**
		 * 判断一个字符串是否有可能是整数
		 * 
		 * @param	str
		 * 
		 * @return
		 */
		public static function mayBeInteger(str:String):Boolean
		{
			if (mayBeNumber(str))
			{
				var value:Number = Number(str);
				
				return value == int(value)
			}
			else
			{
				return false;
			}
		}
		
		/**
		 * 判断一个字符串是否可能是正整数
		 * 
		 * @param	str
		 * 
		 * @return
		 */
		public static function mayBePositiveInteger(str:String):Boolean
		{
			return mayBeInteger(str) && int(str) > 0;
		}
		
		/**
		 * 判断一个字符串是否可能是负整数
		 * 
		 * @param	str
		 * 
		 * @return
		 */
		public static function mayBeNegativeInteger(str:String):Boolean
		{
			return mayBeInteger(str) && int(str) < 0;
		}
		
		/**
		 * 判断一个字符串是否可能是无符号整数
		 * 
		 * @param	str
		 * 
		 * @return
		 */
		public static function mayBeUnsignedInteger(str:String):Boolean
		{
			if (mayBeInteger(str))
			{
				var value:int = int(str);
				
				return value >= 0;
			}
			else
			{
				return false;
			}
		}
		
		/**
		 * 判断一个字符串是否可能是null
		 * 
		 * @param	str
		 * 
		 * @return
		 */
		public static function mayBeNULL(str:String):Boolean
		{
			return str == "null"
		}
		
		// 毫秒转时间字符串
		public static const YYYY:int = 1;
		
		public static const MM:int = 2;
		
		public static const DD:int = 4;
		
		public static const HH:int = 8;
		
		public static const MIN:int = 16;
		
		public static const SS:int = 32;
		
		/**
		 * 将毫秒时间转换成字符串
		 * 
		 * @param	millisecond 毫秒
		 * @param	mask 掩码，想要显示时间的哪几部分
		 * @param	yStr
		 * @param	mStr
		 * @param	dStr
		 * @param	hStr
		 * @param	minStr
		 * @param	sStr
		 * 
		 * @return
		 */
		public static function formatMillisecond(
			millisecond:Number, 
			mask:Number = 0x3F,
			gapStr:String = " ", autoFill:Boolean = true, 
			yStr:String = "Year", mStr:String = "Month", dStr:String = "Day", 
			hStr:String = "Hour", minStr:String = "Minute", sStr:String = "Second"):String
		{
			var date:Date = new Date(millisecond);
			var str:String = "";
			var isTail:Boolean = true;
			var time:Number;
			
			if (gapStr == null)
			{
				gapStr = "";
			}
			
			if (mask & SS)
			{
				time = date.getSeconds();
				str = (time < 10 ? ("0" + time) : time) + sStr + (isTail ? str : gapStr + str) ;
				isTail = false;
			}
			if (mask & MIN)
			{
				time = date.getMinutes();
				str = (time < 10 ? ("0" + time) : time) + minStr + (isTail ? str : gapStr + str);
				isTail = false;
			}
			if (mask & HH)
			{
				time = date.getHours();
				str = (time < 10 ? ("0" + time) : time) + hStr + (isTail ? str : gapStr + str);
				isTail = false;
			}
			if (mask & DD)
			{
				time = date.getDate();
				str = (time < 10 ? ("0" + time) : time) + dStr + (isTail ? str : gapStr + str);
				isTail = false;
			}
			if (mask & MM)
			{
				time = date.getMonth() + 1
				str = (time < 10 ? ("0" + time) : time) + mStr + (isTail ? str : gapStr + str);
				isTail = false;
			}
			if (mask & YYYY)
			{
				time = date.getFullYear();
				str = (time < 10 ? ("0" + time) : time) + yStr + (isTail ? str : gapStr + str);
				isTail = false;
			}
			
			return str;
		}
		
		/**
		 * 判断是否是IPv4地址
		 * 
		 * @param ip
		 * 
		 * @return 
		 */
		public static function isIPv4(ip:String):Boolean
		{
			return new RegExp("\\A^((25[0-5]|2[0-4]\\d|[0-1]?\\d\\d?)\\.){3}(25[0-5]|2[0-4]\\d|[0-1]?\\d\\d?)$\\Z","").test(ip);
		}
		
		/**
		 * 判断是否是IPv6地址。不支持简写的IPv6地址和混合地址。
		 * 
		 * @param ip
		 * 
		 * @return 
		 */
		public static function isIPv6(ip:String):Boolean
		{
			return new RegExp("\\A^\\s*((([0-9A-Fa-f]{1,4}:){7}(([0-9A-Fa-f]{1,4})|:))|(([0-9A-Fa-f]{1,4}:){6}(:|((25[0-5]|2[0-4]\\d|[01]?\\d{1,2})(\\.(25[0-5]|2[0-4]\\d|[01]?\\d{1,2})){3})|(:[0-9A-Fa-f]{1,4})))|(([0-9A-Fa-f]{1,4}:){5}((:((25[0-5]|2[0-4]\\d|[01]?\\d{1,2})(\\.(25[0-5]|2[0-4]\\d|[01]?\\d{1,2})){3})?)|((:[0-9A-Fa-f]{1,4}){1,2})))|(([0-9A-Fa-f]{1,4}:){4}(:[0-9A-Fa-f]{1,4}){0,1}((:((25[0-5]|2[0-4]\\d|[01]?\\d{1,2})(\\.(25[0-5]|2[0-4]\\d|[01]?\\d{1,2})){3})?)|((:[0-9A-Fa-f]{1,4}){1,2})))|(([0-9A-Fa-f]{1,4}:){3}(:[0-9A-Fa-f]{1,4}){0,2}((:((25[0-5]|2[0-4]\\d|[01]?\\d{1,2})(\\.(25[0-5]|2[0-4]\\d|[01]?\\d{1,2})){3})?)|((:[0-9A-Fa-f]{1,4}){1,2})))|(([0-9A-Fa-f]{1,4}:){2}(:[0-9A-Fa-f]{1,4}){0,3}((:((25[0-5]|2[0-4]\\d|[01]?\\d{1,2})(\\.(25[0-5]|2[0-4]\\d|[01]?\\d{1,2})){3})?)|((:[0-9A-Fa-f]{1,4}){1,2})))|(([0-9A-Fa-f]{1,4}:)(:[0-9A-Fa-f]{1,4}){0,4}((:((25[0-5]|2[0-4]\\d|[01]?\\d{1,2})(\\.(25[0-5]|2[0-4]\\d|[01]?\\d{1,2})){3})?)|((:[0-9A-Fa-f]{1,4}){1,2})))|(:(:[0-9A-Fa-f]{1,4}){0,5}((:((25[0-5]|2[0-4]\\d|[01]?\\d{1,2})(\\.(25[0-5]|2[0-4]\\d|[01]?\\d{1,2})){3})?)|((:[0-9A-Fa-f]{1,4}){1,2})))|(((25[0-5]|2[0-4]\\d|[01]?\\d{1,2})(\\.(25[0-5]|2[0-4]\\d|[01]?\\d{1,2})){3})))(%.+)?\\s*$\\Z","").test(ip);
		}
		
		/**
		 * 判断输入是否在合法的端口范围内
		 * 
		 * @param input
		 * 
		 * @return 
		 */
		public static function isLegalPort(input:String):Boolean
		{
			if(mayBeUnsignedInteger(input))
			{
				var port:uint = uint(input);
				return port <= Common.SHORT_MAX;
			}
			else
			{
				return false;
			}
		}
	}
}