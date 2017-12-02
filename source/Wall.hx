package;

import flixel.util.FlxColor;
import flixel.FlxSprite;

class Wall extends FlxSprite
{
    public function new(?X:Float=0, ?Y:Float=0, ?width:Int=32, ?height:Int=32)
    {
        super(X, Y);
        makeGraphic(width, height, new FlxColor(0xffa0a0a0));
        immovable=true;
    }
}
