package com.codeTooth.actionscript.patterns.subject
{
	import com.codeTooth.actionscript.lang.exceptions.NoSuchObjectException;
	import com.codeTooth.actionscript.lang.exceptions.NullPointerException;
	import com.codeTooth.actionscript.lang.utils.destroy.DestroyUtil;
	import com.codeTooth.actionscript.lang.utils.destroy.IDestroy;
	
	import flash.utils.Dictionary;

	public class Subjects implements IDestroy
	{
		public var _subjects:Dictionary = null;
		
		public function Subjects()
		{
			_subjects = new Dictionary();
		}
		
		public function addSubjectsCall(...subjectIDs):void
		{
			for each(var subjectID:Object in subjectIDs)
			{
				addSubject(subjectID);
			}
		}
		
		public function addSubject(subjectID:Object, subject:Subject = null):void
		{
			if(subjectID == null)
			{
				throw new NullPointerException("Null subject id");
			}
			
			_subjects[subjectID] = subject == null ? new Subject() : subject;
		}
		
		public function removeSubject(subjectID:Object):Subject
		{
			var subject:Subject = _subjects[subjectID];
			delete _subjects[subjectID];
			
			return subject;
		}
		
		public function contiansSubject(subjectID:Object):Boolean
		{
			return _subjects[subjectID] != null;
		}
		
		public function getSubject(subjectID:Object):Subject
		{
			return _subjects[subjectID];
		}
		
		public function notifySubject(subjectID:Object, data:INofityData = null):void
		{
			var subject:Subject = _subjects[subjectID];
			if(subject == null)
			{
				throw new NoSuchObjectException("Has not the subject \"" + subjectID + "\"");
			}
			if(data == null)
			{
				var notifyData:NotifyData = new NotifyData();
				notifyData.setSubjectID(subjectID);
				subject.notify(notifyData);
			}
			else
			{
				data.setSubjectID(subjectID);
				subject.notify(data);
			}
		}
		
		public function followSubject(observer:IObserver, subjectID:Object):void
		{
			var subject:Subject = _subjects[subjectID];
			if(subject == null)
			{
				throw new NoSuchObjectException("Has not the subject \"" + subjectID + "\"");
			}
			subject.addObserver(observer);
		}
		
		public function unfollowSubject(observer:IObserver, subjectID:Object):void
		{
			var subject:Subject = _subjects[subjectID];
			if(subject == null)
			{
				throw new NoSuchObjectException("Has not the subject \"" + subjectID + "\"");
			}
			subject.removeObserver(observer);
		}
		
		public function destroy():void
		{
			DestroyUtil.breakMap(_subjects);
			_subjects = null;
		}
	}
}