package;

import Paths;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.util.FlxColor;

class Player extends FlxSprite
{
	var speed:Float = 0;

	var basespeed:Float = 110;
	var runspeed:Float = 200;

	var name:String = '';
	
	public static var lastidle:String = 'idle';

	override public function new(name:String = ''){
		super();

		this.name = name;

		frames = Paths.getSparrowAtlas('chars/' + name, 'game');
		setGraphicSize(Std.int(width * 8));
		updateHitbox();
		screenCenter();
		antialiasing = false;

		animation.addByPrefix('idle', 'idle down', 1); //normal idle
		animation.addByPrefix('idle up', 'idle up', 1); //character looking up idle
		animation.addByPrefix('idle horizontal', 'idle horizontal', 1); //character looking right idle
		animation.addByPrefix('walk down', 'walk down', 2); //walking down
		animation.addByPrefix('walk up', 'walk up', 2); //walking up
		animation.addByPrefix('walk horizontal', 'walk horizontal', 2); //walking right
		animation.addByPrefix('run down', 'walk down', 4); //run down
		animation.addByPrefix('run up', 'walk up', 4); //run up
		animation.addByPrefix('run horizontal', 'walk horizontal', 4); //run right

		animation.play('idle');
	}

	override public function update(elapsed:Float)
	{  
		velocity.set(0, 0);

		var running = FlxG.keys.pressed.SHIFT;

		if(running){
			speed = runspeed;
		} else {
			speed = basespeed;
		}

		if(PlayState.controlAllowed){
			if(FlxG.keys.pressed.LEFT){
				if(running) animation.play('run horizontal'); else animation.play('walk horizontal'); 
				flipX = true;
	
				velocity.x = -speed;

				lastidle = 'idle horizontal';
			} else if(FlxG.keys.pressed.RIGHT){
				if(running) animation.play('run horizontal'); else animation.play('walk horizontal'); 
				flipX = false;
	
				velocity.x = speed;
	
				lastidle = 'idle horizontal';
			}
	
			if(FlxG.keys.pressed.UP){
				if(running) animation.play('run up'); else animation.play('walk up'); 
				flipX = false;
	
				velocity.y = -speed;
	
				lastidle = 'idle up';
			} else if(FlxG.keys.pressed.DOWN){
				if(running) animation.play('run down'); else animation.play('walk down'); 
				flipX = false;
	
				velocity.y = speed;
	
				lastidle = 'idle';
			}
		}
			
		if(velocity.x == 0 && velocity.y == 0){
			animation.play(lastidle);
		}
		

		//player momve :3
		
		super.update(elapsed);
	}
}
