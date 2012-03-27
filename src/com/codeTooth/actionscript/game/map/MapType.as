package com.codeTooth.actionscript.game.map
{
	import com.codeTooth.actionscript.lang.exceptions.NoSuchObjectException;
	
	import flash.errors.IllegalOperationError;
	
	/**
	 * 地图类型
	 */
	public class MapType
	{
		/**
		 * 矩形地图，矩形砖块
		 */
		public static const RECTANGLE_MAP_RECTANGLE_TILE:MapType = createInstance(RECTANGLE_MAP_RECTANGLE_TILE_STRING);
		private static const RECTANGLE_MAP_RECTANGLE_TILE_STRING:String = "rectangleMapRectangleTile";
		
		/**
		 * 菱形地图菱形砖块
		 */
		public static const DIAMOND_MAP_DIAMOND_TILE:MapType = createInstance(DIAMOND_MAP_DIAMOND_TILE_STRING);
		private static const DIAMOND_MAP_DIAMOND_TILE_STRING:String = "diamondMapDiamondTile";
		
		/**
		 * 矩形地图菱形砖块
		 */
		public static const RECTANGLE_MAP_DIAMOND_TILE:MapType = createInstance(RECTANGLE_MAP_DIAMOND_TILE_STRING);
		private static const RECTANGLE_MAP_DIAMOND_TILE_STRING:String = "rectangleMapDiamondTile";
		
		/**
		 * 矩形地图六边形砖块
		 */
		public static const RECTANGLE_MAP_HEXAGON_TILE:MapType = createInstance(RECTANGLE_MAP_HEXAGON_TILE_STRING);
		private static const RECTANGLE_MAP_HEXAGON_TILE_STRING:String = "rectangleMapHexagonTile"
		
		/**
		 * 通过地图类型对象的字符串形式或的地图类型对象
		 * 
		 * @param	mapTypeStr
		 * 
		 * @return	返回字符串对应的地图类型对象。如果字符串没有对应的对象，返回null
		 * 
		 * @throws 没有找到指定字符串对应的地图类型对象
		 */
		public static function getMapTypeByString(mapTypeStr:String):MapType
		{
			var mapType:MapType = 
				mapTypeStr == RECTANGLE_MAP_RECTANGLE_TILE_STRING ? RECTANGLE_MAP_RECTANGLE_TILE : 
				mapTypeStr == DIAMOND_MAP_DIAMOND_TILE_STRING ? DIAMOND_MAP_DIAMOND_TILE : 
				mapTypeStr == RECTANGLE_MAP_DIAMOND_TILE_STRING ? RECTANGLE_MAP_DIAMOND_TILE :
				mapTypeStr == RECTANGLE_MAP_HEXAGON_TILE_STRING ? RECTANGLE_MAP_HEXAGON_TILE : null;
			
			if(mapType == null)
			{
				throw new NoSuchObjectException("Has not the mapType \"" + mapTypeStr + "\"");
			}
			
			return mapType;
		}
		
		// 记录常量的字符串形式
		private var _type:String = null;
		
		public function MapType(type:String)
		{
			if (!_allowInstance)
			{
				throw new IllegalOperationError();
			}
			
			_type = type;
		}
		
		// 只允许类内部创建对象
		private static var _allowInstance:Boolean = false;
		
		private static function createInstance(type:String):MapType
		{
			_allowInstance = true;
			var instance:MapType = new MapType(type);
			_allowInstance = false;
			
			return instance;
		}
		
		public function toString():String
		{
			return _type;
		}
		
	}

}