package com.codeTooth.actionscript.lang.utils 
{
	import com.codeTooth.actionscript.lang.utils.destroy.DestroyUtil;
	import com.codeTooth.actionscript.lang.utils.destroy.IDestroy;
	import com.codeTooth.actionscript.patterns.observer.IObserver;
	import com.codeTooth.actionscript.patterns.observer.Subject;
	import com.codeTooth.actionscript.patterns.observer.Subjects;
	
	import flash.utils.Dictionary;
	
	/**
	 * 消息处理
	 */
	public class Messager implements IDestroy
	{
		private var _subjects:Subjects = null;
		
		public function Messager() 
		{
			_subjects = new Subjects();
		}
		
		/**
		 * 消息通知
		 * 
		 * @param	id	消息的id
		 * @param	data	通知的数据
		 * 
		 * @return
		 */
		public function notifyMessage(messageID:Object, data:Object = null):Subject
		{
			if (_subjects.containsSubject(messageID))
			{
				var message:Subject = _subjects.getSubject(messageID);
				message.notify(data);
				
				return message;
			}
			else
			{
				return null;
			}
		}
		
		/**
		 * 所有的消息通知
		 * 
		 * @param	data
		 */
		public function notifyMessages(data:Object):void
		{
			var messages:Dictionary = _subjects.getSubjects();
			for each(var message:Subject in messages)
			{
				message.notify(data);
			}
		}
		
		/**
		 * 快速添加多条消息
		 * 
		 * @param args 所有要添加的消息的id号
		 */
		public function addMessagesCall(...messageIDs):void
		{
			for each(var messageID:Object in messageIDs)
			{
				addMessage(messageID);
			}
		}
		
		/**
		 * 快速添加多条消息
		 * 
		 * @param messageIDs 所有要添加的消息的id号
		 */
		public function addMessagesApply(messageIDs:Vector.<Object>):void
		{
			for each(var messageID:Object in messageIDs)
			{
				addMessage(messageID);
			}
		}
		
		/**
		 * 添加一条消息
		 * 
		 * @param	id	消息的id
		 * @param	message	消息对象，如果不指定将使用默认的
		 * 
		 * @return	返回成功添加的消息。如果id号重复会添加失败，返回null
		 */
		public function addMessage(id:Object, message:Subject = null):Subject
		{
			return _subjects.addSubject(id, message == null ? new Subject() : message);
		}
		
		/**
		 * 删除一条消息
		 * 
		 * @param	id
		 * 
		 * @return	返回成功移除的消息。如果不存在指定id的消息，返回null
		 */
		public function removeMessage(id:Object):Subject
		{
			return _subjects.removeSubject(id);
		}
		
		/**
		 * 删除所有的消息
		 */
		public function removeMessages():void
		{
			_subjects.removeSubjects();
		}
		
		/**
		 * 获得一条消息
		 * 
		 * @param	id
		 * 
		 * @return	返回指定id的消息。没有找到返回null
		 */
		public function getMessage(id:Object):Subject
		{
			return _subjects.getSubject(id);
		}
		
		/**
		 * 获得所有的消息。请勿操作集合
		 * 
		 * @return
		 */
		public function getMessages():Dictionary
		{
			return _subjects.getSubjects();
		}
		
		/**
		 * 判断是否包含指定id的消息
		 * 
		 * @param	id
		 * 
		 * @return
		 */
		public function containsMessage(id:Object):Boolean
		{
			return _subjects.containsSubject(id);
		}
		
		/**
		 * 指定的对象开始关注一条消息
		 * 
		 * @param	messageID	要关注的消息的id
		 * @param	target	关注消息的对象
		 * 
		 * @return	返回成功关注消息的对象。
		 * 如果不存在指定id的消息。或，
		 * 关注消息的对象是null，或，
		 * 指定的对象已经在关注这条消息了，返回nulll
		 */
		public function followMessage(messageID:Object, target:IObserver):IObserver
		{
			if (_subjects.containsSubject(messageID))
			{
				return _subjects.getSubject(messageID).addObserver(target);
			}
			else
			{
				return null;
			}
		}
		
		public function followMessagesCall(target:IObserver, ...messageIDs):void
		{
			for each(var messageID:Object in messageIDs)
			{
				followMessage(messageID, target);
			}
		}
		
		public function followMessagesApply(target:IObserver, messageIDs:Vector.<Object>):void
		{
			for each(var messageID:Object in messageIDs)
			{
				followMessage(messageID, target);
			}
		}
		
		/**
		 * 取消对象对指定消息的关注
		 * 
		 * @param	messageID	消息的id
		 * @param	target	指定的对象
		 * 
		 * @return	返回成功取消关注消息的对象。
		 * 如果不存在指定id的消息，或，
		 * 指定的对象并没有在关注这条消息，返回null
		 */
		public function unfollowMessage(messageID:Object, target:IObserver):IObserver
		{
			if (_subjects.containsSubject(messageID))
			{
				var message:Subject = _subjects.getSubject(messageID);
				if (message.containsObserver(target))
				{
					return message.removeObserver(target);
				}
				else
				{
					return null;
				}
			}
			else
			{
				return null;
			}
		}
		
		/**
		 * 取消指定对象关注的所有消息
		 * 
		 * @param	target
		 */
		public function unfollowMessages(target:IObserver):void
		{
			var messages:Dictionary = _subjects.getSubjects();
			for each(var message:Subject in messages)
			{
				message.removeObserver(target);
			}
		}
		
		/**
		 * 获得指定对象正在关注的所有消息
		 * 
		 * @param	target
		 * 
		 * @return	如果指定的对象是null，返回null。如果指定的对象没有关注任何消息，返回一个空集合
		 */
		public function getFollowingMessages(target:IObserver):Vector.<Subject>
		{
			if (target == null)
			{
				return null;
			}
			else
			{
				var following:Vector.<Subject> = new Vector.<Subject>();
				var messages:Dictionary = _subjects.getSubjects();
				for each( var message:Subject in messages)
				{
					if (message.containsObserver(target))
					{
						following.push(message);
					}
				}
				
				return following;
			}
		}
		
		//------------------------------------------------------------------------------------------------------------------------
		// 
		//------------------------------------------------------------------------------------------------------------------------
		
		/**
		 * @inheritDoc
		 */
		public function destroy():void
		{
			DestroyUtil.destroyObject(_subjects);
			_subjects = null;
		}
	}

}