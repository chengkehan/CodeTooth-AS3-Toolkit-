package com.codeTooth.actionscript.game.map.pathSearching 
{
	import com.codeTooth.actionscript.algorithm.pathSearching.base.NetNodesBase;
	import com.codeTooth.actionscript.algorithm.pathSearching.base.Node;
	import com.codeTooth.actionscript.game.map.Map;
	import com.codeTooth.actionscript.game.map.MapInitializeParameters;
	import com.codeTooth.actionscript.lang.exceptions.NullPointerException;
	import com.codeTooth.actionscript.lang.utils.Common;
	import flash.geom.Point;
	
	/**
	 * 矩形地图菱形砖块寻路。
	 * 为了更好的路径形状，寻路网格采用另一种坐标。
	 * 示意图。（行_列）
	 * 0_0         -1_1  
	 *       0_1         -1_2
	 * 1_1         0_2
	 *       1_2         0_3
	 * 2_2         1_3  
	 *       2_3         1_4
	 * 3_3         2_4
	 *       3_4         2_5
	 */
	public class RectangleMapDiamondTilesPathSearching extends CustomNetNodesPathSearching
	{
		private var _newRowCol:Point = null;
		
		public function RectangleMapDiamondTilesPathSearching(map:Map) 
		{
			_newRowCol = new Point();
			super(map);
		}
		
		//---------------------------------------------------------------------------------------------------------------------------------------------------------------
		// 重写创建寻路网格
		//---------------------------------------------------------------------------------------------------------------------------------------------------------------
		
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
			
			return new CustomNetNodes(mapInitParams.rows, mapInitParams.cols, Common.DELIM, mapInitParams.getSeachingDirection(), getNewRowCol);
		}
		
		//---------------------------------------------------------------------------------------------------------------------------------------------------------------
		// 重写寻路
		//---------------------------------------------------------------------------------------------------------------------------------------------------------------
		
		override public function addUnwalkable(row:int, col:int):Boolean
		{
			var newPoint:Point = getNewRowCol(row, col);
			return super.addUnwalkable(newPoint.y, newPoint.x);
		}
		
		override public function removeUnwalkable(row:int, col:int):Boolean
		{
			var newPoint:Point = getNewRowCol(row, col);
			return super.removeUnwalkable(newPoint.y, newPoint.x);
		}
		
		override public function search(rowFrom:int, colFrom:int, rowTo:int, colTo:int):Vector.<Vector.<int>>
		{
			var from:Point = getNewRowCol(rowFrom, colFrom).clone();
			var to:Point = getNewRowCol(rowTo, colTo);
			var path:Vector.<Vector.<int>> = super.search(from.y, from.x, to.y, to.x);
			if (path == null)
			{
				return null;
			}
			else
			{
				var aPath:Vector.<int> = path[0];
				var length:int = aPath.length;
				var origRowCol:Point;
				for (var i:int = 0; i < length; i += 2)
				{
					origRowCol = getOrigRowCol(aPath[i], aPath[i + 1]);
					aPath[i] = origRowCol.y;
					aPath[i + 1] = origRowCol.x;
				}
				
				return path;
			}
		}
		
		//---------------------------------------------------------------------------------------------------------------------------------------------------------------
		// 行列坐标转换
		//---------------------------------------------------------------------------------------------------------------------------------------------------------------
		
		// 获得转换后的新坐标
		private function getOrigRowCol(newRow:int, newCol:int):Point
		{
			_newRowCol.x = newCol - newRow;
			_newRowCol.y = int((newCol - newRow) * .5) + newRow;
			
			return _newRowCol;
		}
		
		// 通过新坐标，获得原始坐标
		private function getNewRowCol(origRow:int, origCol:int):Point
		{
			_newRowCol.y = origRow - int(origCol * .5);
			_newRowCol.x = origCol + _newRowCol.y;
			
			return _newRowCol;
		}
	}

}


import com.codeTooth.actionscript.algorithm.pathSearching.base.NetNodesBase;
import com.codeTooth.actionscript.algorithm.pathSearching.base.Node;
import com.codeTooth.actionscript.algorithm.pathSearching.base.SearchingDirection;
import com.codeTooth.actionscript.lang.utils.Common;
import flash.geom.Point;

class CustomNetNodes extends NetNodesBase
{
	private var _getNewRowCol:Function = null;
	
	public function CustomNetNodes(rows:uint, cols:uint, delim:String, searchingDirection:SearchingDirection, getNewRowCol:Function)
	{
		_getNewRowCol = getNewRowCol;		
		super(rows, cols, delim, searchingDirection);
	}
	
	override protected function createNodes(rows:uint, cols:uint, delim:String):void
	{
		var node:Node;
		var neighbours:Vector.<Node>;
		var id:String;
		var newRowCol:Point;
		
		for (var row:int = 0; row < rows; row++)
		{
			for (var col:int = 0; col < cols; col++)
			{
				newRowCol = _getNewRowCol(row, col);
				node = new Node(newRowCol.y, newRowCol.x, delim);
				_nodes[node] = node;
			}
			
		}
		
		for (row = 0; row < rows; row++)
		{
			for (col = 0; col < cols; col++)
			{
				newRowCol = _getNewRowCol(row, col);
				node = _nodes[newRowCol.y + delim + newRowCol.x];
				neighbours = node.neighbours;
				
				id = node.row + Common.DELIM + (node.col - 1);
				if (_nodes[id] != undefined)
				{
					neighbours.push(_nodes[id]);
				}
				
				id = node.row + Common.DELIM + (node.col + 1);
				if (_nodes[id] != undefined)
				{
					neighbours.push(_nodes[id]);
				}
				
				id = (node.row - 1) + Common.DELIM + node.col;
				if (_nodes[id] != undefined)
				{
					neighbours.push(_nodes[id]);
				}
				
				id = (node.row + 1) + Common.DELIM + node.col;
				if (_nodes[id] != undefined)
				{
					neighbours.push(_nodes[id]);
				}
				
				// 八方向
				if (_searchingDirection != SearchingDirection.EIGHT || _searchingDirection == SearchingDirection.ALL)
				{
					continue;
				}
				
				id = (node.row - 1) + Common.DELIM + (node.col - 1);
				if (_nodes[id] != undefined)
				{
					neighbours.push(_nodes[id]);
				}
				
				id = (node.row + 1) + Common.DELIM + (node.col + 1);
				if (_nodes[id] != undefined)
				{
					neighbours.push(_nodes[id]);
				}
				
				id = (node.row - 1) + Common.DELIM + (node.col + 1);
				if (_nodes[id] != undefined)
				{
					neighbours.push(_nodes[id]);
				}
				
				id = (node.row + 1) + Common.DELIM + (node.col - 1);
				if (_nodes[id] != undefined)
				{
					neighbours.push(_nodes[id]);
				}
			}
		}
	}
}