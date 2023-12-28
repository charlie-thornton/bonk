package  
{
	import flash.ui.Mouse;
	import flash.events.*;
	import org.flixel.*;
	
	[SWF(width = "640", height = "480", backgroundColor = "#000000")]
	//[Frame(factoryClass="Preloader")] 
	
	public class Bonk extends FlxGame
	{
		public function Bonk() 
		{
			super(640, 480, MenuState, 1, 60, 30);
			
			Mouse.show();
		}
		
		override protected function onKeyUp(event:KeyboardEvent):void
		{
			super.onKeyUp(event);
			Mouse.show();
		}
		
		override protected function onFocus(E:Event = null):void
		{
			super.onFocus(E);
			Mouse.show();
		}
		
	}

}