package com.codeTooth.actionscript.game.map.pathSearching 
{
	import com.codeTooth.actionscript.algorithm.pathSearching.aStarLike.AStarLike;
	import com.codeTooth.actionscript.algorithm.pathSearching.base.NetNodesBase;
	import com.codeTooth.actionscript.algorithm.pathSearching.base.SearchingDirection;
	import com.codeTooth.actionscript.lang.exceptions.NullPointerException;
	import com.codeTooth.actionscript.game.map.Map;
	import com.codeTooth.actionscript.game.map.tile.TileDataBase;
	
	/**
	 * 自定义寻路网格
	 */
	public class CustomNetNodesPathSearching extends AStarLike 
	{
		
		public function CustomNetNodesPathSearching(map:Map) 
		{
			super(map.getMapInitializeParameters().rows, map.getMapInitializeParameters().cols, map.getMapInitializeParameters().getSeachingDirection(), createNetNodes(map));
			
			// 设置不可行走区域
			var tiles:Vector.<TileDataBase> = map.getTilesData();
			if (tiles == null)
			{
				throw new NullPointerException("Null tiles");
			}
			
			for each(var tile:TileDataBase in tiles)
			{
				if (tile.unwalkable)
				{
					addUnwalkable(tile.y, tile.x);
				}
			}
		}
		
		protected function createNetNodes(map:Map):NetNodesBase
		{
			return null;
		}
		
	}

}