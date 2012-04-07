package com.codeTooth.actionscript.game.action
{
	import com.codeTooth.actionscript.lang.utils.destroy.IDestroy;
	
	public class ActionData implements IDestroy
	{
		private var _id:Number = 0;
		
		private var _numEmptyClipPrefix:int = 0;
		private var _clipsData:Vector.<ClipData> = null;
		private var _numEmptyClipSuffix:int = 0;
		
		private var _origionX:int = 0;
		
		private var _origionY:int = 0;
		
		public function ActionData(id:Number, clipsData:Vector.<ClipData>, origionX:int = 0, origionY:int = 0)
		{
			_id = id;
			_clipsData = clipsData;
			_origionX = origionX;
			_origionY = origionY;
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
		
		public function addEmptyClipPrefix():void
		{
			var emptyClipData:ClipData = new ClipData(0, 0, 0, 0, 0, 0, 0, 0);
			_clipsData.unshift(emptyClipData);
			_numEmptyClipPrefix++;
		}
		
		public function removeEmptyClipPrefix():void
		{
			if(_numEmptyClipPrefix > 0)
			{
				_clipsData.shift();
				_numEmptyClipPrefix--;
			}
		}
		
		public function removeAllEmptyClipsPrefix():void
		{
			if(_numEmptyClipPrefix > 0)
			{
				_clipsData.splice(0, _numEmptyClipPrefix);
				_numEmptyClipPrefix = 0;
			}
		}
		
		public function get numEmptyClipsPrefix():int
		{
			return _numEmptyClipPrefix;
		}
		
		public function addEmptyClipSuffix():void
		{
			var emptyClipData:ClipData = new ClipData(0, 0, 0, 0, 0, 0, 0, 0);
			_clipsData.push(emptyClipData);
			_numEmptyClipSuffix++;
		}
		
		public function removeEmptyClipSuffix():void
		{
			if(_numEmptyClipSuffix > 0)
			{
				_clipsData.pop();
				_numEmptyClipSuffix--
			}
		}
		
		public function removeAllEmptyClipsSuffix():void
		{
			if(_numEmptyClipSuffix > 0)
			{
				_clipsData.splice(_clipsData.length - _numEmptyClipSuffix, _numEmptyClipSuffix);
				_numEmptyClipSuffix = 0;
			}
		}
		
		public function get numEmptyClipsSuffix():int
		{
			return _numEmptyClipSuffix;
		}
		
		public function removeAllEmptyClips():void
		{
			removeAllEmptyClipsPrefix();
			removeAllEmptyClipsSuffix();
		}
		
		public function getClipsData():Vector.<ClipData>
		{
			return _clipsData;
		}
		
		public function clone():ActionData
		{
			if(_clipsData == null)
			{
				return new ActionData(_id, _clipsData);
			}
			else
			{
				var newClipsData:Vector.<ClipData> = new Vector.<ClipData>();
				for each(var clipData:ClipData in _clipsData)
				{
					newClipsData.push(clipData.clone());
				}
				
				return new ActionData(_id, newClipsData);
			}
		}
		
		public function destroy():void
		{
			_clipsData = null;
		}

	}
}