package 
{
	import com.codeTooth.actionscript.game.role.Action;
	import com.codeTooth.actionscript.game.role.ActionClip;
	import com.codeTooth.actionscript.game.role.ActionClipFrame;
	import com.codeTooth.actionscript.game.role.ActionClipFrameSlice;
	import com.codeTooth.actionscript.game.role.ClipDirection;
	import com.codeTooth.actionscript.game.role.Role;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.getTimer;
	import flash.utils.Timer;
	import nl.demonsters.debugger.MonsterDebugger;
	
	[SWF(width="1000", height="700", frameRate="60", backgroundColor="0xFF9900")]
	public class Main extends Sprite 
	{
		private var _roles:Vector.<Role> = null;
		private var _numRoles:uint = 216;
		private var _roleCols:uint = 27;
		
		private var _roleSliceWidth:uint = 70;
		private var _roleSliceHeight:uint = 124;
		
		[Embed(source="role.png")]
		private var _roleImage:Class;
		
		[Embed(source = "sword.png")]
		private var _swordImage:Class;
		
		[Embed(source = "cloth.png")]
		private var _clothImage:Class;
		
		private var _timer:Timer = null;
		private var _time:int = 0;
		
		private var _monsterDebugger:MonsterDebugger = null;
		
		public function Main()
		{	
			_monsterDebugger = new MonsterDebugger(this);
			
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			var roleBmpd:BitmapData = new _roleImage().bitmapData;
			var swordBmpd:BitmapData = new _swordImage().bitmapData;
			var clothBmpd:BitmapData = new _clothImage().bitmapData;
			
			var useSword:Boolean = true;
			var useCloth:Boolean = true;
			
			var frames:Vector.<ActionClipFrame> = new Vector.<ActionClipFrame>();
			var slices:Vector.<ActionClipFrameSlice> = new Vector.<ActionClipFrameSlice>();
			frames.push(new ActionClipFrame(slices));
			if (useSword)
			{
				slices.push(new ActionClipFrameSlice(swordBmpd, new Rectangle(0, 0, _roleSliceWidth, _roleSliceHeight), new Point(), -1));
			}
			if (useCloth)
			{
				slices.push(new ActionClipFrameSlice(clothBmpd, new Rectangle(0, 0, _roleSliceWidth, _roleSliceHeight), new Point(), 1));
			}
			
			slices = new Vector.<ActionClipFrameSlice>();
			frames.push(new ActionClipFrame(slices));
			if (useSword)
			{
				slices.push(new ActionClipFrameSlice(swordBmpd, new Rectangle(_roleSliceWidth, 0, _roleSliceWidth, _roleSliceHeight), new Point(), -1));
			}
			if (useCloth)
			{
				slices.push(new ActionClipFrameSlice(clothBmpd, new Rectangle(_roleSliceWidth, 0, _roleSliceWidth, _roleSliceHeight), new Point(), 1));
			}
			
			slices = new Vector.<ActionClipFrameSlice>();
			frames.push(new ActionClipFrame(slices));
			if (useSword)
			{
				slices.push(new ActionClipFrameSlice(swordBmpd, new Rectangle(_roleSliceWidth * 2, 0, _roleSliceWidth, _roleSliceHeight), new Point(), -1));
			}
			if (useCloth)
			{
				slices.push(new ActionClipFrameSlice(clothBmpd, new Rectangle(_roleSliceWidth * 2, 0, _roleSliceWidth, _roleSliceHeight), new Point(), 1));
			}
			
			slices = new Vector.<ActionClipFrameSlice>();
			frames.push(new ActionClipFrame(slices));
			if (useSword)
			{
				slices.push(new ActionClipFrameSlice(swordBmpd, new Rectangle(_roleSliceWidth * 3, 0, _roleSliceWidth, _roleSliceHeight), new Point(), -1));
			}
			if (useCloth)
			{
				slices.push(new ActionClipFrameSlice(clothBmpd, new Rectangle(_roleSliceWidth * 3, 0, _roleSliceWidth, _roleSliceHeight), new Point(), 1));
			}
			
			var actionClips:Vector.<ActionClip> = new Vector.<ActionClip>();
			actionClips.push(new ActionClip(ClipDirection.LEFT, null));
			actionClips.push(new ActionClip(ClipDirection.RIGHT, null));
			actionClips.push(new ActionClip(ClipDirection.UP, null));
			actionClips.push(new ActionClip(ClipDirection.DOWN, frames));
			actionClips.push(new ActionClip(ClipDirection.LEFT_UP, null));
			actionClips.push(new ActionClip(ClipDirection.LEFT_DOWN, null));
			actionClips.push(new ActionClip(ClipDirection.RIGHT_UP, null));
			actionClips.push(new ActionClip(ClipDirection.RIGHT_DOWN, null));
			
			var actions:Vector.<Action> = new Vector.<Action>();
			actions.push(new Action("action1", roleBmpd, _roleSliceWidth, _roleSliceHeight, 0, 0, actionClips));
			
			var tx:Number = 0;
			var ty:Number = -_roleSliceHeight;
			_roles = new Vector.<Role>(_numRoles);
			for (var i:uint = 0; i < _numRoles; i++)
			{
				if (i % _roleCols == 0)
				{
					tx = 0;
					ty += _roleSliceHeight;
				}
				
				var role:Role = new Role(actions);
				role.x = tx;
				role.y = ty;
				addChild(role);
				_roles[i] = role;
				
				tx += _roleSliceWidth;
			}
			
			
			//_timer = new Timer(120);
			//_timer.addEventListener(TimerEvent.TIMER, timerHandler);
			//_timer.start();
			
			addEventListener(Event.ENTER_FRAME, enterFrameHandler);
		}
		
		private function timerHandler(event:TimerEvent):void
		{
			for each(var role:Role in _roles)
			{
				role.playAction("action1", ClipDirection.DOWN);
			}
		}
		
		private function enterFrameHandler(event:Event):void
		{
			var time:int = getTimer();
			if (time - _time > 120)
			{
				_time = time;
				for each(var role:Role in _roles)
				{
					role.playAction("action1", ClipDirection.DOWN);
				}
			}
		}
	}
	
}