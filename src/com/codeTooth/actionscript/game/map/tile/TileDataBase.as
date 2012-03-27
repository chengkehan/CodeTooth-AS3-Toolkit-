package com.codeTooth.actionscript.game.map.tile 
{
	import com.codeTooth.actionscript.core.codeTooth_internal;
	import com.codeTooth.actionscript.lang.utils.destroy.IDestroy;
	import com.codeTooth.actionscript.lang.utils.uniqueObject.IUniqueObject;
	
	public class TileDataBase implements IUniqueObject, IDestroy
	{
		use namespace codeTooth_internal;
		
		/**
		 * 构造函数
		 * 
		 * @param	id 砖块数据的id
		 */
		public function TileDataBase(id:Object) 
		{
			_id = id;
		}
		
		//---------------------------------------------------------------------------------------------------------
		// 是否可以行走
		//---------------------------------------------------------------------------------------------------------
		
		private var _unwalkable:Boolean = false;
		
		codeTooth_internal function setUnwalkable(bool:Boolean):void
		{
			_unwalkable = bool;
		}
		
		public function get unwalkable():Boolean
		{
			return _unwalkable;
		}
		
		//---------------------------------------------------------------------------------------------------------
		// 坐标
		//---------------------------------------------------------------------------------------------------------
		
		// 平面x坐标（列）
		private var _x:int = 0;
		
		// 平面y坐标（行）
		private var _y:int = 0;
		
		// 高度z坐标（楼层）
		private var _z:int = 0;
		
		private var _scrX:Number = 0;
		
		private var _scrY:Number = 0;
		
		codeTooth_internal function setX(value:int):void
		{
			_x = value;
		}
		
		public function get x():int
		{
			return _x;
		}
		
		codeTooth_internal function setY(value:int):void
		{
			_y = value;
		}
		
		public function get y():int
		{
			return _y;
		}
		
		codeTooth_internal function setZ(value:int):void
		{
			_z = value;
		}
		
		public function get z():int
		{
			return _z;
		}
		
		codeTooth_internal function setScreenX(value:Number):void
		{
			_scrX = value;
		}
		
		public function get screenX():Number
		{
			return _scrX;
		}
		
		codeTooth_internal function setScreenY(value:Number):void
		{
			_scrY = value;
		}
		
		public function get screenY():Number
		{
			return _scrY;
		}
		
		//---------------------------------------------------------------------------------------------------------
		// 实现 IUniqueObject 接口
		//---------------------------------------------------------------------------------------------------------
		
		private var _id:Object = null;
		
		public function getUniqueID():*
		{
			return _id;
		}
		
		//---------------------------------------------------------------------------------------------------------
		// 实现 IDestroy 接口
		//---------------------------------------------------------------------------------------------------------
		
		public function destroy():void
		{
			// Do something
		}
	}

}