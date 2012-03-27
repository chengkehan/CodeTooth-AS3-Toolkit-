package com.codeTooth.actionscript.lang.utils 
{
	import com.codeTooth.actionscript.core.codeTooth_internal;
	import com.codeTooth.actionscript.lang.utils.collection.Collection;
	import flash.events.Event;
	import flash.events.FileListEvent;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.Dictionary;
	
	/**
	 * 文件助手。自动销毁对象、添加、移除侦听
	 */
	public class FileUtil extends Collection
	{
		use namespace codeTooth_internal;
		
		private static var _eventTypes:Vector.<String> = Vector.<String>([Event.SELECT, IOErrorEvent.IO_ERROR, SecurityErrorEvent.SECURITY_ERROR, FileListEvent.SELECT_MULTIPLE, Event.COMPLETE, FileListEvent.DIRECTORY_LISTING, Event.CANCEL]);
		
		private static var _fileItems:Dictionary = new Dictionary();
		
		//---------------------------------------------------------------------------------------------------------------------------------------------------------
		// 保存文件
		//---------------------------------------------------------------------------------------------------------------------------------------------------------
		
		// 写文件流
		private static var _writeStream:Function = null;
		
		// 异常处理
		private static var _exceptionCatcher:Function = null;
		
		// 保存成功后调用
		private static var _saveSuccess:Function = null;
		
		/**
		 * 保存
		 * 
		 * @param	writeStream	写文件流。原型func(stream:Stream):void
		 * @param	exceptionCatcher 写流时的异常处理。原型func(error:Error):void
		 * @param	saveSuccess 成功保存后调用。原型func(void)void 
		 * @param	saveDialogTitle 保存对话框的标题
		 * @param	cancelHandler 取消保存时触发。原型func(event:Event):void
		 * 
		 * @return	返回成功创建文件对象。如果当一次保存操作还没有结束就再次调用，返回null
		 */
		public static function save(writeStream:Function = null, exceptionCatcher:Function = null, saveSuccess:Function = null, saveDialogTitle:String = "Save", cancelHandler:Function = null):File
		{
			if (containsFileStatic("_$FileUtil_internal$_"))
			{
				return null;
			}
			else
			{
				_writeStream = writeStream;
				_exceptionCatcher = exceptionCatcher;
				_saveSuccess = saveSuccess;
				var file:File = createFileStatic("_$FileUtil_internal$_", true, selectSaveInternalHandler, null, null, null, null, null, cancelHandler);
				file.browseForSave(saveDialogTitle);
				
				return file;
			}
		}
		
		private static function selectSaveInternalHandler(event:Event):void
		{
			var stream:FileStream = new FileStream();
			try
			{
				stream.open(getFileStatic("_$FileUtil_internal$_"), FileMode.WRITE);
				if (_writeStream != null)
				{
					_writeStream(stream);
				}
				
				if (_saveSuccess != null)
				{
					_saveSuccess();
				}
			}
			catch (error:Error)
			{
				if (_exceptionCatcher != null)
				{
					_exceptionCatcher(error);
				}
			}
			finally
			{
				if(stream != null)
				{
					stream.close();
				}
			}
		}
		
		private static function breakSaveParams():void
		{
			_saveSuccess = null;
			_writeStream = null;
			_exceptionCatcher = null;
		}
		
		//---------------------------------------------------------------------------------------------------------------------------------------------------------
		// 静态方法
		//---------------------------------------------------------------------------------------------------------------------------------------------------------
		
		/**
		 * @copy #createFile()
		 */
		public static function createFileStatic(id:Object, autoDelete:Boolean = true, 
			selectHandler:Function = null, ioErrorHandler:Function = null, securityErrorHandler:Function = null, 
			selectMultipleHandler:Function = null, completeHandler:Function = null, directoryListingHandler:Function = null, cancelHandler:Function = null):File
		{
			if (_fileItems[id] == undefined)
			{
				var fileItem:FileItem = new FileItem(deleteFileStatic, autoDelete, _eventTypes, id, 
					selectHandler, ioErrorHandler, securityErrorHandler, 
					selectMultipleHandler, completeHandler, directoryListingHandler, cancelHandler
				);
				_fileItems[id] = fileItem;
				
				return fileItem.getFile();
			}
			else
			{
				return null;
			}
		}
		
		/**
		 * @copy #deleteFile()
		 */
		public static function deleteFileStatic(id:Object):Boolean
		{
			if (_fileItems[id] == undefined)
			{
				return false;
			}
			else
			{
				var fileItem:FileItem = _fileItems[id];
				fileItem.destroy();
				delete _fileItems[id];
				breakSaveParams();
				
				return true;
			}
		}
		
		/**
		 * @copy #getFile()
		 */
		public static function getFileStatic(id:Object):File
		{
			if (_fileItems[id] == undefined)
			{
				return null;
			}
			else
			{
				return _fileItems[id].getFile();
			}
		}
		
		/**
		 * @copy #containsFile()
		 */
		public static function containsFileStatic(id:Object):Boolean
		{
			return _fileItems[id] != undefined;
		}
		
		//---------------------------------------------------------------------------------------------------------------------------------------------------------
		// 动态方法
		//---------------------------------------------------------------------------------------------------------------------------------------------------------
		
		/**
		 * 创建一个文件
		 * 
		 * @param	id	ID号，不能重复
		 * @param	autoDelete	是否自动删除。当触发Select、IOError、SecurityError和Cancel事件时会自动删除
		 * @param	selectHandler
		 * @param	ioErrorHandler
		 * @param	securityErrorHandler
		 * @param	selectMultipleHandler
		 * @param	completeHandler
		 * @param	directoryListingHandler
		 * @param	cancelHandler
		 * 
		 * @return	返回成功创建的File对象。如果指定了重复的ID，返回null
		 */
		public function createFile(id:Object, autoDelete:Boolean = true, 
			selectHandler:Function = null, ioErrorHandler:Function = null, securityErrorHandler:Function = null, 
			selectMultipleHandler:Function = null, completeHandler:Function = null, directoryListingHandler:Function = null, cancelHandler:Function = null):File
		{
			if (containsItem(id))
			{
				return null;
			}
			else
			{
				return addItem(id, 
					new FileItem(deleteFile, autoDelete, _eventTypes, id, 
						selectHandler, ioErrorHandler, securityErrorHandler, 
						selectMultipleHandler, completeHandler, directoryListingHandler, cancelHandler
					)
				).getFile();
			}
		}
		
		/**
		 * 删除一个文件
		 * 
		 * @param	id
		 * 
		 * @return	返回是否成功删除了文件。不存在指定的文件，返回false
		 */
		public function deleteFile(id:Object):Boolean
		{
			if (containsItem(id))
			{
				removeItem(id).destroy();
				breakSaveParams();
				
				return true;
			}
			else
			{
				return false;
			}
		}
		
		/**
		 * 获得一个指定ID号的文件对象
		 * 
		 * @param	id
		 * 
		 * @return	不存在指定ID号的文件返回null
		 */
		public function getFile(id:Object):File
		{
			if (containsItem(id))
			{
				return getItem(id).getFile();
			}
			else
			{
				return null;
			}
		}
		
		/**
		 * 判断是否包含了指定ID号的文件
		 * 
		 * @param	id
		 * 
		 * @return
		 */
		public function containsFile(id:Object):Boolean
		{
			return containsItem(id);
		}
	}

}


import com.codeTooth.actionscript.lang.utils.destroy.DestroyUtil;
import com.codeTooth.actionscript.lang.utils.destroy.IDestroy;
import com.codeTooth.actionscript.lang.utils.ListenerUtil;
import flash.events.Event;
import flash.events.FileListEvent;
import flash.events.IOErrorEvent;
import flash.events.SecurityErrorEvent;
import flash.filesystem.File;

class FileItem implements IDestroy
{
	private var _deleteFunc:Function = null;
	
	private var _autoDelete:Boolean = false;
	
	private var _file:File = null;
	
	private var _eventTypes:Vector.<String> = null;
	
	private var _id:Object = null;
	
	private var _handlers:Vector.<Function> = null;
	
	private var _selectHandler:Function = null;
	
	private var _ioErrorHandler:Function = null;
	
	private var _securityErrorHandler:Function = null;
	
	private var _selectMulipleHandler:Function = null;
	
	private var _completeHandler:Function = null;
	
	private var _directoryListingHandler:Function = null;
	
	private var _cancelHandler:Function = null;
	
	public function FileItem(deleteFunc:Function, autoDelete:Boolean, eventTypes:Vector.<String>, id:Object, 
		pSelectHandler:Function, pIOErrorHandler:Function, pSecurityErrorHandler:Function, 
		pSelectMultipleHandler:Function, pCompleteHandler:Function, pDirectoryListingHandler:Function, pCancelHandler:Function)
	{
		_autoDelete = autoDelete;
		_deleteFunc = deleteFunc;
		_file = new File();
		_id = id;
		_eventTypes = eventTypes;
		
		_selectHandler = pSelectHandler;
		_ioErrorHandler = pIOErrorHandler;
		_securityErrorHandler = pSecurityErrorHandler;
		_selectMulipleHandler = pSelectMultipleHandler;
		_completeHandler = pCompleteHandler;
		_directoryListingHandler = pDirectoryListingHandler;
		_cancelHandler = pCancelHandler;
		
		_handlers = Vector.<Function>([
			selectHandler, 
			ioErrorHandler, 
			securityErrorHandler, 
			pSelectMultipleHandler == null ? null : selectMultipleHandler,
			pCompleteHandler == null ? null : completeHandler, 
			pDirectoryListingHandler == null ? null : directoryListingHandler, 
			cancelHandler
		]);
		
		ListenerUtil.addListeners(_file, _eventTypes, _handlers);
	}
	
	public function getFile():File
	{
		return _file;
	}
	
	private function deleteMe():void
	{
		if (_autoDelete)
		{
			_deleteFunc(_id);
		}
	}
	
	private function executeHandler(handler:Function, event:Event):void
	{
		if (handler != null)
		{
			handler.length == 0 ? handler() : handler(event);
		}
	}
	
	private function selectHandler(event:Event):void
	{
		executeHandler(_selectHandler, event);
		deleteMe();
	}
	
	private function ioErrorHandler(event:IOErrorEvent):void
	{
		executeHandler(_ioErrorHandler, event);
		deleteMe();
	}
	
	private function securityErrorHandler(event:SecurityErrorEvent):void
	{
		executeHandler(_securityErrorHandler, event);
		deleteMe();
	}
	
	private function selectMultipleHandler(event:FileListEvent):void
	{
		executeHandler(_selectMulipleHandler, event);
		deleteMe();
	}
	
	private function completeHandler(event:Event):void
	{
		executeHandler(_completeHandler, event);
		deleteMe();
	}
	
	private function directoryListingHandler(event:FileListEvent):void
	{
		executeHandler(_directoryListingHandler, event);
		deleteMe();
	}
	
	private function cancelHandler(event:Event):void
	{
		executeHandler(_cancelHandler, event);
		deleteMe();
	}
	
	public function destroy():void
	{
		if (_file!= null)
		{
			ListenerUtil.removeListeners(_file, _eventTypes, _handlers);
			_file = null;
			DestroyUtil.breakVector(_handlers);
			_handlers = null;
			_eventTypes = null;
			_id = null;
			_deleteFunc = null;
			_selectHandler = null;
			_ioErrorHandler = null;
			_securityErrorHandler = null;
			_selectMulipleHandler = null;
			_completeHandler = null;
			_directoryListingHandler = null;
			_cancelHandler = null;
		}
	}
}