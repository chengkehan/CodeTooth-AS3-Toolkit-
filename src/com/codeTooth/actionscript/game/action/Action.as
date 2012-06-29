package com.codeTooth.actionscript.game.action
{
	import com.codeTooth.actionscript.lang.exceptions.NullPointerException;
	import com.codeTooth.actionscript.lang.utils.destroy.IDestroy;
	
	import flash.display.Bitmap;
	
	/**
	 * 帧动画
	 */
	public class Action extends Bitmap implements IDestroy, IAction
	{
		// 帧动画所使用的数据
		private var _actionData:ActionData = null;
		private var _clips:Vector.<ClipData> = null;
		
		// 当前播放到第几帧
		private var _currClipIndex:int = 0;
		
		// 总帧数
		private var _numClips:int = 0;
		
		// 是否可刷新
		private var _refreshable:Boolean = false;
		
		private var _fps:uint = 0;
		
		public function Action(actionData:ActionData = null)
		{
			_refreshable = true;
			setActionData(actionData);
		}
		
		public function setActionData(actionData:ActionData):void
		{
			if(_actionData != actionData)
			{
				_actionData = actionData;
				_currClipIndex = 0;
				_clips = _actionData == null ? null : _actionData.getClipsData();
				_numClips = _clips == null || _clips.length == 0 ? 0 : _clips.length;
			}
		}
		
		public function getActionData():ActionData
		{
			return _actionData;
		}
		
		public function set fps(value:uint):void
		{
			_fps = value;
		}
		
		public function get fps():uint
		{
			return _fps;
		}
		
		/**
		 * 总帧数
		 */
		public function get numClips():int
		{
			return _numClips;
		}
		
		/**
		 * 当前播放到第几帧
		 */
		public function get currentClipIndex():int
		{
			return _currClipIndex;
		}
		
		/**
		 * 是否可刷新
		 */
		public function set refreshable(bool:Boolean):void
		{
			_refreshable = bool;
		}
		
		/**
		 * @privete
		 */
		public function get refreshable():Boolean
		{
			return _refreshable;
		}
		
		/**
		 * 添加前置空帧
		 * 
		 * @param amount
		 */
		public function addEmptyClipPrefix(amount:int = 1):void
		{
			if(_numClips != 0)
			{
				for (var i:int = 0; i < amount; i++) 
				{
					_actionData.addEmptyClipPrefix();
				}
				_numClips = _clips.length;
			}
		}
		
		/**
		 * 删除前置空帧
		 * 
		 * @param amount
		 */
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
		
		/**
		 * 删除所有的前置空帧
		 */
		public function removeAllEmptyClipsPrefix():void
		{
			if(_numClips != 0)
			{
				_actionData.removeAllEmptyClipsPrefix();
			}
		}
		
		/**
		 * 前置空帧数量
		 */
		public function get numEmptyClipsPrefix():int
		{
			return _numClips == 0 ? 0 : _actionData.numEmptyClipsPrefix;
		}
		
		/**
		 * 添加后置空帧
		 * 
		 * @param amount
		 */
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
		
		/**
		 * 删除后置空帧
		 * 
		 * @param amount
		 */
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
		
		/**
		 * 删除所有的后置空帧
		 */
		public function removeAllEmptyClipsSuffix():void
		{
			if(_numClips != 0)
			{
				_actionData.removeAllEmptyClipsSuffix();
			}
		}
		
		/**
		 * 后置空帧数量
		 */
		public function get numEmptyClipsSuffix():int
		{
			return _numClips == 0 ? 0 : _actionData.numEmptyClipsSuffix;
		}
		
		/**
		 * 删除所有的前置和后置空帧
		 */
		public function removeAllEmptyClips():void
		{
			if(_numClips != 0)
			{
				_actionData.removeAllEmptyClipsPrefix();
				_actionData.removeAllEmptyClipsSuffix();
			}
		}
		
		/**
		 * 指定播放到第几帧
		 * 
		 * @param index
		 */
		public function gotoClip(index:int):void
		{
			if(_numClips == 0)
			{
				_currClipIndex = 0;
			}
			else
			{
				_currClipIndex = Math.min(Math.max(index, 0), _numClips - 1);
			}
		}
		
		/**
		 * 刷新显示
		 */
		public function refreshClip():void
		{
			if(!_refreshable)
			{
				return;
			}
			if(_numClips == 0)
			{
				bitmapData = null;
				return;
			}

			performanceClip(_currClipIndex);
		}
		
		/**
		 * 跳转到下一帧
		 */
		public function nextClip():void
		{
			_currClipIndex = _currClipIndex + 1 >= _numClips ? 0 : _currClipIndex + 1;
		}
		
		private function performanceClip(clipIndex:int):void
		{
			var clip:ClipData = _clips[clipIndex];
			bitmapData = clip.bitmapData;
			if(bitmapData != null)
			{
				super.x = _x - _actionData.origionX - clip.frameX;
				super.y = _y - _actionData.origionY - clip.frameY;
			}
		}
		
		//------------------------------------------------------------------------------------------------------------------------------
		// 重写 xy 方法
		//------------------------------------------------------------------------------------------------------------------------------
		
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

		//------------------------------------------------------------------------------------------------------------------------------
		// 实现 IDestroy 接口
		//------------------------------------------------------------------------------------------------------------------------------
		
		public function destroy():void
		{
			bitmapData = null;
			_actionData = null;
			_clips = null;
			_numClips = 0;
		}
	}
}