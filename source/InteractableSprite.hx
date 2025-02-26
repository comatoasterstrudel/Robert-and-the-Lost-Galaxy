package;

import flixel.FlxSprite;

class InteractableSprite extends FlxSprite //this is stupid 2
{
    public var func:Void->Void;

    public function new(func:Void -> Void){
        super();

        this.func = func;
    }
}