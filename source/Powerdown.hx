package;

import flixel.util.FlxColor;
import flixel.FlxSprite;
import flixel.FlxG;

class Powerdown extends FlxSprite
{
    public var key:FlxKey;
    public function new(key:FlxKey, ?X:Float=0, ?Y:Float=0)
    {
        super(X, Y);
        makeGraphic(32, 32, new FlxColor(0xff00ff00));
        immovable=true;
    }
}
