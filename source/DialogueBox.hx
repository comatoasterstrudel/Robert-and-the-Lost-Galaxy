package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.text.FlxTypeText;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup;
import flixel.input.gamepad.FlxGamepad;
import flixel.input.gamepad.FlxGamepadButton;
import flixel.input.gamepad.FlxGamepadInputID;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;

class DialogueBox extends FlxTypedGroup<FlxSprite>
{
    var dialoguebox:FlxSprite;

    var dialoguetext:FlxTypeText;

    var shouldbevisible:Bool = false;

    var controlallowed:Bool = false;

    var endfunc:Void->Void;
    var startfunc:Void->Void;

    var finishedtyping:Bool = false;

    var diaheight:Float = 1000;

    var setthisafter:Bool = false;

    public function new():Void{
        super();

        dialoguebox = new FlxSprite().loadGraphic(Paths.image('dialogue/box', 'game'));
        dialoguebox.setGraphicSize(dialoguebox.width * 8);
        dialoguebox.updateHitbox();
        dialoguebox.screenCenter(X);
        dialoguebox.y = FlxG.height - dialoguebox.height;
        dialoguebox.antialiasing = false;
        add(dialoguebox);

        dialoguetext = new FlxTypeText(0,0, Std.int(dialoguebox.width * .95),"hi :-) this is a test.. what if i type too long? will it go down a line?", 35);
		dialoguetext.screenCenter();
		dialoguetext.antialiasing = true;
		add(dialoguetext);
    }

    override public function update(elapsed:Float){
        super.update(elapsed);

        var gamepad:FlxGamepad = FlxG.gamepads.lastActive;

        if(controlallowed){
            var debug = false;

            #if debug
            debug = true;
            #end
            
            if(FlxG.keys.justPressed.Z || gamepad != null && gamepad.justPressed.A ||FlxG.keys.justPressed.ENTER || debug && FlxG.keys.pressed.SEVEN){
                if(finishedtyping){
                    progress ++;
                    dotheline();
                } else {
                    dialoguetext.skip();
                }
            }    
        }

        //dialoguetext.x = dialoguebox.x + dialoguebox.width / 2 - dialoguetext.width / 2; //im stupid why didnt i just center this T-T
        dialoguetext.screenCenter(X);
        dialoguetext.y = dialoguebox.y + 30;

        visible = shouldbevisible; 
    }

    var thedata:Array<Array<String>> = [];

    var progress:Int = 0;

    public function startDialogue(filename:String, endfunc:Void->Void, ?startfunc:Void -> Void):Void{
        this.endfunc = endfunc;
        this.startfunc = startfunc;

        var notreallythedata = Utilities.dataFromTextFile('assets/game/data/dialogue/' + filename + '.txt');

        thedata = [];
        progress = 0;
        dialoguetext.resetText(''); 
        dialoguetext.start();
        
        for(i in notreallythedata){
            thedata.push(i.split(":"));
        }
        
        shouldbevisible = true;

        dialoguebox.y = FlxG.height - 5;

        FlxTween.tween(dialoguebox, {y: 450}, .5, {ease:FlxEase.quartOut, onComplete: function(f):Void{
            if(startfunc != null) startfunc();
            
            controlallowed = true;
            dotheline();
        }});

        setthisafter = PlayState.controlAllowed;
        PlayState.controlAllowed = false;
    }

    function dotheline():Void{        
        if(progress >= thedata.length){
            finish();
            return;
        }

        finishedtyping = false;
        dialoguetext.completeCallback = function():Void { finishedtyping = true; };

        dialoguetext.resetText(thedata[progress][0]);

       // dialoguetext.sounds = [FlxG.sound.load(thedata[progress][4])];

        dialoguetext.start(Std.parseFloat(thedata[progress][1]));
    }

    function finish(){
        controlallowed = false;
        
        FlxTween.tween(dialoguebox, {y: diaheight}, .5, {ease:FlxEase.quartIn, onComplete: function(f):Void{
            shouldbevisible = false;
            endfunc();
            PlayState.controlAllowed = setthisafter;
        }});
    }
}