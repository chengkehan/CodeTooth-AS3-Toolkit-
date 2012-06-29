package com.codeTooth.actionscript.game.action
{
	import com.codeTooth.actionscript.lang.utils.destroy.IDestroy;
	
	/**
	 * 动作数据
	 */
	public class ActionData implements IDestroy
	{
		// id号
		private var _id:Number = 0;
		
		// 前置空帧
		private var _numEmptyClipPrefix:int = 0;
		// 剪辑帧
		private var _clipsData:Vector.<ClipData> = null;
		// 后置空帧
		private var _numEmptyClipSuffix:int = 0;
		
		// 注册点坐标
		private var _origionX:int = 0;
		private var _origionY:int = 0;
		
		public function ActionData(id:Number, clipsData:Vector.<ClipData>, origionX:int = 0, origionY:int = 0, numEmptyClipPrefix:int = 0, numEmptyClipSuffix:int = 0)
		{
			_id = id;
			_clipsData = clipsData;
			_origionX = origionX;
			_origionY = origionY;
			_numEmptyClipPrefix = numEmptyClipPrefix;
			_numEmptyClipSuffix = numEmptyClipSuffix;
		}
		
		public function get id():Number
		{
			return _id;
		}

		public function get origionX():int
		{
			return _origionX;
		}
		
		public function set origionX(value:int):void
		{
			_origionX = value;
		}
		
		public function get origionY():int
		{
			return _origionY;
		}
		
		public function set origionY(value:int):void
		{
			_origionY = value;
		}
		
		/**
		 * 添加前置空帧
		 * 
		 * @param amount
		 */
		public function addEmptyClipsPrefix(amount:int):void
		{
			for (var i:int = 0; i < amount; i++) 
			{
				addEmptyClipPrefix();
			}
		}
		
		/**
		 * 添加一个前置空帧
		 */
		public function addEmptyClipPrefix():Boolean
		{
			if(_clipsData == null)
			{
				return false;
			}
			else
			{
				var emptyClipData:ClipData = new ClipData(0, 0, 0, 0, 0, 0, 0, 0);
				_clipsData.unshift(emptyClipData);
				_numEmptyClipPrefix++;
				
				return true;
			}
		}
		
		/**
		 * 删除一个前置空帧
		 */
		public function removeEmptyClipPrefix():Boolean
		{
			if(_clipsData == null)
			{
				return false;
			}
			else
			{
				if(_numEmptyClipPrefix > 0)
				{
					_clipsData.shift();
					_numEmptyClipPrefix--;
					
					return true;
				}
				else
				{
					return false;
				}
			}
		}
		
		/**
		 * 删除全部的前置空帧
		 */
		public function removeAllEmptyClipsPrefix():Boolean
		{
			if(_clipsData == null)
			{
				return false;
			}
			else
			{
				if(_numEmptyClipPrefix > 0)
				{
					_clipsData.splice(0, _numEmptyClipPrefix);
					_numEmptyClipPrefix = 0;
					
					return true;
				}
				else
				{
					return false;
				}
			}
		}
		
		/**
		 * 获得当前前置空帧的数量
		 * 
		 * @return 
		 */
		public function get numEmptyClipsPrefix():int
		{
			return _numEmptyClipPrefix;
		}
		
		/**
		 * 添加后置空帧
		 * 
		 * @param amount
		 */
		public function addEmptyClipsSuffix(amount:int):void
		{
			for (var i:int = 0; i < amount; i++) 
			{
				addEmptyClipSuffix();
			}
		}
		
		/**
		 * 添加一个后置空帧
		 */
		public function addEmptyClipSuffix():Boolean
		{
			if(_clipsData == null)
			{
				return false;
			}
			else
			{
				var emptyClipData:ClipData = new ClipData(0, 0, 0, 0, 0, 0, 0, 0);
				_clipsData.push(emptyClipData);
				_numEmptyClipSuffix++;
				
				return true;
			}
		}
		
		/**
		 * 删除一个后置空帧
		 */
		public function removeEmptyClipSuffix():Boolean
		{
			if(_clipsData == null)
			{
				return false;
			}
			else
			{
				if(_numEmptyClipSuffix > 0)
				{
					_clipsData.pop();
					_numEmptyClipSuffix--;
						
					return true;
				}
				else
				{
					return false;
				}
			}
		}
		
		/**
		 * 删除全部的后置空帧
		 */
		public function removeAllEmptyClipsSuffix():Boolean
		{
			if(_clipsData == null)
			{
				return false;
			}
			else
			{
				if(_numEmptyClipSuffix > 0)
				{
					_clipsData.splice(_clipsData.length - _numEmptyClipSuffix, _numEmptyClipSuffix);
					_numEmptyClipSuffix = 0;
					
					return true;
				}
				else
				{
					return false;
				}
			}
		}
		
		/**
		 * 获得当前后置空帧的数量
		 * 
		 * @return 
		 */
		public function get numEmptyClipsSuffix():int
		{
			return _numEmptyClipSuffix;
		}
		
		/**
		 * 删除所有的前置和后置空帧
		 */
		public function removeAllEmptyClips():void
		{
			removeAllEmptyClipsPrefix();
			removeAllEmptyClipsSuffix();
		}
		
		public function getClipsData():Vector.<ClipData>
		{
			return _clipsData;
		}
		
		//------------------------------------------------------------------------------------------------------------------------------
		// Clone
		//------------------------------------------------------------------------------------------------------------------------------
		
		public function clone():ActionData
		{
			return cloneInternal(clipDataClone);
		}
		
		public function cloneNoBitmapData():ActionData
		{
			return cloneInternal(clipDataCloneNoBitmapData);
		}
		
		private function cloneInternal(clipDataCloneStrategy:Function):ActionData
		{
			if(_clipsData == null)
			{
				return new ActionData(_id, _clipsData, _origionX, _origionY, _numEmptyClipPrefix, _numEmptyClipSuffix);
			}
			else
			{
				var newClipsData:Vector.<ClipData> = new Vector.<ClipData>();
				for each(var clipData:ClipData in _clipsData)
				{
					newClipsData.push(clipDataCloneStrategy(clipData));
				}
				
				return new ActionData(_id, newClipsData, _origionX, _origionY, _numEmptyClipPrefix, _numEmptyClipSuffix);
			}
		}
		
		private function clipDataClone(clipData:ClipData):ClipData
		{
			return clipData.clone();
		}
		
		private function clipDataCloneNoBitmapData(clipData:ClipData):ClipData
		{
			return clipData.cloneNoBitmapData();
		}
		
		//------------------------------------------------------------------------------------------------------------------------------
		// IDestroy
		//------------------------------------------------------------------------------------------------------------------------------
		
		public function destroy():void
		{
			_clipsData = null;
		}
	}
}