package com.codeTooth.actionscript.data 
{
	import com.codeTooth.actionscript.lang.utils.destroy.DestroyUtil;
	import com.codeTooth.actionscript.lang.utils.destroy.IDestroy;
	
	/**
	 * 翻页工具类
	 */
	public class TurningPage implements IDestroy 
	{
		// 页面数据
		private var _data:Vector.<Object> = null;
	
		// 总页数
		private var _totalPages:int = 0;
		
		// 当前页号
		private var _currentPage:int = 0;
		
		// 每页显示的数量
		private var _amountPerPage:int = 0;
		
		// 当前页数据的起始索引
		private var _fromIndex:int = 0;
		
		// 当前页数据的终止索引
		private var _toIndex:int = 0;
		
		/**
		 * 构造函数
		 * 
		 * @param	data 数据
		 * @param	amountPerPage 每页显示的数量
		 */
		public function TurningPage(data:Vector.<Object> = null, amountPerPage:int = 3) 
		{
			_amountPerPage = amountPerPage;
			this.data = data;
		}
		
		/**
		 * 当前页数据的起始索引
		 */
		public function get fromIndex():int
		{
			return _fromIndex;
		}
		
		/**
		 * 当前页数据的终止索引
		 */
		public function get toIndex():int
		{
			return _toIndex;
		}
		
		/**
		 * 当前页号，第一页的页号是1
		 */
		public function get currentPage():int
		{
			return _currentPage;
		}
		
		/**
		 * 总页数
		 */
		public function get totalPages():int
		{
			return _totalPages;
		}
		
		/**
		 * 是否还有下一页
		 * 
		 * @return
		 */
		public function hasNextPage():Boolean
		{
			return _currentPage + 1 <= _totalPages;
		}
		
		/**
		 * 翻到下一页
		 */
		public function nextPage():void
		{
			_currentPage++;
			updateFromToIndex();
		}
		
		/**
		 *  是否还有上一页
		 * 
		 * @return
		 */
		public function hasPrevPage():Boolean
		{
			return _currentPage - 1 > 0
		}
		
		/**
		 * 翻到上一页
		 */
		public function prevPage():void
		{
			_currentPage--;
			updateFromToIndex();
		}
		
		/**
		 * 是否存在指定的页面
		 * 
		 * @param	page 指定的页号
		 * 
		 * @return
		 */
		public function hasPage(page:int):Boolean
		{
			return page > 0 && page <= _totalPages;
		}
		
		/**
		 * 翻到指定的页面
		 * 
		 * @param	page 指定的页号
		 */
		public function setPage(page:int):void
		{
			_currentPage = page;
			updateFromToIndex();
		}
		
		/**
		 * 页面数据
		 */
		public function set data(data:Vector.<Object>):void
		{
			_fromIndex = 0;
			_toIndex = 0;
			_data = data;
			if (_data == null)
			{
				_totalPages = 0;
				_currentPage = 0;
			}
			else
			{
				_totalPages = Math.ceil(_data.length / _amountPerPage);
				_currentPage = 0;
			}
		}
		
		/**
		 * @private
		 */
		public function get data():Vector.<Object>
		{
			return _data;
		}
		
		// 更新当前页的数据索引号
		private function updateFromToIndex():void
		{
			_fromIndex = (_currentPage - 1) * _amountPerPage;
			_toIndex = Math.min(_data.length, _fromIndex + _amountPerPage);
		}
		
		//--------------------------------------------------------------------------------------------------------------
		// 实现 IDestroy 接口
		//--------------------------------------------------------------------------------------------------------------
		
		/**
		 * @inheritDoc
		 */
		public function destroy():void
		{
			_data = null;
		}
	}

}