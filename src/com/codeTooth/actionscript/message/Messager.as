package com.codeTooth.actionscript.message
{
	import com.codeTooth.actionscript.lang.exceptions.NoSuchObjectException;
	import com.codeTooth.actionscript.lang.utils.Messager;
	import com.codeTooth.actionscript.lang.utils.destroy.DestroyUtil;
	import com.codeTooth.actionscript.lang.utils.destroy.IDestroy;
	
	import flash.utils.Dictionary;

	public class Messager implements IDestroy
	{
		private var _messager:com.codeTooth.actionscript.lang.utils.Messager = null;
		
		private var _tempNotifyData:MessageNotifyData = null;
		
		public function Messager()
		{
			_messager = new com.codeTooth.actionscript.lang.utils.Messager();
			_tempNotifyData = new MessageNotifyData();
		}
		
		public function notify(messageID:MessageID, data:MessageNotifyData = null):MessageSubject
		{
			if(!containsMessage(messageID))
			{
				throw new NoSuchObjectException("Has not the message \"" + messageID + "\"");
			}
			
			if(data == null)
			{
				data = _tempNotifyData;
				data.messageID = messageID;
			}
			else
			{
				data.messageID = messageID;
			}
			
			return MessageSubject(_messager.notifyMessage(messageID, data));
		}
		
		public function notifyAll(data:MessageNotifyData):void
		{
			_messager.notifyMessages(data);
		}
		
		public function addMessagesCall(...messageIDs):void
		{
			for each(var messageID:MessageID in messageIDs)
			{
				addMessage(messageID);
			}
		}
		
		public function addMessagesApply(messageIDs:Vector.<MessageID>):void
		{
			for each(var messageID:MessageID in messageIDs)
			{
				addMessage(messageID);
			}
		}
		
		public function addMessage(messageID:MessageID, subject:MessageSubject = null):MessageSubject
		{
			return MessageSubject(_messager.addMessage(messageID, subject == null ? new MessageSubject() : subject));
		}
		
		public function removeMessage(messageID:MessageID):MessageSubject
		{
			return MessageSubject(_messager.removeMessage(messageID));
		}
		
		public function removeMessages():void
		{
			_messager.removeMessages();
		}
		
		public function getMessage(messageID:MessageID):MessageSubject
		{
			return MessageSubject(_messager.getMessage(messageID));
		}
		
		public function getMessages():Dictionary
		{
			return _messager.getMessages();
		}
		
		public function containsMessage(messageID:MessageID):Boolean
		{
			return _messager.containsMessage(messageID);
		}
		
		public function followMessage(messageID:MessageID, target:IMessageObserver):IMessageObserver
		{
			if(!containsMessage(messageID))
			{
				throw new NoSuchObjectException("Has not the message \"" + messageID + "\"");
			}
			
			return IMessageObserver(_messager.followMessage(messageID, target));
		}
		
		public function followMessagesCall(target:IMessageObserver, ...messageIDs):void
		{
			for each(var messageID:MessageID in messageIDs)
			{
				followMessage(messageID, target);
			}
		}
		
		public function followMessagesApply(target:IMessageObserver, messageIDs:Vector.<MessageID>):void
		{
			for each(var messageID:MessageID in messageIDs)
			{
				followMessage(messageID, target);
			}
		}
		
		public function unfollowMessageCall(target:IMessageObserver, ...messageIDs):void
		{
			for each(var messageID:MessageID in messageIDs)
			{
				unfollowMessage(messageID, target);
			}
		}
		
		public function unfollowMessageApply(target:IMessageObserver, messageIDs:Vector.<MessageID>):void
		{
			for each(var messageID:MessageID in messageIDs)
			{
				unfollowMessage(messageID, target);
			}
		}
		
		public function unfollowMessage(messageID:MessageID, target:IMessageObserver):IMessageObserver
		{
			return IMessageObserver(_messager.unfollowMessage(messageID, target));
		}
		
		public function unfollowMessages(target:IMessageObserver):void
		{
			return _messager.unfollowMessages(target);
		}
		
		public function getFollowingMessages(target:IMessageObserver):Vector.<MessageSubject>
		{
			return Vector.<MessageSubject>(_messager.getFollowingMessages(target));
		}
		
		//----------------------------------------------------------------------------------------------------------------------------------
		// 实现 IDestroy 接口
		//----------------------------------------------------------------------------------------------------------------------------------
		
		public function destroy():void
		{
			DestroyUtil.destroyObject(_messager);
			_messager = null;
			
			DestroyUtil.destroyObject(_tempNotifyData);
			_tempNotifyData = null;
		}
		
	}
}