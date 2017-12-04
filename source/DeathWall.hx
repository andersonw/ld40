package;

import flixel.util.FlxColor;
import flixel.FlxSprite;

class DeathWall extends Wall
{
    public function new(?X:Float=0, ?Y:Float=0, ?width:Int=32, ?height:Int=32)
    {
        super(X, Y, width, height);
        makeGraphic(width, height, new FlxColor(0xffdeaded));
        alpha = 0;
        immovable=true;
    }
}
