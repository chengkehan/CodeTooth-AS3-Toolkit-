package com.codeTooth.actionscript.patterns.observer 
{
	import com.codeTooth.actionscript.core.codeTooth_internal;
	import com.codeTooth.actionscript.lang.utils.collection.Collection;
	import flash.utils.Dictionary;
	
	/**
	 * 观察者主题集合
	 */
	public class Subjects extends Collection
	{
		use namespace codeTooth_internal;
		
		public function Subjects() 
		{
			
		}
		
		/**
		 * 指定的主题通知消息
		 * 
		 * @param	subjectID
		 * @param	data
		 * 
		 * @return	返回成功进行了通知的主题对象。如果没有找到指定ID的主题返回null
		 */
		public function notify(subjectID:Object, data:Object = null):Subject
		{
			var subject:Subject = getItem(subjectID);
			if(subject == null)
			{
				return null;
			}
			else
			{
				subject.notify(data);
				
				return subject;
			}
		}
		
		/**
		 * 所有的主题通知消息
		 * 
		 * @param	data
		 */
		public function notifyAll(data:Object = null):void
		{
			for each(var subject:Subject in _items)
			{
				subject.notify(data);
			}
		}
		
		/**
		 * 添加一个主题
		 * 
		 * @param	id
		 * @param	subject
		 * 
		 * @return	返回成功添加的主题。如果指定的主题是null，或者已经存在相同名称的主题返回null
		 */
		public function addSubject(id:Object, subject:Subject):Subject
		{
			if (subject == null || containsItem(id))
			{
				return null;
			}
			else
			{
				return addItem(id, subject);
			}
		}
		
		/**
		 * 删除指定的主题
		 * 
		 * @param	id
		 * 
		 * @return	返回成功删除的主题。如果有找到返回null
		 */
		public function removeSubject(id:Object):Subject
		{
			return removeItem(id);
		}
		
		/**
		 * 获得指定ID的主题
		 * 
		 * @param	id
		 * 
		 * @return	如果没有找到返回null
		 */
		public function getSubject(id:Object):Subject
		{
			return getItem(id);
		}
		
		/**
		 * 判断是否存在指定ID的主题
		 * 
		 * @param	id
		 * 
		 * @return
		 */
		public function containsSubject(id:Object):Boolean
		{
			return containsItem(id);
		}
		
		/**
		 * 获得所有的主题。请勿修改集合
		 * 
		 * @return
		 */
		public function getSubjects():Dictionary
		{
			return getItems();
		}
		
		/**
		 * 清空所有的主题
		 */
		public function removeSubjects():void
		{
			removeItems();
		}
	}

}