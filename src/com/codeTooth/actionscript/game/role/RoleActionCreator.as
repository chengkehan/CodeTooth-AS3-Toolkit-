package com.codeTooth.actionscript.game.role
{
	import com.codeTooth.actionscript.display.BitmapDataHumanClipD8;
	import com.codeTooth.actionscript.lang.exceptions.NullPointerException;
	import com.codeTooth.actionscript.lang.utils.geom.Mathematic;
	
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;

	public class RoleActionCreator
	{
		public static function create(action:Action):RoleAction
		{
			if(action == null)
			{
				return null;
			}
			else
			{
				var actionClips:Vector.<ActionClip> = action.clips;
				if(actionClips == null || actionClips.length == 0)
				{
					return null;
				}
				else
				{
					var roleD8:BitmapDataHumanClipD8 = new BitmapDataHumanClipD8(
						action.roleBitmapData, action.roleSliceWidth, action.roleSliceHeight, true, 
						action.upDirection, action.downDirection, action.leftDirection, action.rightDirection, 
						action.leftUpDirection, action.leftDownDirection, action.rightUpDirection, action.rightDownDirection
					);
					
					var roleClips:Dictionary = new Dictionary();
					for each(var actionClip:ActionClip in actionClips)
					{
						if(actionClip == null)
						{
							continue;
						}
						var direction:ClipDirection = actionClip.direction;
						if(direction == null)
						{
							continue;
						}
						
						var roleD8Walk:Function = direction == ClipDirection.UP ? roleD8.walkUp : 
							direction == ClipDirection.DOWN ? roleD8.walkDown :
							direction == ClipDirection.LEFT ? roleD8.walkLeft :
							direction == ClipDirection.RIGHT ? roleD8.walkRight : 
							direction == ClipDirection.LEFT_UP ? roleD8.walkLeftUp : 
							direction == ClipDirection.LEFT_DOWN ? roleD8.walkLeftDown : 
							direction == ClipDirection.RIGHT_UP ? roleD8.walkRightUp : 
							direction == ClipDirection.RIGHT_DOWN ? roleD8.walkRightDown : null;
						if(roleD8Walk == null)
						{
							throw new NullPointerException("Null roleD8Walk");
						}
						
						var actionClipFrames:Vector.<ActionClipFrame> = actionClip.frames;
						var roleFrames:Vector.<RoleActionClipFrame> = new Vector.<RoleActionClipFrame>(roleD8.clipCols);
						for(var frameIndex:uint = 0; frameIndex < roleD8.clipCols; frameIndex++)
						{
							roleD8Walk(frameIndex);
							var frameBmpd:BitmapData = null;
							if(actionClipFrames == null || actionClipFrames.length == 0 || 
								frameIndex + 1 > actionClipFrames.length || actionClipFrames[frameIndex] == null ||  
								actionClipFrames[frameIndex].slices == null || actionClipFrames[frameIndex].slices.length == 0)
							{
								frameBmpd = new BitmapData(roleD8.clipWidth, roleD8.clipHeight, true, 0x00000000);
								frameBmpd.copyPixels(roleD8.getBitmapData(), roleD8.getClipRectangle(), new Point());
								roleFrames[frameIndex] = new RoleActionClipFrame(frameBmpd, action.roleStandOnX, action.roleStandOnY);
							}
							else
							{
								var slices:Vector.<ActionClipFrameSlice> = actionClipFrames[frameIndex].slices
								var numSlices:uint = slices.length;
								var sliceRects:Vector.<Rectangle> = new Vector.<Rectangle>(numSlices + 1);
								for(var sliceIndex:uint = 0; sliceIndex < numSlices; sliceIndex++)
								{
									if(slices[sliceIndex].bitmapData == null || slices[sliceIndex].destPoint == null || slices[sliceIndex].rectangle == null)
									{
										sliceRects[sliceIndex] = null;
									}
									else
									{
										var newSliceRect:Rectangle = new Rectangle(
											slices[sliceIndex].destPoint.x, slices[sliceIndex].destPoint.y, 
											slices[sliceIndex].rectangle.width, slices[sliceIndex].rectangle.height
										);
										sliceRects[sliceIndex] = newSliceRect
									}
								}
								sliceRects[sliceIndex] = new Rectangle(0, 0, roleD8.clipWidth, roleD8.clipHeight);
								var combRect:Rectangle = Mathematic.getBoundsRectangle2(sliceRects);
								frameBmpd = new BitmapData(combRect.width, combRect.height, true, 0x00000000);
								slices.sort(slicesSort);
								var roleDrawed:Boolean = false;
								for each(var slice:ActionClipFrameSlice in slices)
								{
									if(slice.bitmapData == null || slice.rectangle == null || slice.destPoint == null)
									{
										continue;
									}
									if(slice.depth >= 0 && !roleDrawed)
									{
										roleDrawed = true;
										frameBmpd.copyPixels(roleD8.getBitmapData(), roleD8.getClipRectangle(), new Point(-combRect.x, -combRect.y), null, null, true);
									}
									frameBmpd.copyPixels(slice.bitmapData, slice.rectangle, 
										new Point(slice.destPoint.x - combRect.x, slice.destPoint.y - combRect.y), null, null, true
									);
								}
								if(!roleDrawed)
								{
									roleDrawed = true;
									frameBmpd.copyPixels(roleD8.getBitmapData(), roleD8.getClipRectangle(), new Point(-combRect.x, -combRect.y), null, null, true);
								}
								roleFrames[frameIndex] = new RoleActionClipFrame(frameBmpd, action.roleStandOnX - combRect.x, action.roleStandOnY - combRect.y);
							}
						}
						roleClips[direction] = new RoleActionClip(direction, roleFrames);
					}
					
					return new RoleAction(action.name, roleClips);
				}
			}
		}
		
		private static function slicesSort(slice1:ActionClipFrameSlice, slice2:ActionClipFrameSlice):int
		{
			return slice1.depth < slice2.depth ? -1 : 1;
		}
	}
}