package  
{
	import org.flixel.*;
	
	public class PlayState extends FlxState
	{
		private static var ACCEL:int = 2000;
		
		private static var SCORE_AI:uint 	= 0;
		private static var SCORE_HUMAN:uint	= 1;
		
		[Embed(source = "../assets/boom.mp3")]
		private var sound_boom:Class;
		[Embed(source = "../assets/ai_win.mp3")]
		private var sound_aiWin:Class;
		[Embed(source = "../assets/human_win.mp3")]
		private var sound_humanWin:Class;
		[Embed(source = "../assets/chirp.mp3")]
		private var sound_chirp:Class;
		
		private var walls:FlxGroup;
		private var paddles:FlxGroup;
		private var paddleHuman:FlxSprite;
		private var paddleAi:FlxSprite;
		private var ball:FlxSprite;
		
		private var scoreAi:FlxText;
		private var scoreHuman:FlxText;
		private var spaceToStart:FlxText;
		
		override public function create():void
		{			
			paddleHuman = new FlxSprite();
			paddleHuman.makeGraphic(10, 60);
			paddleHuman.immovable = true;
			paddleHuman.maxVelocity.y = 300;
			paddleHuman.drag.y = 2000;
			
			paddleAi = new FlxSprite();
			paddleAi.makeGraphic(10, 60);
			paddleAi.immovable = true;
			paddleAi.maxVelocity.y = 100;
			paddleAi.drag.y = 2000;
			
			paddles = new FlxGroup();
			paddles.add(paddleHuman);
			paddles.add(paddleAi);
			
			var top:FlxSprite = new FlxSprite(0, -10);
			top.makeGraphic(FlxG.width, 10);
			top.immovable = true;
			
			var bottom:FlxSprite = new FlxSprite(0, FlxG.height);
			bottom.makeGraphic(FlxG.width, 10);
			bottom.immovable = true;
			
			walls = new FlxGroup();
			walls.add(top);
			walls.add(bottom);
			
			ball = new FlxSprite();
			ball.makeGraphic(10, 10);
			ball.elasticity = 1.0;
						
			scoreAi = new FlxText(240, 40, 60, "0");
			scoreAi.size = 30;
			scoreHuman = new FlxText(375, 40, 60, "0");
			scoreHuman.size = 30;
			spaceToStart = new FlxText(217, 280, 300, "Space to Start");
			spaceToStart.size = 24;
			
			// also add the cute divider wall
			add(new FlxSprite(FlxG.width / 2, 0).makeGraphic(1, FlxG.height, 0x40FFFFFF));
			
			FlxG.scores[SCORE_HUMAN] = 0;
			FlxG.scores[SCORE_AI] = 0;
			
			resetPositions();
			
			add(paddles);
			add(ball);
			add(walls);
			
			add(scoreAi);
			add(scoreHuman);
			add(spaceToStart);
		}
		
		private function resetPositions(): void
		{
			paddleHuman.x = 620;
			paddleHuman.y = (FlxG.height / 2) - (paddleHuman.height / 2);
			paddleHuman.velocity.y = 0;
			
			paddleAi.x = 10;
			paddleAi.y = 210;
			paddleAi.velocity.y = 0;
			
			ball.reset(315, 235);
			
			spaceToStart.visible = true;
		}
		
		private function startBall(): void
		{
			spaceToStart.visible = false;
			
			ball.velocity.x = 200 * ((Math.random() <= 0.5)? -1 : 1);
			ball.velocity.y = 30 * (Math.random() - 0.5);
		}
		
		override public function update():void
		{
			super.update();
			
			paddleHuman.y = Math.max(0, paddleHuman.y);
			paddleHuman.y = Math.min(FlxG.height - paddleHuman.height, paddleHuman.y);
			
			paddleAi.y = Math.max(0, paddleAi.y);
			paddleAi.y = Math.min(FlxG.height - paddleAi.height, paddleAi.y);
			
			if (FlxG.keys.ESCAPE)
			{
				FlxG.resetGame();
			}
			
			if (FlxG.keys.A && FlxG.keys.N && FlxG.keys.U)
			{
				paddleHuman.makeGraphic(10, paddleHuman.height + 2);
				paddleHuman.y -= 1;
			}
			
			if (checkForScore())
			{
				FlxG.flash(0xffffffff, 1.0, resetPositions);
			}
			
			if (ball.velocity.x == 0 && FlxG.keys.SPACE)
			{
				FlxG.play(sound_boom);
				startBall();
			}
			
			handlePlayer();
			handleAi();
			
			FlxG.collide(paddles, ball, hit);
			FlxG.collide(walls, ball, playChirp);
		
		}
		
		private function playChirp(wall:FlxSprite, ball:FlxSprite): void
		{
			FlxG.play(sound_chirp);
		}
		
		private function checkForScore(): Boolean
		{
			if (!ball.exists) { return false; }
			
			if (ball.x + ball.width < 0)
			{
				++FlxG.scores[SCORE_HUMAN];
				scoreHuman.text = FlxG.scores[SCORE_HUMAN];
				scoreHuman.flicker(1.5);
				FlxG.play(sound_humanWin);
				
				paddleAi.maxVelocity.y = Math.min(paddleHuman.maxVelocity.y, paddleAi.maxVelocity.y*1.05);
				
				ball.exists = false;
				
				return true;
			}
			else if (FlxG.width < ball.x)
			{
				++FlxG.scores[SCORE_AI];
				scoreAi.text = FlxG.scores[SCORE_AI];
				scoreAi.flicker(1.5);
				FlxG.play(sound_aiWin);
				
				ball.exists = false;
				
				return true;
			}
			else
			{
				return false;
			}
		}
		
		private function handlePlayer(): void
		{
			paddleHuman.acceleration.y = 0.0;
			if (FlxG.keys.UP) 		 { paddleHuman.acceleration.y = -ACCEL; }
			else if (FlxG.keys.DOWN) { paddleHuman.acceleration.y = ACCEL; }
		}
		
		private function handleAi(): void
		{
			var target:Number = FlxG.height / 2;
			if (ball.exists && 0 < Math.abs(ball.velocity.x))
			{
				target = (getPredictedBallIntersect() + (ball.height / 2));
			}
			
			var offset:Number = target - (paddleAi.y + (paddleAi.height / 2));
			if (Math.abs(offset) < (paddleAi.height / 2))
			{
				paddleAi.acceleration.y = 0.0;
			}
			else
			{
				if (offset < 0) { paddleAi.acceleration.y = -ACCEL; }
				else 			{ paddleAi.acceleration.y =  ACCEL; }
			}
		}
		
		private function getPredictedBallIntersect(): int
		{
			// for y=mx+b, solve for b -> b = y-mx
			var x:int = ball.x + (ball.width / 2);
			var y:int = ball.y + (ball.height / 2);
			var m:Number = ball.velocity.y / ball.velocity.x;
			
			return (int)(y - m * x);
		}
		
		private function hitWall(wall:FlxSprite, ball:FlxSprite):void
		{
			ball.velocity.y = -ball.velocity.y;
		}
		
		private function hit(paddle:FlxSprite, ball:FlxSprite):void
		{
			var paddleCenter:int = paddle.y + (paddle.height / 2);
			var ballCenter:int = ball.y + (ball.height / 2);
			var diff:int = ballCenter - paddleCenter;
			
			ball.velocity.x *= 1.05;
			ball.velocity.y = 5 * diff;
			
			FlxG.play(sound_chirp);
		}
	}

}