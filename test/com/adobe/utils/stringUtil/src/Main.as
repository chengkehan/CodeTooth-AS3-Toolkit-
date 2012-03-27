package 
{
	import com.adobe.utils.StringUtil;
	import flash.display.Sprite;
	import flash.utils.setInterval;
	
	public class Main extends Sprite 
	{
		
		public function Main()
		{
			setInterval(
				function():void
				{
					trace(
						StringUtil.formatMillisecond(
							new Date().getTime(), 
							StringUtil.YYYY | StringUtil.MM | StringUtil.DD | StringUtil.HH | StringUtil.MIN | StringUtil.SS, 
							null, true, "年", "月", "日", "时", "分", "秒"
						)
					);
				}, 1000);
		}
		
	}
	
}