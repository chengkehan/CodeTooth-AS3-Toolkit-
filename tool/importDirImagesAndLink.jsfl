// 把一个指定目录下的所有图片导入到库，并且可以自动添加带前缀和去格式后缀的链接名
var willContinue = confirm("功能说明：把一个指定目录下的所有图片导入到库，并且可以自动添加带前缀和去格式后缀的链接名");

if(willContinue)
{
	var document = fl.getDocumentDOM();
	
	if(document == null)
	{
		alert("没有找到打开的文档");
	}
	else
	{
		// 选择一个要导入的文件夹
		var folderURL = fl.browseForFolderURL("请选择一个文件夹");
		if(folderURL == null)
		{
			alert("全部结束");
		}
		else
		{
			var filesList = FLfile.listFolder(folderURL, "files");
			
			if(filesList == null)
			{
				alert("文件夹不存在");
			}
			else
			{
				var library = document.library;
				var importCount = 0;
				var suffix;
				var imported = new Array();
				
				// 开始导入
				for each(var path in filesList)
				{
					suffix = path.substr(path.length - 3, 3).toLowerCase();
					
					if(suffix == "jpg" || suffix == "png")
					{
						imported.push(path);
						document.importFile(folderURL + "/" + path, true);
						importCount++;
					}
				}
					
				if(importCount == 0)
				{
					alert("没有图片被导入");
				}
				else
				{
					alert("导入完成");
				}
				
				// 自动加链接名
				var willLinked = confirm("在刚导入的内容中，是否要自动加上链接名");
				if(willLinked)
				{
					var linkPrefix = prompt("可以为链接名加上一个前缀");
					if(linkPrefix == null)
					{
						linkPrefix = "";
					}
					
					var willRemoveSuffix = confirm("是否要删除名称中的格式后缀");
					
					// 遍历库中所有的对象
					var itemsInLib = library.items;
					var index;
					var className;
					var classNameLength;
					var suffixIndex;
					for each(item in itemsInLib)
					{
						//如果是刚才导入的
						index = imported.indexOf(item.name);
						if(index != -1)
						{
							item.linkageExportForAS = true;
							item.linkageExportInFirstFrame = true;
							className = linkPrefix + imported[index];;
							classNameLength = className.length;
							suffixIndex = classNameLength - 4;
							
							// 移除格式后缀
							if(willRemoveSuffix)
							{
								if(className.indexOf(".png") == suffixIndex || className.indexOf(".PNG") == suffixIndex || 
								   className.indexOf(".jpg") == suffixIndex || className.indexOf(".JPG") == suffixIndex)
								{
									className = className.substr(0, classNameLength - 4);
								}
							}
							
							item.linkageIdentifier = className;
						}
					}
				}
				
				alert("全部完成");
			}
		}
	}
}