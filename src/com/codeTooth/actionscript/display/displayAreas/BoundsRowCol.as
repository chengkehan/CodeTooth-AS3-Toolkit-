package com.codeTooth.actionscript.display.displayAreas
{
	internal class BoundsRowCol
	{
		private var _rowFrom:int = 0;
		
		private var _colFrom:int = 0;
		
		private var _rowTo:int = 0;
		
		private var _colTo:int = 0;
		
		public function BoundsRowCol(rowFrom:int = 0, colFrom:int = 0, rowTo:int = 0, colTo:int = 0)
		{
			_rowFrom = rowFrom;
			_colFrom = colFrom;
			_rowTo = rowTo;
			_colTo = colTo;
		}
		
		public function get rowFrom():int
		{
			return _rowFrom;
		}

		public function set rowFrom(value:int):void
		{
			_rowFrom = value;
		}

		public function get colFrom():int
		{
			return _colFrom;
		}

		public function set colFrom(value:int):void
		{
			_colFrom = value;
		}

		public function get rowTo():int
		{
			return _rowTo;
		}

		public function set rowTo(value:int):void
		{
			_rowTo = value;
		}

		public function get colTo():int
		{
			return _colTo;
		}

		public function set colTo(value:int):void
		{
			_colTo = value;
		}
		
		public function clone():BoundsRowCol
		{
			return new BoundsRowCol(_rowFrom, _colFrom, _rowTo, _colTo);
		}
		
		public function toString():String
		{
			return "[object BoundsRowCol(rowFrom:" + _rowFrom + ", rowTo" + _rowTo + ", colFrom:" + _colFrom + ", colTo:" + _colTo + ")]";
		}
	}
}