package 
{
	import org.flixel.system.FlxPreloader;
	
	public class Preloader extends FlxPreloader
	{
		public function Preloader():void
		{
			className = "Bonk";
			//myURL = "charliethornton.net/bonk/";
			super();
			minDisplayTime = 1.0;
		}
		
	}
	
}