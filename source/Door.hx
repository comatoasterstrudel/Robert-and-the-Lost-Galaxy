package;

import flixel.FlxSprite;

class Door extends FlxSprite //this is stupid
{
    public var name:String = '';

    public function new(name:String){
        super();

        this.name = name;
    }
}