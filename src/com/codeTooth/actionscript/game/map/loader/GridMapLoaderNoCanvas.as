package com.codeTooth.actionscript.game.map.loader
{
	import com.codeTooth.actionscript.display.SimpleBigBitmap;
	import com.codeTooth.actionscript.lang.exceptions.IllegalParameterException;
	import com.codeTooth.actionscript.lang.utils.Common;
	import com.codeTooth.actionscript.lang.utils.destroy.DestroyUtil;
	import com.codeTooth.actionscript.lang.utils.destroy.IDestroy;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.IBitmapDrawable;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	import flash.utils.Dictionary;
	
	public class GridMapLoaderNoCanvas extends Sprite implements IDestroy
	{
		private var _debug:Boolean = false;
		
		public function GridMapLoaderNoCanvas(mapWidth:uint, mapHeight:uint, 
									  cellWidth:uint = 200, cellHeight:Number = 200, 
									  blurMapPath:String = null, loadBufferThickness:uint = 0, 
									  pathTemplate:String = "asset/map/1/grid/_$row$_x_$col$_.jpg", 
									  rowPlaceholder:String = "_$row$_", colPlaceholder:String = "_$col$_", 
									  rowStartIndex:uint = 1, colStartIndex:uint = 1)
		{
			if(cellWidth == 0)
			{
				throw new IllegalParameterException("Illegal cellWidth \"" + cellWidth + "\"");
			}
			if(cellHeight == 0)
			{
				throw new IllegalParameterException("Illegal cellHeight \"" + cellHeight + "\"");
			}
			_cellWidth = cellWidth;
			_cellHeight = cellHeight;
			
			if(mapWidth == 0)
			{
				throw new IllegalParameterException("Illegal mapWidth \"" + _mapWidth + "\"");
			}
			if(mapHeight == 0)
			{
				throw new IllegalParameterException("Illegal mapHeight \"" + _mapHeight + "\"");
			}
			_mapWidth = mapWidth;
			_mapHeight = mapHeight;
			
			if(_mapWidth % _cellWidth != 0)
			{
				throw new IllegalParameterException("Illegal mapWidth \"" + mapWidth + "\" or illegal cellWidth \"" + cellWidth + "\"");
			}
			if(_mapHeight % _cellHeight != 0)
			{
				throw new IllegalParameterException("Illegal mapHeight \"" + mapHeight + "\" or illegal cellHeight \"" + cellHeight + "\"");
			}
			
			_pathTemplate = pathTemplate;
			_rowPlaceholder = rowPlaceholder;
			_colPlaceholder = colPlaceholder;
			_rowStartIndex = rowStartIndex;
			_colStartIndex = colStartIndex;
			_rowEndIndex = _rowStartIndex + _mapHeight / _cellHeight - 1;
			_colEndIndex = _colStartIndex + _mapWidth / _cellWidth - 1;
			_blurMapPath = blurMapPath;
			_loadBufferThickness = loadBufferThickness;
			
			mouseChildren = false;
			
			initializePath();
			initializeLoaders();
			initializeViewPort();
			initializeBlurMap();
		}
		
		public function set debug(bool:Boolean):void
		{
			_debug = bool;
		}
		
		public function get debug():Boolean
		{
			return _debug;
		}
		
		//----------------------------------------------------------------------------------------------------------------------------------
		// Path
		//----------------------------------------------------------------------------------------------------------------------------------
		
		private var _pathTemplate:String = null;
		
		private var _rowPlaceholder:String = null;
		
		private var _colPlaceholder:String = null;
		
		private var _rowStartIndex:uint = 0;
		
		private var _colStartIndex:uint = 0;
		
		private var _rowEndIndex:uint = 0;
		
		private var _colEndIndex:uint = 0;
		
		private var _rowMajorOrder:Boolean = false;
		
		private var _pathPrefix:String = null;
		
		private var _pathCenter:String = null;
		
		private var _pathSuffix:String = null;
		
		public function set pathTemplate(pathTemplate:String):void
		{
			if(_pathTemplate != pathTemplate)
			{
				clearCanvas();
				_pathTemplate = pathTemplate;
				initializePath();
				load();
			}
		}
		
		public function get pathTemplate():String
		{
			return _pathTemplate;
		}
		
		public function get rowPlaceholder():String
		{
			return _rowPlaceholder;
		}
		
		public function get colPlaceholder():String
		{
			return _colPlaceholder;
		}
		
		public function get rowStartIndex():uint
		{
			return _rowStartIndex;
		}
		
		public function get colStartIndex():uint
		{
			return _colStartIndex;
		}
		
		public function get rowEndIndex():uint
		{
			return _rowEndIndex;
		}
		
		public function get colEndIndex():uint
		{
			return _colEndIndex;
		}
		
		public function get rowMajorOrder():Boolean
		{
			return _rowMajorOrder;
		}
		
		private function initializePath():void
		{
			if(_pathTemplate.indexOf(_rowPlaceholder) == -1)
			{
				throw new IllegalParameterException(
					"PathTemplate \"" + _pathTemplate + "\" dosnot contains rowPlaceholder \"" + _rowPlaceholder + "\""
				);
			}
			if(_pathTemplate.indexOf(_colPlaceholder) == -1)
			{
				throw new IllegalParameterException(
					"PathTemplate \"" + _pathTemplate + "\" dosnot contains colPlaceholder \"" + _colPlaceholder + "\""
				);
			}
			
			var rowPlaceholderStartIndex:uint = _pathTemplate.indexOf(_rowPlaceholder);
			var colPlaceholderStartIndex:uint = _pathTemplate.indexOf(_colPlaceholder);
			var rowPlaceholderLength:uint = _rowPlaceholder.length;
			var colPlaceholderLength:uint = _colPlaceholder.length;
			_rowMajorOrder = rowPlaceholderStartIndex < colPlaceholderStartIndex;
			
			if(_rowMajorOrder)
			{
				if(rowPlaceholderStartIndex + rowPlaceholderLength >= colPlaceholderStartIndex)
				{
					throw new IllegalParameterException("RowPlaceholder intersect with ColPlaceholder");
				}
				
				_pathPrefix = _pathTemplate.split(_rowPlaceholder)[0];
				_pathSuffix = _pathTemplate.split(_colPlaceholder)[1];
				_pathCenter = _pathTemplate.substring(rowPlaceholderStartIndex + rowPlaceholderLength, colPlaceholderStartIndex);
			}
			else
			{
				if(colPlaceholderStartIndex + colPlaceholderLength > rowPlaceholderStartIndex)
				{
					throw new IllegalParameterException("ColPlaceholder intersect with RowPlaceholder");
				}
				
				_pathPrefix = _pathTemplate.split(_colPlaceholder)[0];
				_pathSuffix = _pathTemplate.split(_rowPlaceholder)[1];
				_pathCenter = _pathTemplate.substring(colPlaceholderStartIndex + colPlaceholderLength, rowPlaceholderStartIndex);
			}
		}
		
		private function getPath(row:uint, col:uint):String
		{
			return _rowMajorOrder ? 
				_pathPrefix + row + _pathCenter + col + _pathSuffix : 
				_pathPrefix + col + _pathCenter + row + _pathSuffix;
		}
		
		//----------------------------------------------------------------------------------------------------------------------------------
		// ViewPort
		//----------------------------------------------------------------------------------------------------------------------------------
		
		private var _viewPort:Rectangle = null;
		
		public function setViewPort(x:Number, y:Number, width:Number, height:Number):void
		{
			_viewPort.x = x;
			_viewPort.y = y;
			_viewPort.width = width;
			_viewPort.height = height;
			load();
		}
		
		public function getViewPort():Rectangle
		{
			return _viewPort.clone();
		}
		
		private function initializeViewPort():void
		{
			_viewPort = new Rectangle();
		}
		
		//----------------------------------------------------------------------------------------------------------------------------------
		// Loaders
		//----------------------------------------------------------------------------------------------------------------------------------
		
		private var _cellLoaders:Dictionary/*key cellLoader.id, value CellLoader*/ = null;
		
		private var _cellWidth:uint = 0;
		
		private var _cellHeight:uint = 0;
		
		private var _cellLoaderBuffer:Vector.<CellLoader> = null;
		
		public function get cellWidth():uint
		{
			return _cellWidth;
		}
		
		public function get cellHeight():uint
		{
			return _cellHeight;
		}
		
		private function initializeLoaders():void
		{
			_cellLoaders = new Dictionary();
			_cellLoaderBuffer = new Vector.<CellLoader>();
		}
		
		private function load():void
		{
			var rowFrom:uint = _rowStartIndex + _viewPort.y / _cellHeight;
			rowFrom = Math.min(Math.max(rowFrom - _loadBufferThickness, _rowStartIndex), _rowEndIndex);
			
			var rowTo:uint = _rowStartIndex + Math.ceil((_viewPort.y + _viewPort.height) / _cellHeight);
			rowTo = Math.min(Math.max(rowTo + _loadBufferThickness, _rowStartIndex), _rowEndIndex);
			
			var colFrom:uint = _colStartIndex + _viewPort.x / _cellWidth;
			colFrom = Math.min(Math.max(colFrom - _loadBufferThickness, _colStartIndex), _colEndIndex);
			
			var colTo:uint = _colStartIndex + Math.ceil((_viewPort.x + _viewPort.width) / _cellWidth);
			colTo = Math.min(Math.max(colTo + _loadBufferThickness, _colStartIndex), _colEndIndex);
			
			for(var row:uint = rowFrom; row <= rowTo; row++)
			{
				for(var col:uint = colFrom; col <= colTo; col++)
				{
					var id:String = row + Common.DELIM + col;
					if(_cellLoaders[id] == null)
					{
						var loader:CellLoader = new CellLoader(id, getPath(row, col), row, col, _debug, cellLoaderComplete);
						_cellLoaders[id] = loader;
					}
				}
			}
		}
		
		private function cellLoaderComplete(loader:CellLoader):void
		{
			if(hasBlurMap)
			{
				if(_blurMapComplete)
				{
					drawACellLoader(loader);
				}
				else
				{
					_cellLoaderBuffer.push(loader);
				}
			}
			else
			{
				drawACellLoader(loader);
			}
		}
		
		private function drawCellLoaderBuffer():void
		{
			if(_cellLoaderBuffer.length > 0)
			{
				for each(var loader:CellLoader in _cellLoaderBuffer)
				{
					drawACellLoader(loader);
				}
				DestroyUtil.breakVector(_cellLoaderBuffer);
			}
		}
		
		private function drawACellLoader(loader:CellLoader):void
		{
			var toX:uint = (loader.col - _colStartIndex) * _cellWidth;
			var toY:uint = (loader.row - _rowStartIndex) * _cellHeight;
			loader.getLoader().x = toX;
			loader.getLoader().y = toY;
			addChild(loader.getLoader());
		}
		
		private function destroyLoaders():void
		{
			DestroyUtil.destroyMap(_cellLoaders);
			_cellLoaders = null;
			DestroyUtil.destroyVector(_cellLoaderBuffer);
			_cellLoaderBuffer = null;
		}
		
		//----------------------------------------------------------------------------------------------------------------------------------
		// BlurMap
		//----------------------------------------------------------------------------------------------------------------------------------
		
		private var _blurMapLoader:Loader = null;
		
		private var _blurMapPath:String = null;
	
		private var _blurMapComplete:Boolean = false;
		
		public function get blurMapPath():String
		{
			return _blurMapPath;
		}
		
		private function initializeBlurMap():void
		{
			if(hasBlurMap)
			{
				_blurMapLoader = new Loader();
				addBlurMapLoaderListeners();
				_blurMapLoader.load(new URLRequest(_blurMapPath));
			}
		}
		
		private function get hasBlurMap():Boolean
		{
			return _blurMapPath != null;
		}
		
		private function addBlurMapLoaderListeners():void
		{
			_blurMapLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, loadBlurMapCompleteHandler);
			_blurMapLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, loadBlurMapIOErrorHandler);
		}
		
		private function removeBlurMapLoaderListeners():void
		{
			_blurMapLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, loadBlurMapCompleteHandler);
			_blurMapLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, loadBlurMapIOErrorHandler);
		}
		
		private function loadBlurMapIOErrorHandler(event:IOErrorEvent):void
		{
			if(_debug)
			{
				trace("Load blur map ioError \"" + _blurMapPath + "\"");
			}
		}
		
		private function loadBlurMapCompleteHandler(event:Event):void
		{
			var bmp:Bitmap = Bitmap(_blurMapLoader.content);
			if(bmp.width != _mapWidth)
			{
				bmp.width = _mapWidth;
			}
			if(bmp.height != _mapHeight)
			{
				bmp.height = _mapHeight;
			}
			
			addChildAt(_blurMapLoader, 0);
			_blurMapComplete = true;
			drawCellLoaderBuffer();
		}
		
		private function destroyBlurMap():void
		{
			if(_blurMapLoader != null)
			{
				removeBlurMapLoaderListeners();
			}
			DestroyUtil.destroyObject(_blurMapLoader);
			_blurMapLoader = null;
		}
		
		//----------------------------------------------------------------------------------------------------------------------------------
		// Map
		//----------------------------------------------------------------------------------------------------------------------------------
		
		private var _mapWidth:uint = 0;
		
		private var _mapHeight:uint = 0;
		
		private var _loadBufferThickness:uint = 0;
		
		public function get mapWidth():uint
		{
			return _mapWidth;
		}
		
		public function get mapHeight():uint
		{
			return _mapHeight;
		}
		
		//----------------------------------------------------------------------------------------------------------------------------------
		// Canvas
		//----------------------------------------------------------------------------------------------------------------------------------
		
		public function clearCanvas():void
		{
			for each(var loader:CellLoader in _cellLoaders)
			{
				if(loader.getLoader().parent == this)
				{
					removeChild(loader.getLoader());
				}
			}
			DestroyUtil.destroyMap(_cellLoaders);
		}
		
		private function destroyCanvas():void
		{
			clearCanvas();
			_cellLoaders = null;
		}
		
		//----------------------------------------------------------------------------------------------------------------------------------
		// 实现 IDestroy 接口
		//----------------------------------------------------------------------------------------------------------------------------------
		
		public function destroy():void
		{
			destroyCanvas();
			destroyLoaders();
			destroyBlurMap();
		}
	}
}