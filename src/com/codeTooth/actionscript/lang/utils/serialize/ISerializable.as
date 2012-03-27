package com.codeTooth.actionscript.lang.utils.serialize 
{
	
	public interface ISerializable 
	{
		function serialize():*;
		
		function deserialize(data:Object):Boolean;
	}
	
}