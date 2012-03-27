package com.codeTooth.actionscript.lang.utils 
{
	import flash.net.LocalConnection;
	public function garbageCollection():void
	{
		try
		{
			new LocalConnection().connect("gc");
			new LocalConnection().connect("gc");
		}
		catch (error:Error)
		{
			CONFIG::DEBUG
			{
				trace("Hack gc!!!");
			}
		}
	}

}