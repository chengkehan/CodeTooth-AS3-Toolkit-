package com.codeTooth.actionscript.game.map.pathSearching 
{
	import com.codeTooth.actionscript.game.map.Map;
	
	/**
	 * 矩形地图矩形砖块寻路。寻路网格采用和 RectangleMapRectangeTiles 相同的坐标
	 */
	public class RectangleMapRectangleTilesPathSearching extends CustomNetNodesPathSearching
	{
		
		public function RectangleMapRectangleTilesPathSearching(map:Map) 
		{	
			super(map);
		}
		
	}

}