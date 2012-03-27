package com.codeTooth.actionscript.patterns.subject
{
	public class NotifyData implements INofityData
	{
		private var _subjectID:Object = null;
		
		public function NotifyData()
		{
		}
		
		public function setSubjectID(id:Object):void
		{
			_subjectID = id;
		}
		
		public function getSubjectID():Object
		{
			return _subjectID;
		}
	}
}