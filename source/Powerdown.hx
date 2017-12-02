package;

import flixel.util.FlxColor;
import flixel.FlxSprite;
import flixel.FlxG;
import flixel.input.keyboard.FlxKey;

class Powerdown extends FlxSprite
{
    public var key:FlxKey;
    public function new(key:FlxKey, ?X:Float=0, ?Y:Float=0)
    {
        super(X, Y);
        this.key = key;
        switch(key) {
            case LEFT: loadGraphic("assets/images/leftarrow.png");
            case RIGHT: loadGraphic("assets/images/rightarrow.png");
            case DOWN: loadGraphic("assets/images/downarrow.png");
            case UP: loadGraphic("assets/images/uparrow.png");
            default: makeGraphic(32, 32, new FlxColor(0xff00ff00));
        }
        immovable=true;
    }
}
