package  
{
	import org.flixel.*;
	
	public class MenuState extends FlxState
	{		
		private static var T_DEBOUNCE:Number = 0.200;
		private static var FADE_INC:Number = 0.03;
		
		[Embed(source = "../assets/menu_chirp.mp3")] private var sound_MenuChirp:Class;
		[Embed(source = "../assets/intro.png")] private var img_Intro:Class;
		[Embed(source = "../assets/credits.png")] private var img_Credits:Class;
		
		private var _title:FlxText;
		private var _play:FlxText;
		private var _credits:FlxText;
		private var _copy:FlxText;
		private var _star:FlxSprite;
		private var _imgIntro:FlxSprite;
		private var _imgCredits:FlxSprite;
		
		private var _selected:FlxText;
		private var _debounce:Number;
		
		override public function create():void
		{	
			FlxG.stage.focus = null;
			
			_title = new FlxText(400, 200, 200, "BONK!");
			_title.size = 20;
			_title.color = 0xFF656565;

			_play = new FlxText(400, 250, 200, "PLAY");
			_play.size = 20;
			
			_credits = new FlxText(400, 300, 200, "CREDITS");
			_credits.size = 20;
			
			_copy = new FlxText(10, 460, 200, "(C) 2011 Charlie Thornton");
			_copy.color = 0xFF656565;
			
			_selected = _play;
			
			_star = new FlxSprite(370, 0).makeGraphic(10, 10);
			_star.y = _selected.y + (_selected.height / 2) - 6;
			
			_imgIntro = new FlxSprite(0, 0, img_Intro);
			_imgCredits = new FlxSprite(0, 0, img_Credits);
			_imgCredits.alpha = 0.0;
			
			add(_title);
			add(_play);
			add(_credits);
			add(_copy);
			add(_star);
			add(_imgIntro);
			add(_imgCredits);
		}
		
		override public function update():void
		{
			super.update();
			
			_debounce -= FlxG.elapsed;
			if (0.0 < _debounce) { return; }
			
			if (FlxG.keys.SPACE || FlxG.keys.ENTER)
			{
				_debounce = T_DEBOUNCE;
				if (_selected == _play)
				{
					_debounce = 1.0;
					_star.flicker(1.0);
					_selected.flicker(1.0);
					FlxG.fade(0xffffffff, 1, play);
				}
			}
			
			
			if (FlxG.keys.UP || FlxG.keys.DOWN)
			{
				_debounce = T_DEBOUNCE;
				
				FlxG.play(sound_MenuChirp, 0.5);
				_selected = (_selected == _play) ? _credits : _play;
				_star.y = _selected.y + (_selected.height/2) - 6
			}
			
			var fader:FlxSprite = (_selected == _play)? _imgCredits : _imgIntro;
			var viser:FlxSprite = (_selected == _play)? _imgIntro : _imgCredits;
			fader.alpha = Math.max(fader.alpha - FADE_INC, 0.0);
			viser.alpha = Math.min(viser.alpha + FADE_INC, 1.0);
		}
		
		private function play(): void
		{
			FlxG.switchState(new PlayState());
		}
	}

}