package com.codeTooth.actionscript.game.action
{
	import com.codeTooth.actionscript.lang.exceptions.NoSuchObjectException;
	import com.codeTooth.actionscript.lang.utils.destroy.DestroyUtil;
	import com.codeTooth.actionscript.lang.utils.destroy.IDestroy;
	
	import flash.display.BitmapData;
	import flash.utils.Dictionary;

	/**
	 * 剪辑帧数据管理器
	 */
	public class ClipsDataManager implements IDestroy
	{
		private var _clipsDataMap:Dictionary/*key id:Number, value:Vector.<ClipData>*/ = new Dictionary();
		
		/**
		 * 根据传入的SparrowXML和位图，自动创建好所有的剪辑帧。
		 * 如果已经存在相同的id，则不会进行任何操作。
		 * 
		 * @param id
		 * @param sparrow
		 * @param bmpd
		 * 
		 * @return 
		 */
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
		
		/**
		 * 销毁指定id的对应的所有剪辑帧
		 * 
		 * @param id
		 * 
		 * @return 
		 */
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
		
		/**
		 * 获得指定id对应的所有剪辑帧
		 * 
		 * @param id
		 * 
		 * @return 
		 */
		public function getClipsData(id:Number):Vector.<ClipData>
		{
			if(!containsClipsData(id))
			{
				throw new NoSuchObjectException("Cannot find the clipsData id \"" + id + "\"");
			}
			
			return _clipsDataMap[id];
		}
		
		/**
		 * 将指定id对应的所有剪辑帧克隆一份后返回。
		 * 每一个剪辑帧中除了位图切片外的其他数据都将被进行克隆。
		 * 
		 * @param id
		 * 
		 * @return 
		 */
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
		
		/**
		 * 判断是否包含了指定id的剪辑帧集合
		 * 
		 * @param id
		 * @return 
		 */
		public function containsClipsData(id:Number):Boolean
		{
			return _clipsDataMap[id] != null;
		}
		
		/**
		 * @inheritDoc
		 */
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