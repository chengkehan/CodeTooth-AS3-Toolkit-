package com.codeTooth.actionscript.game.action
{
	import com.codeTooth.actionscript.lang.exceptions.NullPointerException;
	import com.codeTooth.actionscript.lang.utils.destroy.IDestroy;
	
	import flash.display.Bitmap;
	
	public class Action extends Bitmap implements IDestroy
	{
		private var _actionData:ActionData = null;
		
		private var _currClipIndex:int = 0;
		
		private var _clips:Vector.<ClipData> = null;
		
		private var _numClips:int = 0;
		
		private var _timeCount:int = 0;
		
		private var _refreshable:Boolean = false;
		
		public function Action(actionData:ActionData)
		{
			if(actionData == null)
			{
				throw new NullPointerException("Null input actionData parameter.");
			}
			_actionData = actionData;
			_currClipIndex = 0;
			_timeCount = 0;
			_clips = _actionData.getClipsData();
			_numClips = _clips == null || _clips.length == 0 ? 0 : _clips.length;
			_refreshable = true;
		}
		
		public function get numClips():int
		{
			return _numClips;
		}
		
		public function get currentClipIndex():int
		{
			return _currClipIndex;
		}
		
		public function set refreshable(bool:Boolean):void
		{
			_refreshable = bool;
		}
		
		public function get refreshable():Boolean
		{
			return _refreshable;
		}
		
		public function addEmptyClipPrefix(amount:int = 1):void
		{
			if(_numClips != 0)
			{
				for (var i:int = 0; i < amount; i++) 
				{
					_actionData.addEmptyClipPrefix();
				}
				_numClips = _clips.length
			}
		}
		
		public function removeEmptyClipPrefix(amount:int = 1):void
		{
			if(_numClips != 0)
			{
				for (var i:int = 0; i < amount; i++) 
				{
					_actionData.removeEmptyClipPrefix();
				}
				_numClips = _clips.length;
			}
		}
		
		public function removeAllEmptyClipsPrefix():void
		{
			_actionData.removeAllEmptyClipsPrefix();
		}
		
		public function get numEmptyClipsPrefix():int
		{
			return _actionData.numEmptyClipsPrefix;
		}
		
		public function addEmptyClipSuffix(amount:int = 1):void
		{
			if(_numClips != 0)
			{
				for (var i:int = 0; i < amount; i++) 
				{
					_actionData.addEmptyClipSuffix();
				}
				_numClips = _clips.length;
			}
		}
		
		public function removeEmptyClipSuffix(amount:int = 1):void
		{
			if(_numClips != 0)
			{
				for (var i:int = 0; i < amount; i++) 
				{
					_actionData.removeEmptyClipSuffix();
				}
				_numClips = _clips.length;
			}
		}
		
		public function removeAllEmptyClipsSuffix():void
		{
			_actionData.removeAllEmptyClipsSuffix();
		}
		
		public function get numEmptyClipsSuffix():int
		{
			return _actionData.numEmptyClipsSuffix;
		}
		
		public function removeAllEmptyClips():void
		{
			_actionData.removeAllEmptyClipsPrefix();
			_actionData.removeAllEmptyClipsSuffix();
		}
		
		public function getActionData():ActionData
		{
			return _actionData;
		}
		
		public function gotoClip(index:int):void
		{
			_currClipIndex = Math.min(Math.max(index, 0), _numClips - 1);
		}
		
		public function refreshClip():void
		{
			if(!_refreshable)
			{
				return;
			}
			if(_numClips == 0)
			{
				return;
			}

			presentClip(_currClipIndex);
		}
		
		public function nextClip():void
		{
			_currClipIndex = _currClipIndex + 1 >= _numClips ? 0 : _currClipIndex + 1;
		}
		
		private function presentClip(clipIndex:int):void
		{
			var clip:ClipData = _clips[clipIndex];
			bitmapData = clip.bitmapData;
			if(bitmapData != null)
			{
				super.x = _x - _actionData.origionX - clip.frameX;
				super.y = _y - _actionData.origionY - clip.frameY;
			}
		}
		
		private var _x:Number = 0;
		
		private var _y:Number = 0;
		
		override public function get x():Number
		{
			return _x;
		}

		override public function set x(value:Number):void
		{
			_x = value;
		}

		override public function get y():Number
		{
			return _y;
		}

		override public function set y(value:Number):void
		{
			_y = value;
		}

		public function destroy():void
		{
			bitmapData = null;
			_actionData = null;
			_clips = null;
			_numClips = 0;
		}

	}
}