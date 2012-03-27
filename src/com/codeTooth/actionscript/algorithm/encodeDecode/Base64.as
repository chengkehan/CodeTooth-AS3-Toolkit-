/*
Base64 - 1.1.0

Copyright (c) 2006 Steve Webster

Permission is hereby granted, free of charge, to any person obtaining a copy of
this software and associated documentation files (the "Software"), to deal in
the Software without restriction, including without limitation the rights to
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
the Software, and to permit persons to whom the Software is furnished to do so,
subject to the following conditions: 

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

package com.codeTooth.actionscript.algorithm.encodeDecode  
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.utils.ByteArray;
	
	/**
	 * Base64编码解码
	 * 
	 * @author	Steve Webster
	 * @version	1.0.0
	 * 
	 * Modify by jim
	 * 具体改动见代码中的注释
	 * @version	1.0.1
	 */
	public class Base64 {
		
		// （v1.0.1）添加 BASE64_CHARS 的数组类型 BASE64_CHARS_ARRAY。因为在编码的时候在数组中通过索引检索比String类型的charAt更快，而在解码的时候String类型的indexOf比Array类型的indexOf更快。
		private static const BASE64_CHARS_ARRAY:Array = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z", "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z", "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "+", "/", "="];
		private static const BASE64_CHARS:String = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";
		public static const version:String = "1.0.1";
		
		/**
		 * 对位图进行编码
		 * 
		 * @param	bmpd
		 * 
		 * @return	如果入参为null，返回null
		 * 
		 * @version 1.0.1
		 */
		public static function encodeBitmapData(bmpd:BitmapData):String
		{
			if (bmpd == null)
			{
				return null;
			}
			else
			{
				var pixels:ByteArray = bmpd.getPixels(bmpd.rect);
				// 将位图的宽、高、透明度追加到后面
				pixels.position = pixels.length;
				pixels.writeUnsignedInt(bmpd.width);
				pixels.writeUnsignedInt(bmpd.height);
				pixels.writeBoolean(bmpd.transparent);
				
				return encodeByteArray(pixels);
			}
		}
		
		/**
		 * 解码成位图
		 * 
		 * @param	input	输入要解码的位图字符串，应该是encodeBitmapData方法的返回值
		 * 
		 * @return	如果入参为null返回null
		 * 
		 * @version 1.0.1
		 */
		public static function decodeToBitmapData(input:String):BitmapData
		{
			if (input == null)
			{
				return null;
			}
			else
			{
				var pixels:ByteArray = decodeToByteArray(input);
				var length:int = pixels.length;
				
				// 读取透明度
				pixels.position = length - 1;
				var transparent:Boolean = pixels.readBoolean();
				
				// 读取高
				pixels.position = length - 5;
				var height:int = pixels.readUnsignedInt();
				
				// 读取宽
				pixels.position = length - 9;
				var width:int = pixels.readUnsignedInt();
				
				// 去掉多出来的宽高数据
				// 这个不执行也没关系，因为像素数量的原因，多出来的数据是不会被读到的。
				pixels.length = length - 9;
				
				pixels.position = 0;
				var bmpd:BitmapData = new BitmapData(width, height, transparent, 0x00000000);
				bmpd.setPixels(bmpd.rect, pixels);
				
				return bmpd;
			}
		}
		
		public static function encode(data:String):String {
			// Convert string to ByteArray
			var bytes:ByteArray = new ByteArray();
			bytes.writeUTFBytes(data);
			
			// Return encoded ByteArray
			return encodeByteArray(bytes);
		}
		
		public static function encodeByteArray(data:ByteArray):String {
			// Initialise output
			var output:String = "";
			
			// Create data and output buffers
			// （v1.0.1）原来会在while循环中不断的创建dataBuffer的数组对象，现在改成在while循环外创建数组对象，每次进入while循环的时候将lengh设为0，这样可以达到同样的效果。
			var dataBuffer:Array = new Array();
			var outputBuffer:Array = new Array(4);
			
			// Rewind ByteArray
			data.position = 0;
			
			// while there are still bytes to be processed
			while (data.bytesAvailable > 0) {
				// Create new data buffer and populate next 3 bytes from data
				dataBuffer.length = 0;
				for (var i:uint = 0; i < 3 && data.bytesAvailable > 0; i++) {
					dataBuffer[i] = data.readUnsignedByte();
				}
				
				// Convert to data buffer Base64 character positions and 
				// store in output buffer
				outputBuffer[0] = (dataBuffer[0] & 0xfc) >> 2;
				outputBuffer[1] = ((dataBuffer[0] & 0x03) << 4) | ((dataBuffer[1]) >> 4);
				outputBuffer[2] = ((dataBuffer[1] & 0x0f) << 2) | ((dataBuffer[2]) >> 6);
				outputBuffer[3] = dataBuffer[2] & 0x3f;
				
				// If data buffer was short (i.e not 3 characters) then set
				// end character indexes in data buffer to index of '=' symbol.
				// This is necessary because Base64 data is always a multiple of
				// 4 bytes and is basses with '=' symbols.
				// （v1.0.1）while循环中会通过dataBuffer.length来获得dataBuffer的长度，改成直接用变量i的值来表示dataBuffer的长度，因为当时i正好就等于dataBuffer的length。
				// （v1.0.1）加了一个if判断，如果条件不满足就没必要调用for循环
				if (++i < 4)
				{
					for (var j:uint = i; j < 4; j++) {
						outputBuffer[j] = 64;
					}
				}
				
				// Loop through output buffer and add Base64 characters to 
				// encoded data string for each character.
				// （v1.0.1）while循环中会调用outputBuffer.length属性，但outout的长度永远都等于4，所以直接写成4。
				// （v1.0.1）原来这里是一个for循环，变量从0到小于4。现在去掉了循环。
				output += BASE64_CHARS_ARRAY[outputBuffer[0]];
				output += BASE64_CHARS_ARRAY[outputBuffer[1]];
				output += BASE64_CHARS_ARRAY[outputBuffer[2]];
				output += BASE64_CHARS_ARRAY[outputBuffer[3]];
			}
			
			// Return encoded data
			return output;
		}
		
		public static function decode(data:String):String {
			// Decode data to ByteArray
			var bytes:ByteArray = decodeToByteArray(data);
			
			// Convert to string and return
			return bytes.readUTFBytes(bytes.length);
		}
		
		public static function decodeToByteArray(data:String):ByteArray {
			// Initialise output ByteArray for decoded data
			var output:ByteArray = new ByteArray();
			
			// Create data and output buffers
			var dataBuffer:Array = new Array(4);
			var outputBuffer:Array = new Array(3);

			// While there are data bytes left to be processed
			// （v1.0.1）在循环外获得输入字符串的长度
			var dataLength:int = data.length;
			for (var i:uint = 0; i < dataLength; i += 4) {
				// Populate data buffer with position of Base64 characters for
				// next 4 bytes from encoded data
				for (var j:uint = 0; j < 4 && i + j < dataLength; j++) {
					dataBuffer[j] = BASE64_CHARS.indexOf(data.charAt(i + j));
				}
      			
      			// Decode data buffer back into bytes
				outputBuffer[0] = (dataBuffer[0] << 2) + ((dataBuffer[1] & 0x30) >> 4);
				outputBuffer[1] = ((dataBuffer[1] & 0x0f) << 4) + ((dataBuffer[2] & 0x3c) >> 2);		
				outputBuffer[2] = ((dataBuffer[2] & 0x03) << 6) + dataBuffer[3];
				
				// Add all non-padded bytes in output buffer to decoded data
				for (var k:uint = 0; k < 3; k++) {
					if (dataBuffer[k+1] == 64) break;
					output.writeByte(outputBuffer[k]);
				}
			}
			
			// Rewind decoded data ByteArray
			output.position = 0;
			
			// Return decoded data
			return output;
		}
		
		public function Base64() {
			throw new Error("Base64 class is static container only");
		}
	}
}