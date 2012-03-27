package com.codeTooth.actionscript.game.map.pathSearching 
{
	import com.codeTooth.actionscript.algorithm.pathSearching.base.NetNodesBase;
	import com.codeTooth.actionscript.game.map.Map;
	import com.codeTooth.actionscript.game.map.MapInitializeParameters;
	import com.codeTooth.actionscript.lang.exceptions.NullPointerException;
	import com.codeTooth.actionscript.lang.utils.Common;
	
	/**
	 * 矩形地图六边形砖块寻路。寻路网格采用和 RectangleMapHexagonTiles 相同的坐标
	 */
	public class RectangleMapHexagonTilesPathSearching extends CustomNetNodesPathSearching
	{
		
		public function RectangleMapHexagonTilesPathSearching(map:Map) 
		{
			super(map);
		}
		
		override protected function createNetNodes(map:Map):NetNodesBase
		{
			if (map == null)
			{
				throw new NullPointerException("Null map");
			}
			
			var mapInitParams:MapInitializeParameters = map.getMapInitializeParameters();
			if (mapInitParams == null)
			{
				throw new NullPointerException("Null mapInitParams");
			}
			
			return new CustomNetNodes(mapInitParams.rows, mapInitParams.cols, Common.DELIM, mapInitParams.getSeachingDirection());
		}
	}

}


import com.codeTooth.actionscript.algorithm.pathSearching.base.NetNodesBase;
import com.codeTooth.actionscript.algorithm.pathSearching.base.Node;
import com.codeTooth.actionscript.algorithm.pathSearching.base.SearchingDirection;

class CustomNetNodes extends NetNodesBase
{
	public function CustomNetNodes(rows:uint, cols:uint, delim:String, searchingDirection:SearchingDirection)
	{
		super(rows, cols, delim, searchingDirection);
	}
	
	override protected function createNodes(rows:uint, cols:uint, delim:String):void
	{
		var node:Node;
		var neighbours:Vector.<Node>;
		
		for (var row:int = 0; row < rows; row++)
		{
			for (var col:int = 0; col < cols; col++)
			{
				node = new Node(row, col, delim);
				_nodes[node] = node;
			}
			
		}
		
		for (row = 0; row < rows; row++)
		{
			for (col = 0; col < cols; col++)
			{
				node = _nodes[row + delim + col];
				neighbours = node.neighbours;
				
				if (col != 0)
				{
					neighbours.push(_nodes[row + delim + (col - 1)]);
				}
				if (col != cols - 1)
				{
					neighbours.push(_nodes[row + delim + (col + 1)]);
				}
				
				// 偶数列
				if ((col & 1) == 0)
				{
					if (row != 0)
					{
						if (col != 0)
						{
							neighbours.push(_nodes[(row - 1) + delim + (col - 1)]);
						}
						if (col != cols - 1)
						{
							neighbours.push(_nodes[(row - 1) + delim + (col + 1)]);
						}
					}
				}
				// 奇数列
				else
				{
					if (row != rows - 1)
					{
						if (col != 0)
						{
							neighbours.push(_nodes[(row + 1) + delim + (col - 1)]);
						}
						if (col != cols - 1)
						{
							neighbours.push(_nodes[(row + 1) + delim + (col + 1)]);
						}
					}
				}
				
				if (row != 0)
				{
					neighbours.push(_nodes[(row - 1) + delim + col]);
				}
				if (row != rows - 1)
				{
					neighbours.push(_nodes[(row + 1) + delim + col]);
				}
			}
		}
	}
}