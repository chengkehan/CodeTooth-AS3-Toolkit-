package com.wirelust.as3zlib {
	import flash.utils.ByteArray;

	import flash.external.ExternalInterface;
	
	public class System {
		public function System() {
			
		}
		
		public static function arrayCopy(src:Array, srcPos:int, dest:Array, destPos:int, length:int):void {
			for (var i:int=0; i<length; i++) {
				dest[destPos + i] = src[srcPos + i];
			} 
		} 

		public static function byteArrayCopy(src:ByteArray, srcPos:int, dest:ByteArray, destPos:int, length:int):void {
			for (var i:int=0; i<length; i++) {
				dest[destPos + i] = src[srcPos + i];
			} 
		} 
		
		public static function println(msg:String):void {
			CONFIG::DEBUG
			{
				trace(msg);
			}
			// FIXME Donot print in console of web browser
			//ExternalInterface.call( "console.log", msg);
		}

	}
}