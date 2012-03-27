package com.codeTooth.actionscript.game.map.pathSearching 
{
	import com.codeTooth.actionscript.game.map.Map;
	
	/**
	 * 菱形地图菱形砖块寻路。寻路网格采用和 DiamondMapDiamondTiles 相同的坐标
	 */
	public class DiamondMapDiamondTilesPathSearching extends CustomNetNodesPathSearching
	{
		
		public function DiamondMapDiamondTilesPathSearching(map:Map) 
		{	
			super(map)
		}
		
	}

}