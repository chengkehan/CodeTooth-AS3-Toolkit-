package com.codeTooth.actionscript.game.action
{
	import com.codeTooth.actionscript.lang.exceptions.NoSuchObjectException;
	import com.codeTooth.actionscript.lang.utils.destroy.DestroyUtil;
	import com.codeTooth.actionscript.lang.utils.destroy.IDestroy;
	
	import flash.display.BitmapData;
	import flash.utils.Dictionary;

	public class ClipsDataManager implements IDestroy
	{
		private var _clipsDataMap:Dictionary/*key id:Number, value:Vector.<ClipData>*/ = new Dictionary();
		
		public function createClipsData(id:Number, sparrow:XML, bmpd:BitmapData):Boolean
		{
			if(containsClipsData(id))
			{
				return false;
			}
			else
			{
				var clipsData:Vector.<ClipData> = ActionUtil.createClipsBySparrow(sparrow);
				ActionUtil.sliceClips(bmpd, clipsData);
				_clipsDataMap[id] = clipsData;
				
				return true;
			}
		}
		
		public function destroyClipsData(id:Number):Boolean
		{
			if(containsClipsData(id))
			{
				ActionUtil.destroyClips(getClipsData(id));
				delete _clipsDataMap[id];
				
				return true;
			}
			else
			{
				return false;
			}
		}
		
		public function getClipsData(id:Number):Vector.<ClipData>
		{
			if(!containsClipsData(id))
			{
				throw new NoSuchObjectException("Cannot find the clipsData id \"" + id + "\"");
			}
			
			return _clipsDataMap[id];
		}
		
		public function cloneClipsData(id:Number):Vector.<ClipData>
		{
			var clipsData:Vector.<ClipData> = getClipsData(id);
			var newClipsData:Vector.<ClipData> = new Vector.<ClipData>();
			for each(var clipData:ClipData in clipsData)
			{
				newClipsData.push(clipData.clone());
			}
			
			return newClipsData;
		}
		
		public function containsClipsData(id:Number):Boolean
		{
			return _clipsDataMap[id] != null;
		}
		
		public function destroy():void
		{
			for(var id:Object in _clipsDataMap)
			{
				destroyClipsData(Number(id));
			}
			DestroyUtil.breakMap(_clipsDataMap);
			_clipsDataMap = null;
		}
	}
}