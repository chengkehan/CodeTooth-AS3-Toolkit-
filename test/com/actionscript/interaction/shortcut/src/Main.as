package 
{
	import com.codeTooth.actionscript.interaction.shortcuts.Shortcut;
	import com.codeTooth.actionscript.interaction.shortcuts.ShortcutsManager;
	import flash.display.Sprite;
	import flash.ui.Keyboard;
	
	public class Main extends Sprite 
	{
		private var scm:ShortcutsManager = null;
		
		public function Main() 
		{
			scm = new ShortcutsManager(stage);
			scm.addShortcut(new Shortcut(sc1, Keyboard.DOWN, true, true, true, false, true));
		}
		
		private function sc1():void
		{
			trace("sc1", Math.random());
		}
	}
	
}