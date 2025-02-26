package;

import CircleTransition;
import DialogueBox;
import Door;
import Player;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.display.FlxBackdrop;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

class PlayState extends FlxState
{
	var player:Player;
	var background:FlxSprite;

	var speed:Float = 0;

	var basespeed:Float = 60;
	var runspeed:Float = 200;

	//groups of objects
	var barriers:FlxTypedGroup<FlxSprite>;
	var doors:FlxTypedGroup<Door>;
	var interactablesprites:FlxTypedGroup<InteractableSprite>;

	public static var roomname:String = 'scomparoom1';
	public static var previousroomname:String = '';

	public static var lastmusicplayed:String = '';

	public static var controlAllowed:Bool = true;

	var transitioningRooms:Bool = false;

	var camgame:FlxCamera;
	var camhud:FlxCamera;
	var camtop:FlxCamera;

	var dialoguebox:DialogueBox;

	override public function create()
	{
		//hello hello
				
		FlxG.mouse.visible = false;

		controlAllowed = true;

		super.create();

		makeMusic();

		camgame = new FlxCamera();
		camgame.bgColor = FlxColor.TRANSPARENT;
		FlxG.cameras.add(camgame, true);

		camhud = new FlxCamera();
		camhud.bgColor = FlxColor.TRANSPARENT;
		FlxG.cameras.add(camhud, false);

		camtop = new FlxCamera();
		camtop.bgColor = FlxColor.TRANSPARENT;
		FlxG.cameras.add(camtop, false);

		//objects and shit
		makeRoomContent();
		makeBarriers();
		makeDoors();
		makeInteractables();

		makePlayer();

		makeDialogueBox();

		camgame.follow(player, LOCKON, .2);

		var tran = new CircleTransition('in', .5); //FUCK
		tran.camera = camtop;
		add(tran);

		new FlxTimer().start(.5, function(tmr):Void{
			tran.destroy();
		});
	}

	override public function update(elapsed:Float)
	{  
		super.update(elapsed);

		FlxG.worldBounds.set(camgame.scroll.x, camgame.scroll.y, FlxG.width, FlxG.height); //FUCK EVERYTHING

		FlxG.collide(player, barriers);		

		for(i in doors.members){
			if(FlxG.overlap(player, i)){
				moveRooms(i.name);
			}
		}

		if(controlAllowed){
			for(i in interactablesprites.members){
				if(FlxG.overlap(player, i) && FlxG.keys.justReleased.Z){
					i.func();
				}
			}	
		}

		if(FlxG.keys.justReleased.SEVEN){ //show walls and shit cum
			for(i in barriers.members){
				i.visible = true;
			}
			for(i in doors.members){
				i.visible = true;
			}
			for(i in interactablesprites.members){
				i.visible = true;
			}
			trace(player.x + ', ' + player.y);
		}
	}
	
	function makeMusic():Void{
		switch(roomname){
			case 'scomparoom1' | 'scomparoom2' | 'scomparoomleftone':
				if(lastmusicplayed != 'Scompa23'){
					lastmusicplayed = 'Scompa23';
					FlxG.sound.playMusic(Paths.music('Scompa23', 'game'), 0);
					FlxG.sound.music.fadeIn(1, 0, .5);
				}
			default: //if theres no code for a room, use this one
				if(lastmusicplayed != 'Testsong'){
					lastmusicplayed = 'Testsong';
					FlxG.sound.playMusic(Paths.music('Testsong', 'game'), 0);
					FlxG.sound.music.fadeIn(1, 0, 1);
				}
		}
	}

	function makeRoomContent():Void{
		FlxG.camera.bgColor = FlxColor.PURPLE;
		
		switch(roomname){
			case 'scomparoom1':
				var backdrop = new FlxBackdrop('assets/game/images/Scompa23/StarsBG.png');
				backdrop.setGraphicSize(Std.int(backdrop.width * 8));
				backdrop.updateHitbox();
				backdrop.antialiasing = false;
				backdrop.velocity.set(10,10);
				add(backdrop);
				
				background = new FlxSprite().loadGraphic('assets/game/images/Scompa23/Scompa room 1.png');
				background.antialiasing = false;
				background.setGraphicSize(Std.int(background.width * 8));
				background.updateHitbox();
				background.screenCenter();
				add(background);
			case 'scomparoom2':
				var backdrop = new FlxBackdrop('assets/game/images/Scompa23/StarsBG.png');
				backdrop.setGraphicSize(Std.int(backdrop.width * 8));
				backdrop.updateHitbox();
				backdrop.antialiasing = false;
				backdrop.velocity.set(10,10);
				add(backdrop);

				background = new FlxSprite().loadGraphic('assets/game/images/Scompa23/Scompa room 2.png');
				background.antialiasing = false;
				background.setGraphicSize(Std.int(background.width * 8));
				background.updateHitbox();
				background.screenCenter();
				add(background);
			case 'scomparoomleftone':
				var backdrop = new FlxBackdrop('assets/game/images/Scompa23/StarsBG.png');
				backdrop.setGraphicSize(Std.int(backdrop.width * 8));
				backdrop.updateHitbox();
				backdrop.antialiasing = false;
				backdrop.velocity.set(10,10);
				add(backdrop);

				background = new FlxSprite().loadGraphic('assets/game/images/Scompa23/Scompa room left more.png');
				background.antialiasing = false;
				background.setGraphicSize(Std.int(background.width * 8));
				background.updateHitbox();
				background.screenCenter();
				add(background);
			default: //if theres no code for a room, use this one
				background = new FlxSprite().loadGraphic('assets/game/images/Penis.png');
				background.screenCenter();
				add(background);
		}
	}

	function makePlayer():Void{
		player = new Player('Robert Ottic');
		add(player);

		switch(roomname){ //player positioning :-)
			case 'scomparoom1':
				if(previousroomname == 'scomparoom2') player.y -= 140;
			case 'scomparoom2':
				if(previousroomname == 'scomparoom1') player.y += 650;
				if(previousroomname == 'scomparoomleftone') player.setPosition(300, -150);
			case 'scomparoomleftone':
				if(previousroomname == 'scomparoom2') player.setPosition(1610, 190);
		}
	}

	function makeDialogueBox():Void{
		dialoguebox = new DialogueBox();
		dialoguebox.camera = camhud;
		add(dialoguebox);
	}

	function makeBarriers():Void{
		barriers = new FlxTypedGroup<FlxSprite>();
		add(barriers);
		
		switch(roomname){
			case 'scomparoom1':
				addBarrier(background.x + background.width, background.y, 100, background.height); //right side
				addBarrier(background.x - 100, background.y, 100, background.height); //left side
				addBarrier(background.x - 100, background.y + 110, background.width + 200, 30); //top side
				addBarrier(background.x - 100, background.y + background.height, background.width + 200, 100); //bottom side
			case 'scomparoom2':
				addBarrier(background.x + background.width, background.y, 100, background.height); //right side
				addBarrier(background.x - 100, background.y, 100, background.height); //left side
				addBarrier(background.x - 100, background.y + 110, background.width + 200, 30); //top side
				addBarrier(background.x - 100, background.y + background.height, background.width + 200, 100); //bottom side
			case 'scomparoomleftone':
				addBarrier(background.x + background.width, background.y, 100, background.height); //right side
				addBarrier(background.x - 100, background.y, 100, background.height); //left side
				addBarrier(background.x - 100, background.y + 100, background.width + 200, 100); //top side
				addBarrier(background.x - 100, background.y + background.height, background.width + 200, 100); //bottom side
				addBarrier(200, 460, 2000, 900); //bottom right 
			default: //if theres no code for a room, use this one
				addBarrier(background.x + background.width, background.y, 100, background.height); //right side
				addBarrier(background.x - 100, background.y, 100, background.height); //left side
				addBarrier(background.x - 100, background.y - 100, background.width + 200, 100); //top side
				addBarrier(background.x - 100, background.y + background.height, background.width + 200, 100); //bottom side
		}
	}

	function addBarrier(x:Float, y:Float, width:Float, height:Float):Void{
		var barrier = new FlxSprite().makeGraphic(Std.int(width), Std.int(height), FlxColor.BLUE);
		barrier.setPosition(x, y);
		barrier.immovable = true;
		barrier.visible = false;
		barriers.add(barrier);
	}

	function makeDoors():Void{
		doors = new FlxTypedGroup<Door>();
		add(doors);

		switch(roomname){
			case 'scomparoom1':
				addDoor('scomparoom2', 0, 80, 200, 40, true, false);
			case 'scomparoom2':
				addDoor('scomparoom1', 0, 1100, 180, 40, true, false);
				addDoor('scomparoomleftone', 250, -200, 40, 250, false, false);
			case 'scomparoomleftone':
				addDoor('scomparoom2', 1750, 160, 40, 180, false, false);
		}
	}

	var dooramount:Int = 0;

	function addDoor(name:String, x:Float, y:Float, width:Float, height:Float, centerx:Bool, centery:Bool):Void{
		var door:Door = new Door(name);
		door.makeGraphic(Std.int(width), Std.int(height), FlxColor.GREEN);
		door.setPosition(x, y);
		if(centerx) door.screenCenter(X);
		if(centery) door.screenCenter(Y);
		door.immovable = true;
		door.visible = false;
		doors.add(door);
	}

	function makeInteractables():Void{
		interactablesprites = new FlxTypedGroup<InteractableSprite>();
		add(interactablesprites);

		switch(roomname){
			case 'scomparoom1':
				addInteractable(function():Void{ dialoguebox.startDialogue('placeholder', function():Void{}, null); }, 35, 280, 150, 180, false, false);
				addInteractable(function():Void{ trace('this is a skull'); }, 1100, 350, 100, 100, false, false);
		}
	}

	function addInteractable(func:Void->Void, x:Float, y:Float, width:Float, height:Float, centerx:Bool, centery:Bool):Void{
		var interactable:InteractableSprite = new InteractableSprite(func);
		interactable.makeGraphic(Std.int(width), Std.int(height), FlxColor.YELLOW);
		interactable.setPosition(x, y);
		if(centerx) interactable.screenCenter(X);
		if(centery) interactable.screenCenter(Y);
		interactable.immovable = true;
		interactable.visible = false;
		interactablesprites.add(interactable);
	}

	function moveRooms(name:String):Void{
		if(transitioningRooms) return;

		transitioningRooms = true;
		controlAllowed = false;

		var tran = new CircleTransition('out', .5);
		tran.camera = camtop;
		add(tran);

		new FlxTimer().start(.5, function(tmr):Void{
			PlayState.previousroomname = PlayState.roomname;
			PlayState.roomname = name;

			FlxG.switchState(new PlayState());
		});
	}
}

/*


.__           .__  .__          
|  |__   ____ |  | |  |   ____  
|  |  \_/ __ \|  | |  |  /  _ \ 
|   Y  \  ___/|  |_|  |_(  <_> )
|___|  /\___  >____/____/\____/ 
     \/     \/                  


*/